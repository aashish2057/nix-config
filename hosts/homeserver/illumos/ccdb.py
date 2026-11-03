"""Make clangd data from an illumos build. Runs in the OmniOS VM.

Usage: python3 - VM_GATE HOST_GATE < ccdb.py > out.tar

Writes a tar stream to stdout. `illumos-vm ccdb` unpacks it into the host gate.
The tar holds:
  - compile_commands.json, from the compiler logs in /build/ccdb, with VM
    paths changed to host paths and the flags changed for clang.
  - every generated include file (untracked *.h, *.def, *.ndl, ..., proto
    area included). One that is a copy of a tracked file is a symlink to
    that file, so "go to definition" opens the source, not the copy.
  - the symlinks the build makes to header directories (for example
    machine -> ... in the boot loader).
  - .cache/illumos-sysroot: the VM's system headers (/usr/include and the
    other include directories outside the gate that the build uses).
"""

import io
import json
import os
import subprocess
import sys
import tarfile
import time

LOG_DIR = "/build/ccdb"
SOURCE_EXT = (".c", ".cc", ".cpp", ".cxx")
# The host clangd defaults to a Linux target. This gives it the illumos
# macros (__sun, __SVR4) and the correct type sizes.
TARGET = "--target=x86_64-pc-solaris2.11"
# Make clang's built-in macros match the illumos GCC. Clang's Solaris target
# defines these four, so kernel headers take the wrong branches (for example
# <sys/time.h> includes <time.h>). They come before the build's own flags, so
# a file that sets one of them on purpose still gets it.
MATCH_GCC = [
    "-U__EXTENSIONS__",
    "-U_XOPEN_SOURCE",
    "-U_LARGEFILE_SOURCE",
    "-U_LARGEFILE64_SOURCE",
    "-D__illumos__",
]
# In C++ mode the illumos g++ defines the four as clang does, and also
# __STDC_VERSION__, which libstdc++ needs.
MATCH_GXX = ["-D__illumos__", "-D__STDC_VERSION__=199901L"]
SKIP_DIRS = ("log/", "packages/")

# GCC flags that clang rejects. Found by testing every flag in a full build.
GCC_ONLY = {
    "-ffloat-store",
    "-fno-aggressive-loop-optimizations",
    "-fno-clone-functions",
    "-fno-inline-functions-called-once",
    "-fno-inline-small-functions",
    "-fno-ipa-cp",
    "-fno-ipa-icf",
    "-fno-reorder-blocks-and-partition",
    "-fno-reorder-functions",
    "-fno-shrink-wrap",
    "-fno-unit-at-a-time",
    "-mindirect-branch-register",
    "-mindirect-branch=thunk-extern",
    "-msave-args",
    "-Wno-clobbered",
    "-Wno-dangling-pointer",
    "-Wno-maybe-uninitialized",
    # Show warnings as warnings in the editor, not as errors.
    "-Werror",
}
# Old Sun-style code (#pragma align, K&R calls) that clang warns about.
QUIET = ["-Wno-unknown-pragmas", "-Wno-ignored-pragmas", "-Wno-deprecated-non-prototype"]
# The VM's system headers go here in the host gate (.cache/ is ignored).
SYSROOT = ".cache/illumos-sysroot"
HEADER_EXT = (".h", ".hh", ".hpp", ".inc", ".def")

vm_gate, host_gate = sys.argv[1].rstrip("/"), sys.argv[2].rstrip("/")
host_sysroot = host_gate + "/" + SYSROOT


def to_host(s):
    return s.replace(vm_gate, host_gate)


def git(*args, stdin=None):
    return subprocess.run(
        ["git", *args], cwd=vm_gate, input=stdin, capture_output=True, check=True
    ).stdout


def tracked_files():
    """Map of blob hash to path, and the set of paths, for tracked files."""
    by_hash, paths = {}, set()
    for line in git("ls-files", "-s", "-z").split(b"\0"):
        if line:
            meta, path = line.decode().split("\t", 1)
            by_hash.setdefault(meta.split()[1], path)
            paths.add(path)
    return by_hash, paths


def outside_gate(d):
    return d.startswith("/") and not d.startswith(vm_gate + "/") and d != vm_gate


def cxx_dirs():
    """The C++ standard library directories of the build's g++."""
    err = subprocess.run(
        ["/opt/gcc-10/bin/g++", "-m64", "-xc++", "-E", "-v", "/dev/null"],
        capture_output=True, text=True,
    ).stderr
    dirs, inside = [], False
    for line in err.splitlines():
        if line.startswith("#include <...>"):
            inside = True
        elif line.startswith("End of search list"):
            break
        elif inside and "/c++/" in line:
            dirs.append(os.path.normpath(line.strip()))
    return dirs


CXX_DIRS = cxx_dirs()


