local set_hl = vim.api.nvim_set_hl

-- --- 1. CORE LANGUAGE (Universal) ---
set_hl(0, "@variable", { fg = "#ece1d7" })       -- Warm Parchment (Main Text)
set_hl(0, "@variable.builtin", { fg = "#b34b38" }) -- Burnt Orange (self, this, etc)
set_hl(0, "@keyword", { fg = "#b34b38", bold = true }) -- Burnt Orange (if, return, for)
set_hl(0, "@function", { fg = "#ce9e3b" })      -- Gold (Function names)
set_hl(0, "@function.builtin", { fg = "#ce9e3b", italic = true })
set_hl(0, "@type", { fg = "#859269" })          -- Moss Green (int, struct, class)
set_hl(0, "@type.builtin", { fg = "#859269" })
set_hl(0, "@constant", { fg = "#a6948a" })      -- Warm Grey (CONSTANTS)
set_hl(0, "@number", { fg = "#d3869b" })        -- Muted Rose (1234)
set_hl(0, "@string", { fg = "#859269" })        -- Moss Green ("strings")
set_hl(0, "@operator", { fg = "#a6948a" })      -- Warm Grey (+, -, =)
set_hl(0, "@property", { fg = "#a6948a" }) -- Warm Grey for struct members/object properties
set_hl(0, "@parameter", { fg = "#dfd0c0", italic = true }) -- Slightly dimmer parchment for function arguments

-- --- 2. WEB / HTML (Melange Tones) ---
set_hl(0, "@tag", { fg = "#ce9e3b", bold = true })
set_hl(0, "@tag.attribute", { fg = "#b34b38", italic = true })
set_hl(0, "@tag.delimiter", { fg = "#8b7653" })

-- --- 3. UI TWEAKS ---
set_hl(0, "GoalHighlight", { fg = "#ce9e3b", bold = true })
set_hl(0, "Comment", { fg = "#5a4a3a", italic = true }) -- Deep Walnut

-- --- 4. THE TRANSPARENCY FIX ---
-- This ensures Alacritty's 0.9 opacity background shows through properly
set_hl(0, "Normal", { bg = "none" })
set_hl(0, "NormalFloat", { bg = "none" })
set_hl(0, "SignColumn", { bg = "none" })
set_hl(0, "EndOfBuffer", { fg = "#1d1a18" }) -- Hides the '~' characters
