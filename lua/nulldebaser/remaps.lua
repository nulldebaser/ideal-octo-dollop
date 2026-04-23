local builtin = require('telescope.builtin')

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.api.nvim_set_keymap("n", "<leader>tf", "<Plug>PlenaryTestFile", { noremap = false, silent = false })

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "=ap", "ma=ap'a")
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")

vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>t", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("source " .. vim.fn.stdpath("config") .. "/init.lua")
end, { desc = "Reload Neovim config" })

vim.keymap.set("n", "<leader>p", function()
    require("telescope.builtin").find_files({
        prompt_title = "Find in Projects",
        cwd = "/home/akadebaser/dev",
    })
end, { desc = "Browse Projects folder" })

-- ✅ FIXED: respects virtualenv
vim.keymap.set("n", "<leader>r", function()
    local python = "python3"
    local venv = os.getenv("VIRTUAL_ENV")

    if venv and venv ~= "" then
        local sep = package.config:sub(1,1)
        local python_bin = sep == "\\" and "\\Scripts\\python.exe" or "/bin/python"
        python = venv .. python_bin
    end

    vim.cmd("w")
    vim.cmd("!" .. python .. " " .. vim.fn.expand("%:p"))
end, { desc = "Run Python file" })

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

vim.keymap.set('n', '<Tab>', ':tabn<CR>')

-- Root detection
local function get_root()
    local root = vim.fs.root(0, { "CMakeLists.txt", ".git" })
    return root or vim.fn.getcwd()
end

-- Build
vim.keymap.set("n", "<leader>dc", function()
    local root = get_root()

    if vim.fn.isdirectory(root .. "/build") == 0 then
        vim.cmd("!cmake -S " .. root .. " -B " .. root .. "/build")
    end

    vim.cmd("!cmake --build " .. root .. "/build")
end, { desc = "CMake build" })

-- Build + debug
vim.keymap.set("n", "<F5>", function()
    local root = get_root()

    if vim.fn.isdirectory(root .. "/build") == 0 then
        vim.cmd("!cmake -S " .. root .. " -B " .. root .. "/build")
    end

    vim.cmd("!cmake --build " .. root .. "/build")

    require("dap").continue()
end, { desc = "Build + Debug" })

-- ✅ ADDED: proper debug start
vim.keymap.set("n", "<leader>dd", function()
    require("dap").continue()
end, { desc = "Start Debugging" })

-- Debug controls
vim.keymap.set("n", "<F10>", function() require("dap").step_over() end)
vim.keymap.set("n", "<F11>", function() require("dap").step_into() end)
vim.keymap.set("n", "<F12>", function() require("dap").step_out() end)

-- Breakpoints
vim.keymap.set("n", "<leader>b", function()
    require("dap").toggle_breakpoint()
end, { desc = "Toggle breakpoint" })

vim.keymap.set("n", "<leader>B", function()
    require("dap").set_breakpoint(vim.fn.input("Condition: "))
end, { desc = "Conditional breakpoint" })

vim.keymap.set("n", "<leader>lp", function()
    require("dap").set_breakpoint(nil, nil, vim.fn.input("Log: "))
end, { desc = "Log point" })

-- Execution control
vim.keymap.set("n", "<leader>dr", function()
    require("dap").restart()
end, { desc = "Restart debug" })

vim.keymap.set("n", "<leader>dq", function()
    require("dap").terminate()
end, { desc = "Quit debug" })
