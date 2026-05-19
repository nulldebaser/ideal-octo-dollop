return {
  {
    "savq/melange-nvim",
    priority = 1000,
    config = function()
      vim.opt.termguicolors = true
      vim.cmd.colorscheme("melange")

      local hl = vim.api.nvim_set_hl
      hl(0, "Normal", { bg = "none" })
      hl(0, "NormalFloat", { bg = "none" })
      hl(0, "SignColumn", { bg = "none" })

      hl(0, "Comment", { fg = "#8b7653", italic = true })

      hl(0, "GoalHighlight", { fg = "#ebcb8d", bold = true })

      hl(0, "LineNr", { fg = "#5a4a3a" })
      hl(0, "CursorLineNr", { fg = "#ce9e3b", bold = true })
    end,
  },
}
