-- 🌸 Sakura HTML Highlighting
local set_hl = vim.api.nvim_set_hl

-- HTML
set_hl(0, "@tag", { fg = "#ffb7c5", bold = true })
set_hl(0, "@tag.delimiter", { fg = "#ffd791" })
set_hl(0, "@attribute", { fg = "#7fc8f8", italic = true })
set_hl(0, "@string", { fg = "#286983" })
set_hl(0, "@comment", { fg = "#9a9a9a", italic = true })

-- (later we can add CSS or JS highlights here too)
