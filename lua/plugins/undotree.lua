return {
	"mbbill/undotree",
	cmd = { "UndotreeToggle", "UndotreeShow", "UndotreeHide" }, -- lazy load on command
	keys = {
		{ "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle UndoTree" },
	},
	config = function()
		-- Optional: set options here
		vim.g.undotree_WindowLayout = 2
		vim.g.undotree_SplitWidth = 40
		vim.g.undotree_SetFocusWhenToggle = 1
	end,
}
