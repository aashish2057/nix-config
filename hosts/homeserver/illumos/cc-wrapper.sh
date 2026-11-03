#!/bin/bash
# Installed in the OmniOS VM as /build/ccdb-bin/gcc and g++ by `illumos-vm build`.
# illumos.sh sets PRIMARY_CC and PRIMARY_CCC to it. cw calls it with the real
# GCC flags, so it saves one log file per call to /build/ccdb, then runs GCC.
# `illumos-vm ccdb` turns the logs into compile_commands.json.
name=${0##*/}
if log=$(mktemp /build/ccdb/XXXXXXXXXX 2>/dev/null); then
	printf '%s\0' "$PWD" "$name" "$@" >"$log"
fi
exec /opt/gcc-10/bin/"$name" "$@"
