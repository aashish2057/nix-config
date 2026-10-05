{
  lib,
  stdenv,
  fetchurl,
  makeBinaryWrapper,
  autoPatchelfHook,
  ripgrep,
  sysctl,
  wayland,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}: let
  version = "2.0.23";
  # OpenCode 2 ships prebuilt binaries only on npm (@opencode/cli-<platform>).
  sourceMap = {
    aarch64-darwin = {
      platform = "darwin-arm64";
      hash = "sha256-23w/q7PSfnf1JjVa/qlObhhtN2Dt54UaIa8INvl4Mj8=";
    };
    x86_64-linux = {
      platform = "linux-x64";
      hash = "sha256-8ac5BsAxoAa5jy7wBgZQfxIsVbbrEqV9OPeUmPxlwkg=";
    };
  };
  sourceInfo = sourceMap.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
  stdenv.mkDerivation {
    pname = "opencode";
    inherit version;

    src = fetchurl {
      url = "https://registry.npmjs.org/@opencode/cli-${sourceInfo.platform}/-/cli-${sourceInfo.platform}-${version}.tgz";
      inherit (sourceInfo) hash;
    };
    sourceRoot = "package";

    dontBuild = true;
    dontStrip = true;

    nativeBuildInputs =
      [makeBinaryWrapper]
      ++ lib.optionals stdenv.hostPlatform.isLinux [autoPatchelfHook];

    buildInputs = lib.optionals stdenv.hostPlatform.isLinux [stdenv.cc.cc.lib];

    # Native addons embedded in the Bun executable load libstdc++ and libwayland-client at runtime.
    installPhase = ''
      runHook preInstall

      install -Dm755 bin/opencode $out/bin/opencode
      wrapProgram $out/bin/opencode \
        --set OPENCODE_DISABLE_AUTOUPDATE true \
        --prefix PATH : ${lib.makeBinPath ([ripgrep] ++ lib.optionals stdenv.hostPlatform.isDarwin [sysctl])} \
        ${lib.optionalString stdenv.hostPlatform.isLinux "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [stdenv.cc.cc.lib wayland]}"}

      runHook postInstall
    '';

    doInstallCheck = true;
    nativeInstallCheckInputs = [
      versionCheckHook
      writableTmpDirAsHomeHook
    ];
    versionCheckKeepEnvironment = ["HOME"];
    versionCheckProgramArg = "--version";

    meta = {
      description = "AI coding agent built for the terminal";
      homepage = "https://github.com/anomalyco/opencode";
      changelog = "https://github.com/anomalyco/opencode/commits/v2";
      license = lib.licenses.mit;
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      platforms = builtins.attrNames sourceMap;
      mainProgram = "opencode";
    };
  }
