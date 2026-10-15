{
  lib,
  stdenvNoCC,
  fetchurl,
  versionCheckHook,
}: let
  version = "0.162.1";
  sourceMap = {
    aarch64-darwin = {
      file = "codex-package-aarch64-apple-darwin.tar.gz";
      hash = "sha256-iON8zd9aD06p3BvhPGaiqU+cLRoE86zpBT1xs5OeiF0=";
    };
    x86_64-linux = {
      file = "codex-package-x86_64-unknown-linux-musl.tar.gz";
      hash = "sha256-pnb1ciquDYbL43ZDMvCOqx/didwKMAs61P+/SGEfo+M=";
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
    dontFixup = true;

    # Codex needs the complete package layout (codex-package.json, codex-path,
    # codex-resources) next to its entrypoint to install the app-server daemon.
    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/codex $out/bin
      cp -r bin codex-package.json codex-path codex-resources $out/lib/codex/
      ln -s $out/lib/codex/bin/codex $out/bin/codex

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
