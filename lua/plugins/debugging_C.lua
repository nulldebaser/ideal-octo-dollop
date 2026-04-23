-- plugins/debugging.lua
return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "williamboman/mason.nvim",
            "jay-babu/mason-nvim-dap.nvim",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            ------------------------------------------------------------------
            -- 🔍 Root detection
            ------------------------------------------------------------------
            local function get_root()
                local root = vim.fs.root(0, { "CMakeLists.txt", ".git" })
                return root or vim.fn.getcwd()
            end

            ------------------------------------------------------------------
            -- 🔥 THIS IS THE IMPORTANT FIX
            ------------------------------------------------------------------
            dap.defaults.fallback.terminal_win_cmd = "split new"

            ------------------------------------------------------------------
            -- 📦 Mason
            ------------------------------------------------------------------
            require("mason-nvim-dap").setup({
                ensure_installed = { "codelldb" },
                automatic_installation = true,
            })

            ------------------------------------------------------------------
            -- 🧠 UI
            ------------------------------------------------------------------
            dapui.setup({
                layouts = {
                    {
                        elements = {
                            { id = "scopes", size = 0.25 },
                            { id = "breakpoints", size = 0.25 },
                            { id = "stacks", size = 0.25 },
                            { id = "watches", size = 0.25 },
                        },
                        size = 40,
                        position = "left",
                    },
                    {
                        elements = {
                            { id = "repl", size = 0.5 },
                            { id = "console", size = 0.5 },
                        },
                        size = 10,
                        position = "bottom",
                    },
                },
            })

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            ------------------------------------------------------------------
            -- 🐞 Adapter
            ------------------------------------------------------------------
            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
                    args = { "--port", "${port}" },
                },
            }

            ------------------------------------------------------------------
            -- 🚀 Config
            ------------------------------------------------------------------
            dap.configurations.c = {
                {
                    name = "Launch (CMake)",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return get_root() .. "/build/app"
                    end,
                    cwd = function()
                        return get_root()
                    end,
                    stopOnEntry = false,
                    args = {},
                    runInTerminal = true, -- required
                },
            }

            dap.configurations.cpp = dap.configurations.c
        end,
    },
}
