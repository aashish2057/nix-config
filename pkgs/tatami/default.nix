{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_17,
  apple-sdk,
}:
stdenv.mkDerivation {
  pname = "tatami";
  version = "0-unstable-2026-11-11";

  src = fetchFromGitHub {
    owner = "gakonst";
    repo = "tatami";
    rev = "1cb357ae026a9a888ebe67dd4a9af9b4b835edd1";
    hash = "sha256-9I18PEwAE+JnBFZKezO7cs59JDlNA3WX30Nqh2j5YKs=";
  };

  patches = [./mouse-follows-focus.patch];

  nativeBuildInputs = [zig_0_17.hook];

  buildInputs = [apple-sdk];

  zigBuildFlags = ["-Doptimize=ReleaseSafe"];

  postPatch = ''
    substituteInPlace build.zig \
      --replace-fail 'exe_module.linkSystemLibrary("objc", .{});' '
        exe_module.addSystemFrameworkPath(.{ .cwd_relative = "'"$SDKROOT"'/System/Library/Frameworks" });
        exe_module.addLibraryPath(.{ .cwd_relative = "'"$SDKROOT"'/usr/lib" });
        exe_module.linkSystemLibrary("objc", .{});'
  '';

  postInstall = ''
    rm -f $out/bin/tatami-sim
  '';

  meta = {
    description = "Tiling window manager for macOS";
    homepage = "https://github.com/gakonst/tatami";
    license = with lib.licenses; [mit asl20];
    mainProgram = "tatami";
    platforms = ["aarch64-darwin"];
  };
}
