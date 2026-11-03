-- illumos-gate project settings. Neovim loads this through 'exrc'.
-- The gate's .nvim.lua is a symlink to this file (made by `illumos-vm ccdb`).
-- After you change it, Neovim asks you to trust it again.
-- clangd comes from the dev flake, so it isn't installed system-wide.
-- compile_commands.json comes from `illumos-vm ccdb` after a build.
local flake = vim.env.HOME .. "/Dev/nix-config/devshells/illumos"

vim.lsp.config("clangd", {
	cmd = {
		"nix", "develop", flake, "--command",
		"clangd", "--background-index", "--header-insertion=never", "-j=4",
	},
})
vim.lsp.enable("clangd")

-- illumos style (cstyle): hard tabs, 8 columns wide, 80-column lines.
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp", "asm", "make" },
	callback = function()
		vim.bo.expandtab = false
		vim.bo.tabstop = 8
		vim.bo.shiftwidth = 8
		vim.bo.softtabstop = 0
		vim.wo.colorcolumn = "80"
	end,
})

-- illumos uses .s files and Makefile.* names.
vim.filetype.add({
	extension = { s = "asm" },
	pattern = { ["Makefile%..*"] = "make" },
})

-- Headers in proto/ are symlinks to the source made by `illumos-vm ccdb`.
-- When a jump opens one, open the real source file in its place.
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*/proto/*",
	callback = function(args)
		local real = vim.uv.fs_realpath(args.match)
		if not real or real == args.match then
			return
		end
		vim.schedule(function()
			if vim.api.nvim_get_current_buf() ~= args.buf then
				return
			end
			-- The link and the source are the same file, so rename the buffer.
			-- :edit! reloads it, so clangd sees the new name.
			local pos = vim.api.nvim_win_get_cursor(0)
			vim.api.nvim_buf_set_name(args.buf, real)
			vim.cmd("silent edit!")
			pcall(vim.api.nvim_win_set_cursor, 0, pos)
			-- Renaming leaves an unlisted buffer with the old name.
			local old = vim.fn.bufnr(args.match)
			if old > 0 and old ~= args.buf then
				pcall(vim.api.nvim_buf_delete, old, { force = true })
			end
		end)
	end,
})
