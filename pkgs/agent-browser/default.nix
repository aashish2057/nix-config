{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}: let
  version = "0.33.0";
  repo = "https://github.com/vercel-labs/agent-browser";
  releaseMap = {
    aarch64-darwin = {
      asset = "agent-browser-darwin-arm64";
      hash = "sha256-0StwxC6YFsj0RkLfbGDEHMwLbzTXPzz4kaXaFARbgOk=";
    };
    x86_64-linux = {
      asset = "agent-browser-linux-x64";
      hash = "sha256-t32F640NMFvkFw+Ud8WfAwSzYJ3Dm/DouMdAoavR4Io=";
    };
  };
  release =
    releaseMap.${stdenv.hostPlatform.system}
    or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  binary = fetchurl {
    url = "${repo}/releases/download/v${version}/${release.asset}";
    inherit (release) hash;
  };
  releaseSource = fetchurl {
    url = "${repo}/archive/refs/tags/v${version}.tar.gz";
    hash = "sha256-vlJlj25XgcYrmR0lyWULJz2VvQ5gWT7v9ui2zZdCWO8=";
  };
in
  stdenv.mkDerivation {
    pname = "agent-browser";
    inherit version;

    dontUnpack = true;

    nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
      autoPatchelfHook
    ];

    installPhase = ''
      runHook preInstall

      install -Dm755 ${binary} "$out/bin/agent-browser"

      tar -xzf ${releaseSource}
      cp -r agent-browser-${version}/skills "$out/skills"
      cp -r agent-browser-${version}/skill-data "$out/skill-data"

      # OpenCode filters hidden skills, but this bootstrap skill must be discoverable.
      sed -i '/^hidden: true$/d' "$out/skills/agent-browser/SKILL.md"

      runHook postInstall
    '';

    meta = {
      description = "Browser automation CLI for AI agents";
      homepage = repo;
      license = lib.licenses.asl20;
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      platforms = builtins.attrNames releaseMap;
      mainProgram = "agent-browser";
    };
  }
