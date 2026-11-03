# illumos-vm: work with the OmniOS build VM from the host.
#
# omnios-vm.nix puts these lines before this file:
#   vm           user@address of the VM
#   domain       libvirt name of the VM
#   cc_wrapper   cc-wrapper.sh, installed in the VM by make and build
#   ccdb_script  ccdb.py, run in the VM by ccdb
#
# The edit loop: edit in the gate, `sync`, then `make DIR` for one part, or
# `build` for all of it. Before you submit: a full `build` (no -i or -q),
# then `pbchk`.

gate=${ILLUMOS_GATE:-$HOME/Dev/illumos-gate}
remote_gate=/build/illumos-gate
remote_env=/build/env
ssh_opts=(-o StrictHostKeyChecking=accept-new)

run() { ssh "${ssh_opts[@]}" "$vm" "$@"; }

usage() {
	cat <<EOF
Usage: illumos-vm COMMAND

  ssh [ARGS]           SSH to the VM
  console              Attach to the VM's serial console (exit with Ctrl-])

  sync [REV]           Push REV (default @, your working copy) to the VM
  make [DIR] [TARGET]  Build one directory with dmake (default: the current
                       directory, and target install). Needs one full build
                       first. Use it for day-to-day work.
  build [-i] [-q]      Start nightly in the VM and follow it.
                       -i: incremental (no clobber)
                       -q: quick (no shadow compilers, no style or ABI checks)
                       Before you submit, run a full build: no -i and no -q.
  watch                Follow the running build again
  stop                 Stop the running build and remove its lock files
  ccdb                 Copy compile_commands.json and headers to the gate
  pbchk                Check the synced commits with git pbchk
  onu                  Install the last build in a new boot environment, reboot

Ctrl-C while you follow a build stops only the following. The build goes on.
EOF
}

# Fail if a nightly build is running in the VM.
not_running() {
	if run 'pid=$(cat /build/nightly.pid 2>/dev/null) && kill -0 "$pid" 2>/dev/null'; then
		echo "illumos-vm: a build is running. Use 'illumos-vm watch' or 'illumos-vm stop'." >&2
		exit 1
	fi
}

# Install the compiler wrapper and write the env files. Run before each build.
prepare() {
	run "mkdir -p /build/ccdb /build/ccdb-bin $remote_env \
		&& cat > /build/ccdb-bin/gcc && chmod +x /build/ccdb-bin/gcc \
		&& ln -sf gcc /build/ccdb-bin/g++" <"$cc_wrapper"
	run "cat > $remote_env/illumos.sh" <<EOF
# Written by illumos-vm on each build. Put your own settings in local.sh.
. /opt/onbld/env/omnios-illumos-gate
# DEBUG build only, as in the gate's usr/src/tools/env/illumos.sh. The
# OmniOS file adds a non-DEBUG build, which doubles the build time.
export NIGHTLY_OPTIONS='-FnCDAmprt'
# Log each compile for illumos-vm ccdb (clangd).
export PRIMARY_CC=gcc10,/build/ccdb-bin/gcc,gnu
export PRIMARY_CCC=gcc10,/build/ccdb-bin/g++,gnu
if [ -f $remote_env/local.sh ]; then . $remote_env/local.sh; fi
EOF
	run "cat > $remote_env/quick.sh" <<EOF
# Written by illumos-vm on each build. A quick build, as in Helios:
# no shadow compilers (gcc14, smatch), no cstyle, ABI, or ELF checks.
. $remote_env/illumos.sh
export NIGHTLY_OPTIONS='-FnDmpt'
export SHADOW_CCS= SHADOW_CCCS=
EOF
}

# Follow the build until it ends, then show the summary. Exit with its status.
follow() {
	echo "illumos-vm: following the build. Ctrl-C stops following; the build goes on."
	run 'bash -s' <<'EOF'
cd /build/illumos-gate
pid=$(cat /build/nightly.pid 2>/dev/null)
if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
	# Compiler output, live. nightly writes log/nightly.log only at the end
	# of each step, so print only its step headers.
	tail -F usr/src/install-i386.out usr/src/install-nd-i386.out 2>/dev/null &
	tail_pid=$!
	shown=0
	while kill -0 "$pid" 2>/dev/null; do
		steps=$(grep -c '^==== ' log/nightly.log 2>/dev/null) || steps=0
		if [ "$steps" -gt "$shown" ]; then
			grep '^==== ' log/nightly.log | tail -n +$((shown + 1))
			shown=$steps
		fi
		sleep 5
	done
	kill "$tail_pid" 2>/dev/null
else
	echo "No build is running. The last build:"
fi
status=$(cat /build/nightly.status 2>/dev/null || echo unknown)
mail=$(ls -td log/log.* 2>/dev/null | head -1)/mail_msg
if [ -f "$mail" ]; then
	echo "==== $mail (last 40 lines)"
	tail -40 "$mail"
fi
echo "==== nightly exit status: $status"
[ "$status" = 0 ]
EOF
}

case "${1:-}" in
ssh)
	shift
	run "$@"
	;;
console)
	exec virsh -c qemu:///system console "$domain"
	;;
