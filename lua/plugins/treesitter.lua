return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "javascript",
                    "typescript",
                    "c",
                    "cpp",
                    "lua",
                    "vim",
                    "vimdoc",
                    "query",
                    "markdown",
                    "markdown_inline",
                    "html",
                    "css",
                    "python",
                    "rust",
                },

                sync_install = false,
                auto_install = false,

                highlight = {
                    enable = true,
                },

                indent = {
                    enable = true,
                    disable = { "c", "cpp" },
                },
            })
        end,
    },
}
