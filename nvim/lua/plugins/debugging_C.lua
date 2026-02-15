-- plugins/debugging.lua
return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "williamboman/mason.nvim",
            "jay-babu/mason-nvim-dap.nvim",
            "nvim-neotest/nvim-nio", -- REQUIRED for nvim-dap-ui
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            -- Setup Mason integration for DAP
            require("mason-nvim-dap").setup({
                ensure_installed = { "codelldb" }, -- debugger for C/C++
                automatic_installation = true,
            })

            -- UI setup
            dapui.setup()

            -- Auto-open/close dap-ui
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            -- Adapter for C/C++ using codelldb
            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
                    args = { "--port", "${port}" },
                },
            }

            dap.configurations.c = {
                {
                    name = "Launch file",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                    args = {},
                },
            }

            dap.configurations.cpp = dap.configurations.c
        end,
    },
}
