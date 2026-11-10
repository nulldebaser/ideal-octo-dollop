local project = require("nulldebaser.project")

local function telescope()
	return require("telescope.builtin")
end

--------------------------------------------------
-- File / project navigation
--------------------------------------------------
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open file explorer" })

vim.keymap.set("n", "<leader>ff", function()
	telescope().find_files({
		hidden = true,
		no_ignore = true,
		cwd = vim.fn.expand("~"),
	})
end, { desc = "Find files (home)" })

vim.keymap.set("n", "<C-p>", function()
	telescope().git_files()
end, { desc = "Git files" })

vim.keymap.set("n", "<leader>ps", function()
	telescope().grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = "Grep string" })

vim.keymap.set("n", "<leader>p", function()
	telescope().find_files({
		prompt_title = "Projects",
		cwd = project.dev_dir(),
	})
end, { desc = "Find files (projects)" })

--------------------------------------------------
-- Editing
--------------------------------------------------
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "=ap", "ma=ap'a")

--------------------------------------------------
-- Clipboard
--------------------------------------------------
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yank" })

--------------------------------------------------
-- Misc
--------------------------------------------------
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })

vim.keymap.set("n", "<leader><leader>", function()
	vim.cmd("source " .. vim.fn.stdpath("config") .. "/init.lua")
end, { desc = "Reload config" })

vim.keymap.set(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace word under cursor" }
)

--------------------------------------------------
-- Tabs
--------------------------------------------------
vim.keymap.set("n", "<leader>tn", ":tabn<CR>", { desc = "Next tab" })
vim.keymap.set("n", "<leader>tp", ":tabp<CR>", { desc = "Previous tab" })

--------------------------------------------------
-- Python
--------------------------------------------------
vim.keymap.set("n", "<leader>r", function()
	vim.cmd("w")
	vim.cmd("!" .. project.python() .. " " .. vim.fn.shellescape(vim.fn.expand("%:p")))
end, { desc = "Run Python file" })

--------------------------------------------------
-- Quickfix / loclist
--------------------------------------------------
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Next quickfix" })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Previous quickfix" })
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next loclist" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Previous loclist" })

--------------------------------------------------
-- Diagnostics (K for hover is set on LspAttach in lsp.lua)
--------------------------------------------------
vim.keymap.set("n", "<leader>e", function()
	vim.diagnostic.open_float(nil, { scope = "line" })
end, { desc = "Line diagnostics" })

vim.keymap.set("n", "<leader>,", function()
	vim.diagnostic.setloclist({ open = true })
end, { desc = "Buffer diagnostics to loclist" })

vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = false })
end, { desc = "Next diagnostic" })

vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = false })
end, { desc = "Previous diagnostic" })

--------------------------------------------------
-- CMake / LSP
--------------------------------------------------
vim.keymap.set("n", "<leader>cb", function()
	project.cmake_build()
end, { desc = "CMake build" })

vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>", { desc = "Restart LSP" })
