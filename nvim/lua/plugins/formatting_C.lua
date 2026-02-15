-- plugins/formatting_C.lua
return {
    {
        "stevearc/conform.nvim",
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    c = { "clang_format" },
                    cpp = { "clang_format" },
                    lua = { "stylua" },
                    python = { "black" },
                },

                formatters = {
                    clang_format = {
                        prepend_args = { "--style=file" },
                    },
                },

                format_on_save = {
                    timeout_ms = 500,
                    lsp_fallback = false,
                },
            })
        end,
    },
}