def clang_args(name, args, system_dirs):
    out = []
    if name == "g++":
        for d in CXX_DIRS:
            out += ["-isystem", host_sysroot + d]
            system_dirs.add(d)
    for a in args:
        if a in GCC_ONLY:
            continue
        if a == "-nostdinc":
            # -nostdinc also hides clang's own headers (stddef.h, stdarg.h).
            # -nostdlibinc hides only the system headers, as the build wants.
            out.append("-nostdlibinc")
        elif a.startswith("-I") and outside_gate(a[2:]):
            d = os.path.normpath(a[2:])
            if os.path.isdir(d):
                system_dirs.add(d)
                out.append("-I" + host_sysroot + d)
        else:
            out.append(to_host(a))
    if "-nostdinc" not in args:
        # GCC searches the VM's /usr/include last. Do the same with the copy.
        out += ["-idirafter", host_sysroot + "/usr/include"]
        system_dirs.add("/usr/include")
    return out


def compile_commands(tracked_paths, system_dirs, build_dirs):
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
        # Skip sources the build generates. They aren't in the host gate.
        if os.path.relpath(path, vm_gate) not in tracked_paths:
            continue
        score = ("-m64" in args, "-DDEBUG" in args, entry.stat().st_mtime)
        if path not in best or score > best[path][0]:
            best[path] = (score, cwd, name, args)

    # Build directories (for example amd64/) hold no tracked files, so the
    # host gate lacks them. clangd needs them to exist.
    tracked_dirs = {os.path.dirname(p) for p in tracked_paths}
    build_dirs.update(
        rel for rel in (os.path.relpath(cwd, vm_gate) for _, cwd, _, _ in best.values())
        if not rel.startswith("..") and rel not in tracked_dirs
    )

    db = [
        {
            "directory": to_host(cwd),
            "file": to_host(path),
            "arguments": [name, TARGET]
            + (MATCH_GXX if name == "g++" else MATCH_GCC)
            + clang_args(name, args, system_dirs)
            + QUIET,
        }
        for path, (_, cwd, name, args) in sorted(best.items())
    ]
    return json.dumps(db, indent=1).encode()


def untracked():
    return [
        p.decode()
        for p in git("ls-files", "-o", "-z").split(b"\0")
        if p and not p.decode().startswith(SKIP_DIRS)
    ]


def add_symlink(out, path, target):
    info = tarfile.TarInfo(path)
    info.type = tarfile.SYMTYPE
    info.linkname = target
    out.addfile(info)


def add_generated(out, by_hash):
    paths = untracked()
    # Generated include files: headers, plus yacc .def and mlrpc .ndl files.
    headers = [p for p in paths if p.endswith(HEADER_EXT + (".ndl",))]
    hashes = git("hash-object", "--stdin-paths", stdin="\n".join(headers).encode()).decode().split()
    for path, h in zip(headers, hashes):
        source = by_hash.get(h)
        if source:
            add_symlink(out, path, os.path.relpath(source, os.path.dirname(path)))
        else:
            out.add(os.path.join(vm_gate, path), arcname=path)
    # Symlinks the build makes to header directories.
    for path in paths:
        full = os.path.join(vm_gate, path)
        if os.path.islink(full) and os.path.isdir(full):
            target = os.readlink(full)
            if target.startswith(vm_gate + "/"):
                target = os.path.relpath(target, os.path.dirname(full))
            add_symlink(out, path, target)


def add_system_headers(out, system_dirs):
    # Skip directories inside another copied directory.
    dirs = sorted(system_dirs)
    dirs = [d for d in dirs if not any(d.startswith(p + "/") for p in dirs)]
    for top in dirs:
        for root, _, files in os.walk(top, followlinks=True):
            for name in files:
                # C++ headers like <cstdarg> have no extension.
                if top != "/usr/include" and top not in CXX_DIRS and not name.endswith(HEADER_EXT):
                    continue
                full = os.path.join(root, name)
                real = os.path.realpath(full)
                if not os.path.isfile(real):
                    continue
                info = out.gettarinfo(real, arcname=SYSROOT + full)
                with open(real, "rb") as f:
                    out.addfile(info, f)


def main():
    by_hash, tracked_paths = tracked_files()
    system_dirs, build_dirs = set(), set()
    out = tarfile.open(fileobj=sys.stdout.buffer, mode="w|")
    data = compile_commands(tracked_paths, system_dirs, build_dirs)
    info = tarfile.TarInfo("compile_commands.json")
    info.size = len(data)
    info.mtime = int(time.time())
    out.addfile(info, io.BytesIO(data))
    for d in sorted(build_dirs):
        info = tarfile.TarInfo(d)
        info.type = tarfile.DIRTYPE
        info.mode = 0o755
        info.mtime = int(time.time())
        out.addfile(info)
    # Hide .cache (the system headers and clangd's index) from git, jj, and
    # fff. fff reads .gitignore files but not .git/info/exclude.
    data = b"# Made by illumos-vm ccdb.\n*\n"
    info = tarfile.TarInfo(SYSROOT.split("/")[0] + "/.gitignore")
    info.size = len(data)
    info.mtime = int(time.time())
    out.addfile(info, io.BytesIO(data))
    add_generated(out, by_hash)
    add_system_headers(out, system_dirs)
    out.close()


main()
