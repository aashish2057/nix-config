require("no-neck-pain").setup({
	width = 138,
	autocmds = {
		disableOnLastBuffer = true,
	},
})

vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("OpenNoNeckPainOnFirstFile", { clear = true }),
	callback = function(args)
		local buftype = vim.bo[args.buf].buftype
		local name = vim.api.nvim_buf_get_name(args.buf)
		if buftype == "" and name ~= "" then
			vim.cmd("NoNeckPain")
			vim.api.nvim_del_augroup_by_name("OpenNoNeckPainOnFirstFile")
		end
	end,
})
