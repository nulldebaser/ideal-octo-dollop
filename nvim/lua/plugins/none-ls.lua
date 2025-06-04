return {
    "nvimtools/none-ls.nvim",  -- continuation of null-ls
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local null_ls = require("null-ls")

        -- Set capabilities with positionEncoding utf-16
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.positionEncoding = { "utf-16" }

        null_ls.setup({
            capabilities = capabilities,  -- add this line
            sources = {
                null_ls.builtins.formatting.black,
            },
            on_attach = function(client, bufnr)
                if client.supports_method("textDocument/formatting") then
                    local group = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
                    vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = group,
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ bufnr = bufnr })
                        end,
                    })
                end
            end,
        })
    end,
}
