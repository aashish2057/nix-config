{
  lib,
  stdenvNoCC,
  fetchurl,
  makeBinaryWrapper,
  ripgrep,
  bubblewrap,
  versionCheckHook,
}: let
  version = "0.160.1";
  sourceMap = {
    aarch64-darwin = {
      file = "codex-aarch64-apple-darwin.tar.gz";
      binary = "codex-aarch64-apple-darwin";
      hash = "sha256-ZwrysEnZyVr7dNfaOF8wxQM9E6BxdQAd2JWMUZRJhNA=";
    };
    x86_64-linux = {
      file = "codex-x86_64-unknown-linux-musl.tar.gz";
      binary = "codex-x86_64-unknown-linux-musl";
      hash = "sha256-kiZYG+WS0Y9+f3QKNS/bY6ph5F459+ubCdOIjIS7oz8=";
    };
  };
  sourceInfo = sourceMap.${stdenvNoCC.hostPlatform.system} or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
in
  stdenvNoCC.mkDerivation {
    pname = "codex";
    inherit version;

    src = fetchurl {
      url = "https://github.com/openai/codex/releases/download/rust-v${version}/${sourceInfo.file}";
      inherit (sourceInfo) hash;
    };
    sourceRoot = ".";

    dontBuild = true;
    nativeBuildInputs = [makeBinaryWrapper];

    installPhase = ''
      runHook preInstall

      install -Dm755 ${sourceInfo.binary} $out/bin/codex
      wrapProgram $out/bin/codex \
        --prefix PATH : ${lib.makeBinPath ([ripgrep] ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [bubblewrap])}

      runHook postInstall
    '';

    doInstallCheck = true;
    nativeInstallCheckInputs = [versionCheckHook];
    versionCheckProgramArg = "--version";

    meta = {
      description = "Lightweight coding agent that runs in your terminal";
      homepage = "https://github.com/openai/codex";
      changelog = "https://raw.githubusercontent.com/openai/codex/refs/tags/rust-v${version}/CHANGELOG.md";
      license = lib.licenses.asl20;
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      platforms = builtins.attrNames sourceMap;
      mainProgram = "codex";
    };
  }
