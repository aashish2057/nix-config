{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  bun,
}:
# opencode plugin `@rama_nigg/open-cursor`, packaged so it can be loaded as a
# local `file://` plugin instead of being fetched from npm at runtime.
#
# Loading it via `file://` avoids opencode's runtime `Npm.add` step (which writes
# to ~/.npm/_cacache and fails with EACCES when that cache contains root-owned
# files). opencode 1.15.13 resolves a `file://<dir>` plugin to its package.json
# `main` (dist/plugin-entry.js) and imports it directly; the bundle keeps
# `@opencode-ai/plugin` + `zod` external and string-requires `ajv`/`ajv-formats`,
# so the plugin must ship a production node_modules. buildNpmPackage provides
# exactly that (pruned dep closure) alongside the bun-built dist/.
buildNpmPackage rec {
  pname = "open-cursor";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "Nomadcxx";
    repo = "opencode-cursor";
    rev = "v${version}";
    hash = "sha256-xu2aAA9Du+RlWpR9GonK5Ffv5Cxz/j0ktgfDiB8cBsg=";
  };

  npmDepsHash = "sha256-sSZbgP1X39bT+YgQyz3uTfLTvvghkQUJuO/6CrOIO8A=";

  # The "build" script is `bun build ... --target node`.
  nativeBuildInputs = [bun];

  meta = {
    description = "Cursor provider plugin for opencode (@rama_nigg/open-cursor)";
    homepage = "https://github.com/Nomadcxx/opencode-cursor";
    license = lib.licenses.isc;
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
  };
}
