require("config.options")
require("config.keymaps")
require("config.lsp")
require("config.colorscheme")

require("config.plugins.blink")
require("config.plugins.formatter")
require("config.plugins.mini")
require("config.plugins.neck")
require("config.plugins.oil")
require("config.plugins.pairs")
require("config.plugins.snacks")
require("config.plugins.treesitter")

if vim.g.IS_WORK then
	require("config.plugins.roslyn")
end
