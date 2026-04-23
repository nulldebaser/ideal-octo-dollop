return {
  {
    "mfussenegger/nvim-dap",
  },
  {
    "nvim-neotest/nvim-nio", -- required by nvim-dap-ui
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

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local dap_python = require("dap-python")

      -- Cache debugpy checks per interpreter
      local debugpy_cache = {}

      local function has_debugpy(python)
        if debugpy_cache[python] ~= nil then
          return debugpy_cache[python]
        end

        vim.fn.system({ python, "-c", "import debugpy" })
        local ok = vim.v.shell_error == 0
        debugpy_cache[python] = ok
        return ok
      end

      -- Cross-platform python path inside .venv
      local function find_venv_python(startpath)
        local found = vim.fs.find(".venv", { path = startpath, upward = true, type = "directory" })
        if found and found[1] then
          local sep = package.config:sub(1,1)
          local python_bin = sep == "\\" and "\\Scripts\\python.exe" or "/bin/python"
          local py = found[1] .. python_bin

          if vim.fn.executable(py) == 1 then
            return py
          end
        end
        return nil
      end

      local function resolve_python()
        -- 1) Activated venv
        local venv = os.getenv("VIRTUAL_ENV")
        if venv and venv ~= "" then
          local sep = package.config:sub(1,1)
          local python_bin = sep == "\\" and "\\Scripts\\python.exe" or "/bin/python"
          local py = venv .. python_bin

          if vim.fn.executable(py) == 1 then
            return py
          end
        end

        -- 2) Buffer path
        local buf = vim.api.nvim_get_current_buf()
        local bufname = vim.api.nvim_buf_get_name(buf)
        if bufname and bufname ~= "" then
          local bufdir = vim.fs.dirname(bufname)
          local py = find_venv_python(bufdir)
          if py then return py end
        end

        -- 3) CWD
        local py = find_venv_python(vim.fn.getcwd())
        if py then return py end

        -- 4) System fallback
        if vim.fn.executable("python3") == 1 then return "python3" end
        return "python"
      end

      local last_config_key = nil

      local function setup_for_current_context()
        local python_path = resolve_python()

        if last_config_key == python_path then return end
        last_config_key = python_path

        dap_python.setup(python_path)

        local dap = require("dap")
        dap.configurations.python = dap.configurations.python or {}

        -- Extend instead of overwrite
        table.insert(dap.configurations.python, {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = python_path,
        })

        table.insert(dap.configurations.python, {
          type = "python",
          request = "launch",
          name = "Launch file with arguments",
          program = "${file}",
          args = function()
            local args_str = vim.fn.input("Arguments: ")
            return vim.split(args_str, " ", { trimempty = true })
          end,
          pythonPath = python_path,
        })

        if not has_debugpy(python_path) then
          vim.schedule(function()
            vim.notify(
              ("nvim-dap-python: debugpy not found for %s\n"
                .. "Install it with:\n  %s -m pip install -U debugpy"):format(
                python_path,
                python_path
              ),
              vim.log.levels.ERROR
            )
          end)
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        desc = "Setup DAP Python dynamically",
        callback = function()
          vim.schedule(setup_for_current_context)
        end,
      })
    end,
  },
}
