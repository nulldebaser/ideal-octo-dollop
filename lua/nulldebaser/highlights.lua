local hl = vim.api.nvim_set_hl

hl(0, "@variable", { fg = "#6f8f8a" })
hl(0, "@variable.member", { fg = "#7aa6b8" })
hl(0, "@variable.builtin", { fg = "#c47c48", italic = true })

hl(0, "@parameter", { fg = "#b8a38a", italic = true })
hl(0, "@variable.parameter", { fg = "#b8a38a", italic = true })

hl(0, "@field", { fg = "#7aa6b8" })
hl(0, "@property", { fg = "#7aa6b8" })

hl(0, "@keyword", { fg = "#b34b38", bold = true })
hl(0, "@keyword.function", { fg = "#b34b38", bold = true })
hl(0, "@keyword.return", { fg = "#b34b38", bold = true })
hl(0, "@conditional", { fg = "#b34b38", bold = true })
hl(0, "@repeat", { fg = "#b34b38", bold = true })

hl(0, "@function", { fg = "#d6a24a" })
hl(0, "@function.call", { fg = "#d6a24a" })
hl(0, "@function.builtin", { fg = "#d6a24a", italic = true })

hl(0, "@function.method", { fg = "#5f89a6" })
hl(0, "@function.method.call", { fg = "#6fa3c8", bold = true })

hl(0, "@type", { fg = "#9ca33a" })
hl(0, "@type.builtin", { fg = "#9ca33a", italic = true })
hl(0, "@class", { fg = "#9ca33a", bold = true })
hl(0, "@struct", { fg = "#9ca33a" })
hl(0, "@namespace", { fg = "#b29f78" })

hl(0, "@constant", { fg = "#b26a6a" })
hl(0, "@constant.builtin", { fg = "#b26a6a", italic = true })

hl(0, "@number", { fg = "#e07a5f" })
hl(0, "@boolean", { fg = "#e07a5f", bold = true })
hl(0, "@float", { fg = "#e07a5f" })

hl(0, "@string", { fg = "#c7b089" })
hl(0, "@string.escape", { fg = "#d6a24a" })

hl(0, "@operator", { fg = "#8b8476" })
hl(0, "@punctuation", { fg = "#8b8476" })
hl(0, "@punctuation.delimiter", { fg = "#8b8476" })
hl(0, "@punctuation.bracket", { fg = "#8b8476" })
hl(0, "@punctuation.special", { fg = "#d6a24a" })

hl(0, "@tag", { fg = "#d6a24a", bold = true })
hl(0, "@tag.attribute", { fg = "#c47c48", italic = true })
hl(0, "@tag.delimiter", { fg = "#8b8476" })

hl(0, "@comment", { fg = "#7a7468", italic = true })
hl(0, "Comment", { fg = "#7a7468", italic = true })

hl(0, "LineNr", { fg = "#5f574a" })
hl(0, "CursorLineNr", { fg = "#d6a24a", bold = true })

hl(0, "Normal", { bg = "none" })
hl(0, "NormalFloat", { bg = "none" })
hl(0, "SignColumn", { bg = "none" })

hl(0, "EndOfBuffer", { fg = "#2c2620" })

hl(0, "GoalHighlight", { fg = "#d6a24a", bold = true })