sync)
	rev=${2:-@}
	commit=$(jj -R "$gate" log --no-graph -r "$rev" -T commit_id)
	trunk=$(jj -R "$gate" log --no-graph -r 'trunk()' -T commit_id)
	run "test -d $remote_gate/.git || git init -q $remote_gate"
	# trunk is the base for git pbchk.
	GIT_SSH_COMMAND="ssh ${ssh_opts[*]}" git -C "$gate" push -q -f "ssh://$vm$remote_gate" \
		"$commit:refs/heads/vm-build" "$trunk:refs/heads/trunk"
	run "cd $remote_gate && git checkout -q -f --detach vm-build && git log -1 --oneline"
	;;
make)
	dir=${2:-}
	target=${3:-install}
	if [ -z "$dir" ]; then
		here=$(realpath .)
		top=$(realpath "$gate")
		case $here in
		"$top"/usr/src/*) dir=${here#"$top"/} ;;
		*)
			echo "illumos-vm make: give DIR, or run it in $top/usr/src/..." >&2
			exit 2
			;;
		esac
	fi
	dir=${dir#/}
	dir=${dir#usr/src/}
	not_running
	prepare
	# The gate's own bldenv, from the last build. -d: DEBUG.
	run "cd $remote_gate \
		&& b=usr/src/tools/proto/root_i386-nd/opt/onbld/bin/bldenv \
		&& { test -x \$b || b=/opt/onbld/bin/bldenv; } \
		&& \$b -d $remote_env/illumos.sh 'cd usr/src/$dir && dmake -S $target'"
	;;
build)
	shift
	flags=""
	env=illumos.sh
	for arg in "$@"; do
		case $arg in
		-i) flags=-i ;;
		-q) env=quick.sh ;;
		*)
			usage
			exit 2
			;;
		esac
	done
	not_running
	prepare
	# A full build starts a new compiler log for ccdb.
	if [ -z "$flags" ]; then run "rm -rf /build/ccdb/*"; fi
	# nohup and setpgrp detach nightly from this SSH session, so it goes on
	# if the session ends. Its process group is its PID, for `stop`.
	run "cd $remote_gate && rm -f /build/nightly.status \
		usr/src/install-i386.out usr/src/install-nd-i386.out \
		&& { nohup setpgrp ksh -c './usr/src/tools/scripts/nightly $flags $remote_env/$env; \
			echo \$? > /build/nightly.status' > /dev/null 2>&1 < /dev/null & \
			echo \$! > /build/nightly.pid; }"
	echo "illumos-vm: started nightly $flags with $remote_env/$env at $(run "cd $remote_gate && git log -1 --oneline")"
	follow
	;;
watch)
	follow
	;;
stop)
	run 'bash -s' <<'EOF'
pid=$(cat /build/nightly.pid 2>/dev/null)
if [ -z "$pid" ] || ! kill -0 "$pid" 2>/dev/null; then
	echo "No build is running."
	exit 0
fi
echo "Stopping the build (process group $pid)."
kill -TERM -- -"$pid"
i=0
while pgrep -g "$pid" >/dev/null && [ $i -lt 30 ]; do
	sleep 2
	i=$((i + 1))
done
if pgrep -g "$pid" >/dev/null; then
	echo "It did not stop in 60 seconds. Killing it."
	kill -KILL -- -"$pid"
	sleep 2
fi
# A stopped build leaves lock files that make the next build fail.
cd /build/illumos-gate
find . -name .make.state.lock -exec rm -f {} + 2>/dev/null
rm -f log/nightly.lock
echo 130 > /build/nightly.status
echo "Stopped. Some files can be half-written: run a full build next, not -i."
EOF
	;;
ccdb)
	gate=$(realpath "$gate")
	tmp=$(mktemp)
	trap 'rm -f "$tmp"' EXIT
	run "python3 - $remote_gate $gate" <"$ccdb_script" >"$tmp"
	# Hide the new files from jj before they appear. The gate's .gitignore
	# covers proto/, and .cache/ gets its own .gitignore.
	exclude=$gate/.git/info/exclude
	mkdir -p "$(dirname "$exclude")"
	{
		sed '/^# illumos-vm ccdb begin$/,/^# illumos-vm ccdb end$/d' "$exclude" 2>/dev/null || true
		echo "# illumos-vm ccdb begin"
		printf '%s\n' /compile_commands.json /.nvim.lua /.cache/
		tar -tf "$tmp" | grep -v -e '^proto/' -e '^\.cache/' -e '^compile_commands.json$' | sed 's|^|/|' || true
		echo "# illumos-vm ccdb end"
	} >"$exclude.new"
	mv "$exclude.new" "$exclude"
	tar -xf "$tmp" -C "$gate"
	# The project's Neovim settings live in nix-config.
	nvim_lua=$HOME/Dev/nix-config/devshells/illumos/nvim.lua
	if [ ! -e "$gate/.nvim.lua" ] && [ -f "$nvim_lua" ]; then
		ln -s "$nvim_lua" "$gate/.nvim.lua"
	fi
	echo "compile_commands.json: $(grep -c '"file"' "$gate/compile_commands.json") files"
	;;
pbchk)
	run "cd $remote_gate && PATH=/opt/onbld/bin:\$PATH git-pbchk -p trunk"
	;;
onu)
	not_running
	be="nightly-$(date -u +%Y%m%d-%H%MZ)"
	run "cd $remote_gate \
		&& pfexec ./usr/src/tools/proto/root_i386-nd/opt/onbld/bin/onu -t $be -d packages/i386/nightly \
		&& pfexec reboot"
	;;
*)
	usage
	;;
esac
