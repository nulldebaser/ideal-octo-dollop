return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable('make') == 1
      end,
    },
  },
  config = function()
    require('telescope').setup {
      extensions = {
        fzf = {
          fuzzy = true,                -- fuzzy matching
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",   -- or "ignore_case" / "respect_case"
        }
      }
    }

    -- Load the extension
    pcall(require('telescope').load_extension, 'fzf')
  end
}
