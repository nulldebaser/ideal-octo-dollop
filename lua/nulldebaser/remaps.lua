local builtin = require('telescope.builtin')

vim.g.mapleader = " "

--------------------------------------------------
-- File explorer
--------------------------------------------------
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

--------------------------------------------------
-- Better movement / editing
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
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")

--------------------------------------------------
-- Misc
--------------------------------------------------
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("source " .. vim.fn.stdpath("config") .. "/init.lua")
end, { desc = "Reload Neovim config" })

--------------------------------------------------
-- Telescope
--------------------------------------------------


vim.keymap.set('n', '<leader>ff', function()
  require('telescope.builtin').find_files({
    hidden = true,
    no_ignore = true,
    cwd = vim.fn.expand('~'),
  })
end, { desc = 'Find files in home directory' })

vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

vim.keymap.set("n", "<leader>p", function()
    builtin.find_files({
        prompt_title = "Find in Projects",
        cwd = "/home/aleph/dev",
    })
end, { desc = "Browse Projects folder" })

--------------------------------------------------
-- Python runner (venv aware)
--------------------------------------------------
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

--------------------------------------------------
-- Quickfix navigation
--------------------------------------------------
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

--------------------------------------------------
-- Replace word under cursor
--------------------------------------------------
vim.keymap.set(
    "n",
    "<leader>s",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]
)

--------------------------------------------------
-- Tabs
--------------------------------------------------
vim.keymap.set('n', '<Tab>', ':tabn<CR>')

--------------------------------------------------
-- Root detection helper
--------------------------------------------------
local function get_root()
    local root = vim.fs.root(0, { "CMakeLists.txt", ".git" })
    return root or vim.fn.getcwd()
end

--------------------------------------------------
-- CMake build (FIXED KEYBIND)
--------------------------------------------------
vim.keymap.set("n", "<leader>cb", function()
    local root = get_root()

    -- only build if CMake project exists
    if vim.fn.filereadable(root .. "/CMakeLists.txt") == 0 then
        vim.notify("No CMakeLists.txt found", vim.log.levels.WARN)
        return
    end

    if vim.fn.isdirectory(root .. "/build") == 0 then
        vim.cmd("!cmake -S " .. root .. " -B " .. root .. "/build")
    end

    vim.cmd("!cmake --build " .. root .. "/build")
end, { desc = "CMake Build" })

--------------------------------------------------
-- Debugging (DAP)
--------------------------------------------------

-- Start debugging
vim.keymap.set("n", "<leader>dd", function()
    require("dap").continue()
end, { desc = "Start Debugging" })

-- Build + Debug (C/C++ projects)
vim.keymap.set("n", "<F5>", function()
    local root = get_root()

    if vim.fn.filereadable(root .. "/CMakeLists.txt") == 1 then
        if vim.fn.isdirectory(root .. "/build") == 0 then
            vim.cmd("!cmake -S " .. root .. " -B " .. root .. "/build")
        end

        vim.cmd("!cmake --build " .. root .. "/build")
    end

    require("dap").continue()
end, { desc = "Build + Debug" })

-- Step controls
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

--------------------------------------------------
-- LSP
--------------------------------------------------
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

-- K: diagnostics float (as before)
vim.keymap.set("n", "K", vim.diagnostic.open_float, { desc = "Diagnostics under cursor" })

-- Show diagnostics for the current line (without exact token positioning)
vim.keymap.set("n", "<leader>e", function()
    vim.diagnostic.open_float(nil, { scope = "line" })
end, { desc = "Line diagnostics (float)" })

-- Show all diagnostics for the current buffer in the location list
vim.keymap.set("n", "<leader>,", function()
    vim.diagnostic.setloclist({ open = true })
end, { desc = "Buffer diagnostics (loclist)" })

-- Jump between diagnostics in the current buffer
vim.keymap.set("n", "]d", function()
    vim.diagnostic.goto_next({ float = false })
end, { desc = "Next diagnostic" })

vim.keymap.set("n", "[d", function()
    vim.diagnostic.goto_prev({ float = false })
end, { desc = "Previous diagnostic" })
