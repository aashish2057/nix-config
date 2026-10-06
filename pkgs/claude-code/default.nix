{
  lib,
  stdenvNoCC,
  fetchurl,
  installShellFiles,
  makeBinaryWrapper,
  autoPatchelfHook,
  alsa-lib,
  procps,
  ripgrep,
  bubblewrap,
  socat,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}: let
  version = "2.1.292";
  sourceMap = {
    aarch64-darwin = {
      file = "claude-darwin-arm64.tar.gz";
      hash = "sha256-en3MUIaWogk9/GkDmLhiF/ErB4Cbe9U0wv3k9BeIFVY=";
    };
    x86_64-linux = {
      file = "claude-linux-x64.tar.gz";
      hash = "sha256-cEXNeQsse4zGFp0GGuxydNN6ag2O0xim/4hoJiQzsfk=";
    };
  };
  sourceInfo = sourceMap.${stdenvNoCC.hostPlatform.system} or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
in
  stdenvNoCC.mkDerivation {
    pname = "claude-code";
    inherit version;

    src = fetchurl {
      url = "https://github.com/anthropics/claude-code/releases/download/v${version}/${sourceInfo.file}";
      inherit (sourceInfo) hash;
    };
    sourceRoot = ".";

    dontBuild = true;
    dontStrip = true;

    nativeBuildInputs =
      [
        installShellFiles
        makeBinaryWrapper
      ]
      ++ lib.optionals stdenvNoCC.hostPlatform.isElf [autoPatchelfHook];

    buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [alsa-lib];

    installPhase = ''
      runHook preInstall

      install -Dm755 claude $out/bin/claude
      wrapProgram $out/bin/claude \
        --set DISABLE_AUTOUPDATER 1 \
        --set-default FORCE_AUTOUPDATE_PLUGINS 1 \
        --set DISABLE_INSTALLATION_CHECKS 1 \
        --set USE_BUILTIN_RIPGREP 0 \
        ${lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [alsa-lib]} \
      ''}--prefix PATH : ${
        lib.makeBinPath (
          [
            procps
            ripgrep
          ]
          ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [
            bubblewrap
            socat
          ]
        )
      }

      runHook postInstall
    '';

    doInstallCheck = true;
    nativeInstallCheckInputs = [
      writableTmpDirAsHomeHook
      versionCheckHook
    ];
    versionCheckKeepEnvironment = ["HOME"];
    versionCheckProgramArg = "--version";

    meta = {
      description = "Agentic coding tool that lives in your terminal";
      homepage = "https://github.com/anthropics/claude-code";
      changelog = "https://github.com/anthropics/claude-code/blob/v${version}/CHANGELOG.md";
      license = lib.licenses.unfree;
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      platforms = builtins.attrNames sourceMap;
      mainProgram = "claude";
    };
  }
