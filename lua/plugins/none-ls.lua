return {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local null_ls = require("null-ls")

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.positionEncoding = { "utf-16" }

        null_ls.setup({
            capabilities = capabilities,
            sources = {
                null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.prettier,
                -- clang_format REMOVED because Conform handles C/C++
            },
            on_attach = function(client, bufnr)
                -- No formatting autocmd here (Conform handles formatting)
            end,
        })
    end,
}
