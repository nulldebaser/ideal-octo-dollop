-- plugins/treesitter.lua
return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = {
                    "javascript",
                    "typescript",
                    "c",   -- C language
                    "cpp", -- C++ support (often useful alongside C)
                    "lua",
                    "vim",
                    "vimdoc",
                    "query",
                    "markdown",
                    "markdown_inline",
                    "html",
                    "css",
                    "python"
                },
                sync_install = false,
                auto_install = true,

                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },

                indent = {
                    enable = true,
                    disable = { "c", "cpp" }, -- disable Treesitter indent for C/C++
                },
            }
        end
    }
}
