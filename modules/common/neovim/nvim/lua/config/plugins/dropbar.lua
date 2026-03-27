local sources = require("dropbar.sources")
local symbol_source = require("dropbar.utils").source.fallback({
	sources.lsp,
	sources.treesitter,
})

local path_source = {
	get_symbols = function(buf, win, cursor)
		local symbols = sources.path.get_symbols(buf, win, cursor)
		-- For deep paths, keep the first segment, replace the middle with "...",
		-- and keep the parent directory plus the current file.
		if #symbols > 4 then
			symbols = {
				symbols[1],
				symbols[1]:merge({ icon = "", name = "..." }),
				symbols[#symbols - 1],
				symbols[#symbols],
			}
		end
		return symbols
	end,
}

require("dropbar").setup({
	bar = {
		-- Only attach when the buffer/window is valid, the window is a normal
		-- editing window, it does not already have a winbar (like No Neck Pain
		-- side buffers), and the buffer is not a help page.
		enable = function(buf, win)
			return vim.api.nvim_buf_is_valid(buf)
				and vim.api.nvim_win_is_valid(win)
				and vim.fn.win_gettype(win) == ""
				and vim.wo[win].winbar == ""
				and vim.bo[buf].ft ~= "help"
		end,
		sources = function(buf)
			if vim.bo[buf].buftype == "terminal" then
				return { sources.terminal }
			end

			return {
				path_source,
				vim.bo[buf].ft == "markdown" and sources.markdown or symbol_source,
			}
		end,
	},
	symbol = {
		on_click = false,
	},
})
