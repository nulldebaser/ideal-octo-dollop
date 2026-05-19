return {
	"tpope/vim-fugitive",
	cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "Gvdiffsplit", "Gmerge" },
	event = "VeryLazy",
	config = function()
		vim.keymap.set("n", "<leader>gs", function()
			vim.cmd("Git")
		end, { desc = "Git status (Fugitive)" })
	end
}
