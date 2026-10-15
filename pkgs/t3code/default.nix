{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  makeDesktopItem,
  undmg,
  autoPatchelfHook,
  makeBinaryWrapper,
  cloudflared,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}: let
  pname = "t3code";
  version = "0.0.46-nightly.20261015.3145";
  repo = "https://github.com/pingdotgg/t3code";

  sourceMap = {
    x86_64-linux = {
      file = "T3-Code-${version}-x86_64.AppImage";
      hash = "sha256-S2hDSJ3yXzEwWokhFZsTBklvwQ8+0XKFvNvtj8a6kiM=";
      server = {
        file = "t3-${version}-linux-x64.tar.gz";
        hash = "sha256-Qdu5P99rkLN+nDKbL6JU0AYb4HWjC3ZQEigdR1xua2U=";
      };
    };
    aarch64-darwin = {
      file = "T3-Code-${version}-arm64.dmg";
      hash = "sha256-2S7NSuUN/aNzC6S4wkNipVLt14fv5YnVEC7rJTqBK7o=";
    };
  };

  sourceInfo = sourceMap.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  source = fetchurl {
    url = "${repo}/releases/download/v${version}/${sourceInfo.file}";
    inherit (sourceInfo) hash;
  };

  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "T3 Code";
    comment = "Desktop control surface for coding agents";
    exec = "t3code %U";
    icon = pname;
    startupWMClass = pname;
    categories = ["Development"];
    mimeTypes = ["x-scheme-handler/t3code"];
  };
  commonMeta = {
    description = "Desktop control surface for coding agents";
    homepage = "https://t3.codes";
    downloadPage = "https://t3.codes/download";
    changelog = "${repo}/releases/tag/v${version}";
    license = lib.licenses.mit;
    platforms = builtins.attrNames sourceMap;
  };

  # Headless `t3` from the same release, so client and server speak the same protocol.
  server = let
    serverInfo = sourceInfo.server or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  in
    stdenv.mkDerivation {
      pname = "t3";
      inherit version;

      src = fetchurl {
        url = "${repo}/releases/download/v${version}/${serverInfo.file}";
        inherit (serverInfo) hash;
      };

      dontBuild = true;
      # The executable is a Node single executable application; stripping removes its embedded bundle.
      dontStrip = true;

      nativeBuildInputs = [
        autoPatchelfHook
        makeBinaryWrapper
      ];

      buildInputs = [stdenv.cc.cc.lib];

      installPhase = ''
        runHook preInstall

        mkdir -p $out/libexec/t3code $out/bin
        cp -R . $out/libexec/t3code/

        # t3 resolves node_modules and client next to its executable. Without a
        # cloudflared here it downloads its own for T3 Connect.
        makeWrapper $out/libexec/t3code/t3 $out/bin/t3 \
          --set-default T3CODE_CLOUDFLARED_PATH ${lib.getExe cloudflared}

        runHook postInstall
      '';

      doInstallCheck = true;
      nativeInstallCheckInputs = [
        writableTmpDirAsHomeHook
        versionCheckHook
      ];
      versionCheckKeepEnvironment = ["HOME"];
      versionCheckProgramArg = "--version";

      meta =
        commonMeta
        // {
          description = "Headless server for T3 Code";
          sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
          platforms = builtins.attrNames (lib.filterAttrs (_: info: info ? server) sourceMap);
          mainProgram = "t3";
        };
    };
in
  if stdenv.hostPlatform.isDarwin
  then
    stdenv.mkDerivation {
      inherit pname version;
      src = source;
      nativeBuildInputs = [undmg];
      sourceRoot = ".";

      installPhase = ''
        runHook preInstall

        mkdir -p "$out/Applications"
        cp -R ./*.app "$out/Applications/"

        runHook postInstall
      '';

      passthru = {inherit server;};

      meta = commonMeta;
    }
  else
    appimageTools.wrapAppImage rec {
      inherit pname version;

      src = appimageTools.extract {
        inherit pname version;
        src = source;
      };

      extraInstallCommands = ''
        install -m 444 -D ${src}/.DirIcon "$out/share/icons/hicolor/512x512/apps/${pname}.png"
        install -m 444 -D ${desktopItem}/share/applications/${pname}.desktop "$out/share/applications/${pname}.desktop"
      '';

      passthru = {inherit server;};

      meta = commonMeta // {mainProgram = pname;};
    }
