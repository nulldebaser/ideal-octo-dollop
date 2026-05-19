return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "mfussenegger/nvim-dap",
      "williamboman/mason.nvim",
    },

    config = function()
      local dap = require("dap")

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

      local function enable_c_debug()
        local function get_root()
          local root = vim.fs.root(0, {
            "CMakeLists.txt",
            ".git",
          })
          return root or vim.fn.getcwd()
        end

        dap.configurations.c = {
          {
            name = "Launch (CMake)",
            type = "codelldb",
            request = "launch",
            program = function()
              return get_root() .. "/build/app"
            end,
            cwd = get_root,
            runInTerminal = true,
          },
        }

        dap.configurations.cpp = dap.configurations.c
      end

      local function disable_c_debug()
        dap.configurations.c = nil
        dap.configurations.cpp = nil
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp" },
        callback = enable_c_debug,
      })

      vim.api.nvim_create_autocmd("BufLeave", {
        callback = function()
          if vim.bo.filetype ~= "c" and vim.bo.filetype ~= "cpp" then
            disable_c_debug()
          end
        end,
      })
    end,
  },
}
