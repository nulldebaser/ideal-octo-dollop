local project = require("nulldebaser.project")

local function c_executable(root)
    for _, name in ipairs({ "app", "main", "a.out" }) do
        local path = root .. "/build/" .. name
        if vim.fn.filereadable(path) == 1 then
            return path
        end
    end
    return vim.fn.input("Path to executable: ", root .. "/build/", "file")
end

return {
    "mfussenegger/nvim-dap",
    dependencies = {
        {
            "rcarriga/nvim-dap-ui",
            dependencies = { "nvim-neotest/nvim-nio" },
        },
        "mfussenegger/nvim-dap-python",
        "jay-babu/mason-nvim-dap.nvim",
        "williamboman/mason.nvim",
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")
        local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { desc = desc })
        end

        require("mason-nvim-dap").setup({
            ensure_installed = { "codelldb" },
            automatic_installation = true,
        })

        dap.adapters.codelldb = {
            type = "server",
            port = "${port}",
            executable = {
                command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
                args = { "--port", "${port}" },
            },
        }

        local launch = {
            name = "Launch",
            type = "codelldb",
            request = "launch",
            program = function()
                return c_executable(project.root())
            end,
            cwd = function()
                return project.root()
            end,
            stopOnEntry = false,
            runInTerminal = true,
        }
        dap.configurations.c = { launch }
        dap.configurations.cpp = dap.configurations.c

        dapui.setup()
        dap.listeners.after.event_initialized["dapui"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui"] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui"] = function()
            dapui.close()
        end

        require("dap-python").setup(
            vim.fn.stdpath("data") .. "/debugpy/bin/python"
        )
        map("<leader>dd", dap.continue, "DAP: continue")
        map("<F5>", function()
            local root = project.root()
            if vim.fn.filereadable(root .. "/CMakeLists.txt") == 1 then
                project.cmake_build(root)
            end
            dap.continue()
        end, "DAP: CMake build + continue")
        map("<F10>", dap.step_over, "DAP: step over")
        map("<F11>", dap.step_into, "DAP: step into")
        map("<F12>", dap.step_out, "DAP: step out")
        map("<leader>b", dap.toggle_breakpoint, "DAP: toggle breakpoint")
        map("<leader>B", function()
            dap.set_breakpoint(vim.fn.input("Condition: "))
        end, "DAP: conditional breakpoint")
        map("<leader>dr", dap.restart, "DAP: restart")
        map("<leader>dq", dap.terminate, "DAP: quit")
    end,
}
