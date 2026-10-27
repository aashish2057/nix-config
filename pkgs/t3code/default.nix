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
  version = "0.1.3";
  repo = "https://github.com/pingdotgg/t3code";

  sourceMap = {
    x86_64-linux = {
      file = "T3-Code-${version}-x86_64.AppImage";
      hash = "sha256-gBzOSC0ghdob+6HQ4wHAotdafI0O/SSGXCJhlINC3yE=";
      server = {
        file = "t3-${version}-linux-x64.tar.gz";
        hash = "sha256-Y80PBUfu9iu07OJ/p3m7+eK6hTHMaFQlaLqeeIONxoQ=";
      };
    };
    aarch64-darwin = {
      file = "T3-Code-${version}-arm64.dmg";
      hash = "sha256-/ILhs9lVE7MhVElbxbI4D4bnRVI320nWx6nKBFRQ5Ng=";
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
          --set-default T3CODE_CLOUDFLARED_PATH ${lib.getExe cloudflared} \
          --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [stdenv.cc.cc.lib]}

        runHook postInstall
      '';

      # patchelf >= 0.19 corrupts the single executable application when it sets
      # an RPATH, so only the interpreter of t3 is patched. The wrapper supplies libstdc++.
      dontAutoPatchelf = true;
      postFixup = ''
        autoPatchelf $out/libexec/t3code/node_modules $out/libexec/t3code/resource-monitor
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/libexec/t3code/t3
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
