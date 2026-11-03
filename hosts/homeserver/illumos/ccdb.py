"""Make clangd data from an illumos build. Runs in the OmniOS VM.

Usage: python3 - VM_GATE HOST_GATE < ccdb.py > out.tar

Writes a tar stream to stdout. `illumos-vm ccdb` unpacks it into the host gate.
The tar holds:
  - compile_commands.json, from the compiler logs in /build/ccdb, with VM
    paths changed to host paths.
  - every generated header (untracked *.h, proto area included). A header
    that is a copy of a tracked file is a symlink to that file, so "go to
    definition" opens the source, not the copy.
"""

import io
import json
import os
import subprocess
import sys
import tarfile

LOG_DIR = "/build/ccdb"
SOURCE_EXT = (".c", ".cc", ".cpp", ".cxx")
# The host clangd defaults to a Linux target. This gives it the illumos
# macros (__sun, __SVR4) and the correct type sizes.
TARGET = "--target=x86_64-pc-solaris2.11"
SKIP_DIRS = ("log/", "packages/")

vm_gate, host_gate = sys.argv[1].rstrip("/"), sys.argv[2].rstrip("/")


def to_host(s):
    return s.replace(vm_gate, host_gate)


def git(*args, stdin=None):
    return subprocess.run(
        ["git", *args], cwd=vm_gate, input=stdin, capture_output=True, check=True
    ).stdout


def compile_commands():
    # DEBUG and non-DEBUG, 32- and 64-bit builds compile most files more than
    # once. Keep one entry per file: prefer 64-bit, then DEBUG, then newest.
    best = {}
    for entry in os.scandir(LOG_DIR):
        with open(entry.path, "rb") as f:
            parts = [p.decode("utf-8", "surrogateescape") for p in f.read().split(b"\0")[:-1]]
        if len(parts) < 3:
            continue
        cwd, name, args = parts[0], parts[1], parts[2:]
        if "-c" not in args:
            continue
        src = None
        for i, a in enumerate(args):
            if a.endswith(SOURCE_EXT) and (i == 0 or args[i - 1] != "-o"):
                src = a
        if src is None:
            continue
        path = os.path.normpath(os.path.join(cwd, src))
        if not path.startswith(vm_gate + "/"):
            continue
        score = ("-m64" in args, "-DDEBUG" in args, entry.stat().st_mtime)
        if path not in best or score > best[path][0]:
            best[path] = (score, cwd, name, args)

    db = [
        {
            "directory": to_host(cwd),
            "file": to_host(path),
            "arguments": [name, TARGET] + [to_host(a) for a in args],
        }
        for path, (_, cwd, name, args) in sorted(best.items())
    ]
    return json.dumps(db, indent=1).encode()


def generated_headers():
    paths = [
        p.decode()
        for p in git("ls-files", "-o", "-z", "--", "*.h").split(b"\0")
        if p and not p.decode().startswith(SKIP_DIRS)
    ]
    tracked = {}
    for line in git("ls-files", "-s", "-z").split(b"\0"):
        if line:
            meta, path = line.decode().split("\t", 1)
            tracked.setdefault(meta.split()[1], path)
    hashes = git("hash-object", "--stdin-paths", stdin="\n".join(paths).encode()).decode().split()
    return [(p, tracked.get(h)) for p, h in zip(paths, hashes)]


def main():
    out = tarfile.open(fileobj=sys.stdout.buffer, mode="w|")
    data = compile_commands()
    info = tarfile.TarInfo("compile_commands.json")
    info.size = len(data)
    out.addfile(info, io.BytesIO(data))
    for path, source in generated_headers():
        if source:
            info = tarfile.TarInfo(path)
            info.type = tarfile.SYMTYPE
            info.linkname = os.path.relpath(source, os.path.dirname(path))
            out.addfile(info)
        else:
            out.add(os.path.join(vm_gate, path), arcname=path)
    out.close()


main()
