{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,
  unzip,
  autoPatchelfHook,
  libusb1,
}: let
  pname = "display-switch";
  version = "1.4.1";
  repo = "https://github.com/haimgel/display-switch";

  sourceMap = {
    x86_64-linux = {
      file = "display_switch-v${version}-linux-amd64.zip";
      hash = "sha256-DeNNPoeZGIg0qaJ1ilxH6Z1/+mpSlhwMnxAzTFTu5ac=";
    };
    aarch64-darwin = {
      file = "display_switch-v${version}-macos-universal.zip";
      hash = "sha256-0epBgUiurfLsNQeH/QTIpWp2VhBFTm20q7oUOVbtrbU=";
    };
  };

  sourceInfo = sourceMap.${stdenvNoCC.hostPlatform.system} or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
in
  stdenvNoCC.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "${repo}/releases/download/${version}/${sourceInfo.file}";
      inherit (sourceInfo) hash;
    };

    nativeBuildInputs =
      [unzip]
      ++ lib.optional stdenvNoCC.hostPlatform.isLinux autoPatchelfHook;
    buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
      libusb1
      stdenv.cc.cc.lib
    ];

    sourceRoot = ".";
    dontBuild = true;
    dontStrip = stdenvNoCC.hostPlatform.isDarwin;

    installPhase = ''
      runHook preInstall

      install -Dm755 display_switch "$out/bin/display_switch"

      runHook postInstall
    '';

    meta = {
      description = "Switch display inputs when a USB device connects or disconnects";
      homepage = repo;
      changelog = "${repo}/releases/tag/${version}";
      license = lib.licenses.mit;
      mainProgram = "display_switch";
      platforms = builtins.attrNames sourceMap;
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
    };
  }
