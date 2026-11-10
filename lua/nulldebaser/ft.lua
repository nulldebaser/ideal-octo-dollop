local group = vim.api.nvim_create_augroup("nulldebaser_ft", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "c", "cpp" },
	callback = function()
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.softtabstop = 4
		vim.opt_local.expandtab = true
		vim.opt_local.cindent = true
		vim.opt_local.cinoptions = ":0"
	end,
})
