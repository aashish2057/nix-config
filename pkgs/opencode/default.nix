{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  bun,
  nodejs,
  sysctl,
  makeBinaryWrapper,
  models-dev,
  ripgrep,
  installShellFiles,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}: let
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "anomalyco";
    repo = "opencode";
    tag = "v${version}";
    hash = "sha256-wgr8i3nnU3vKbMDPdFri5n+4YJR5qSR3sQWYLcUwBnQ=";
  };

  nodeModulesHashes = {
    x86_64-linux = "sha256-euVUyj0CzjCA1nYbN2vKctEPzLkUlNGTK2dMNbackqM=";
    aarch64-linux = "sha256-qQkjqaxpjAae+rohoWI601QnrgKYghJ+ttqeiQBTwCM=";
    aarch64-darwin = "sha256-HYWs31TJlDZsDBNmbPARo16r7zNKy9x840uHGcUMYsk=";
    x86_64-darwin = "sha256-89FOrX813FENk3u8RAHCfyD7voaZWW++Z4Gpa3SkOJs=";
  };

  platform = stdenvNoCC.hostPlatform;
  bunCpu =
    if platform.isAarch64
    then "arm64"
    else "x64";
  bunOs =
    if platform.isLinux
    then "linux"
    else "darwin";

  nodeModules = stdenvNoCC.mkDerivation {
    pname = "opencode-node_modules";
    inherit version src;

    impureEnvVars =
      lib.fetchers.proxyImpureEnvVars
      ++ [
        "GIT_PROXY_COMMAND"
        "SOCKS_SERVER"
      ];

    nativeBuildInputs = [bun];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install \
        --cpu="${bunCpu}" \
        --os="${bunOs}" \
        --filter '!./' \
        --filter './packages/cli' \
        --filter './packages/desktop' \
        --filter './packages/app' \
        --frozen-lockfile \
        --ignore-scripts \
        --no-progress
      bun --bun ${src}/nix/scripts/canonicalize-node-modules.ts
      bun --bun ${src}/nix/scripts/normalize-bun-binaries.ts

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      find . -type d -name node_modules -exec cp -R --parents {} $out \;

      runHook postInstall
    '';

    dontFixup = true;
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = nodeModulesHashes.${platform.system} or (throw "Unsupported system: ${platform.system}");
  };
in
  stdenvNoCC.mkDerivation {
    pname = "opencode";
    inherit version src;

    nativeBuildInputs = [
      bun
      nodejs
      installShellFiles
      makeBinaryWrapper
      models-dev
      writableTmpDirAsHomeHook
    ];

    postPatch = ''
      substituteInPlace packages/script/src/index.ts \
        --replace-fail 'throw new Error(`This script requires bun@''${expectedBunVersionRange}' \
                       'console.warn(`Warning: This script requires bun@''${expectedBunVersionRange}'
    '';

    configurePhase = ''
      runHook preConfigure

      cp -R ${nodeModules}/. .
      patchShebangs node_modules
      patchShebangs packages/*/node_modules

      runHook postConfigure
    '';

    env = {
      MODELS_DEV_API_JSON = "${models-dev}/dist/_api.json";
      OPENCODE_DISABLE_MODELS_FETCH = true;
      OPENCODE_VERSION = version;
      OPENCODE_CHANNEL = "prod";
      NODE_OPTIONS = "--max-old-space-size=4096";
    };

    buildPhase = ''
      runHook preBuild

      cd packages/cli
      bun --bun ./script/build.ts --single --skip-install

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      install -Dm755 dist/cli-*/bin/opencode $out/bin/opencode

      wrapProgram $out/bin/opencode \
        --prefix PATH : ${
        lib.makeBinPath (
          [ripgrep]
          ++ lib.optional platform.isDarwin sysctl
        )
      }

      runHook postInstall
    '';

    postInstall = lib.optionalString (stdenvNoCC.buildPlatform.canExecute platform) ''
      installShellCompletion --cmd opencode \
        --bash <($out/bin/opencode completion) \
        --zsh <(SHELL=/bin/zsh $out/bin/opencode completion)
    '';

    nativeInstallCheckInputs = [
      versionCheckHook
      writableTmpDirAsHomeHook
    ];
    doInstallCheck = true;
    versionCheckKeepEnvironment = [
      "HOME"
      "OPENCODE_DISABLE_MODELS_FETCH"
    ];
    versionCheckProgramArg = "--version";

    meta = {
      description = "The open source coding agent";
      homepage = "https://opencode.ai";
      license = lib.licenses.mit;
      mainProgram = "opencode";
      platforms = builtins.attrNames nodeModulesHashes;
    };
  }
