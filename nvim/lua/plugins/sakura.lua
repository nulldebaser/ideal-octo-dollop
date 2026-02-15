return {
    {
        "anAcc22/sakura.nvim",
        dependencies = { "rktjmp/lush.nvim" },
        lazy = false,
        priority = 1000,
        config = function()
            -- Background (choose "dark" or "light")
            vim.opt.background = "dark"
            vim.cmd.colorscheme("sakura")

            -- Keywords
            vim.api.nvim_set_hl(0, "@keyword", { link = "Keyword" })
            vim.api.nvim_set_hl(0, "@keyword.return", { link = "Keyword" })
            vim.api.nvim_set_hl(0, "@conditional", { link = "Conditional" })

            -- Types
            vim.api.nvim_set_hl(0, "@type.builtin", { link = "Type" })

            -- Functions
            vim.api.nvim_set_hl(0, "@function.builtin", { link = "Function" })
            vim.api.nvim_set_hl(0, "@function.call", { link = "Function" })

            -- Variables
            vim.api.nvim_set_hl(0, "@variable.builtin", { link = "Identifier" })

            -- 🌸 Transparency
            vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
            vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
            vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "none" })

            -- 🌸 Italics for readability
            vim.api.nvim_set_hl(0, "Comment", { italic = true })
            vim.api.nvim_set_hl(0, "Conditional", { italic = true })

            -- 🌸 Slightly dim inactive windows (optional, like Catppuccin’s dim_inactive)
            vim.api.nvim_set_hl(0, "NormalNC", { bg = "none", fg = "#aaaaaa" })

            -- 🌸 Softer line numbers
            vim.api.nvim_set_hl(0, "LineNr", { fg = "#777777" })
            vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#d7c97b", bold = true })

            -- 🌸 Custom highlight for "👉 Goal:" inside .txt notes
            vim.api.nvim_set_hl(0, "GoalHighlight", { fg = "#d7c97b", bold = true })
            vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
                pattern = { "*.txt" },
                command = "set filetype=markdown",
            })
            vim.api.nvim_create_autocmd("Syntax", {
                pattern = "*.txt",
                callback = function()
                    vim.cmd([[syntax match GoalHighlight "👉 Goal:"]])
                end,
            })
        end,
    },
}
