return {
  {
    "mfussenegger/nvim-dap",
  },

  {
    "nvim-neotest/nvim-nio",
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },

    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

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
    end,
  },

  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },

    config = function()
      local dap_python = require("dap-python")

      local function find_venv_python(startpath)
        local found = vim.fs.find(".venv", {
          path = startpath,
          upward = true,
          type = "directory",
        })

        if found[1] then
          local python = found[1] .. "/bin/python"
          if vim.fn.executable(python) == 1 then
            return python
          end
        end
      end

      local function resolve_python()
        local venv = os.getenv("VIRTUAL_ENV")
        if venv and venv ~= "" then
          local py = venv .. "/bin/python"
          if vim.fn.executable(py) == 1 then
            return py
          end
        end

        local buf = vim.api.nvim_buf_get_name(0)
        if buf ~= "" then
          local py = find_venv_python(vim.fs.dirname(buf))
          if py then return py end
        end

        local py = find_venv_python(vim.fn.getcwd())
        if py then return py end

        return "python3"
      end

      dap_python.setup(resolve_python())
    end,
  },
}
