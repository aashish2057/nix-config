{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  makeDesktopItem,
  undmg,
}: let
  pname = "t3code";
  version = "0.0.39";
  repo = "https://github.com/pingdotgg/t3code";

  sourceMap = {
    x86_64-linux = {
      file = "T3-Code-${version}-x86_64.AppImage";
      hash = "sha256-T3jJk5wDhvm+Wi2Om6+WRK9Jc0QBWBejb+qL6EmBvag=";
    };
    aarch64-darwin = {
      file = "T3-Code-${version}-arm64.dmg";
      hash = "sha256-rqmJ4dej+n71Vw4Czt+ew7G4HLL+l7V4YQgSmJOM8gs=";
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

      meta = commonMeta // {mainProgram = pname;};
    }
