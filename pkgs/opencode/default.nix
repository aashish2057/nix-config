{
  lib,
  stdenv,
  fetchurl,
  makeBinaryWrapper,
  autoPatchelfHook,
  unzip,
  ripgrep,
  sysctl,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}: let
  version = "1.18.33";
  sourceMap = {
    aarch64-darwin = {
      file = "opencode-darwin-arm64.zip";
      hash = "sha256-JLEoc+YFs9szh8s1X0O6dFHNYGXBgNjBiGYzN9LutVM=";
    };
    x86_64-darwin = {
      file = "opencode-darwin-x64.zip";
      hash = "sha256-kMfn2f+g2GkcoPFbQqe4m3Lhek0mB0ue8GVZ/4eyIew=";
    };
    aarch64-linux = {
      file = "opencode-linux-arm64.tar.gz";
      hash = "sha256-xjSGYkYhkkv0O+XAGr0lKIVmGnNIFCJPbXAYijOuqFg=";
    };
    x86_64-linux = {
      file = "opencode-linux-x64.tar.gz";
      hash = "sha256-5UYSMhOuR5CaQmhpKqS5SVDQEa/pysmTh1OiGU8cFtU=";
    };
  };
  sourceInfo = sourceMap.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
  stdenv.mkDerivation {
    pname = "opencode";
    inherit version;

    src = fetchurl {
      url = "https://github.com/anomalyco/opencode/releases/download/v${version}/${sourceInfo.file}";
      inherit (sourceInfo) hash;
    };
    sourceRoot = ".";

    dontBuild = true;
    dontStrip = true;

    nativeBuildInputs =
      [makeBinaryWrapper]
      ++ lib.optionals stdenv.hostPlatform.isLinux [autoPatchelfHook]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [unzip];

    buildInputs = lib.optionals stdenv.hostPlatform.isLinux [stdenv.cc.cc.lib];

    installPhase = ''
      runHook preInstall

      install -Dm755 opencode $out/bin/opencode
      wrapProgram $out/bin/opencode \
        --set OPENCODE_DISABLE_AUTOUPDATE true \
        --prefix PATH : ${lib.makeBinPath ([ripgrep] ++ lib.optionals stdenv.hostPlatform.isDarwin [sysctl])}

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
      changelog = "https://github.com/anomalyco/opencode/releases/tag/v${version}";
      license = lib.licenses.mit;
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      platforms = builtins.attrNames sourceMap;
      mainProgram = "opencode";
    };
  }
