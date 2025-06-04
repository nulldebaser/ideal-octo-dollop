return {
    -- Mason: easy install/manage language servers
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = true,
    },
    -- Bridges Mason with lspconfig
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "pyright", "ts_ls", "clangd" }, -- add more if you want
                automatic_installation = true,
            })
        end,
    },
    -- Core lsp config plugin
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            capabilities.positionEncoding = "utf-16"

            -- Lua LS setup
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                    },
                },
            })

            -- Python: Pyright for type checking
            lspconfig.pyright.setup({
                capabilities = capabilities,
                settings = {
                    python = {
                        analysis = {
                            typeCheckingMode = "basic",
                            diagnosticMode = "openFilesOnly",
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            diagnosticSeverityOverrides = {
                                reportUnusedVariable = "none",
                                reportUnusedImport = "none",
                                reportMissingImports = "none",
                                reportMissingModuleSource = "none",
                                reportUnboundVariable = "none",
                            },
                        },
                    },
                },
            })

            -- Python: Ruff for linting only
            lspconfig.ruff.setup({
                capabilities = capabilities,
                on_attach = function(client)
                    -- force UTF-16 position encoding
                    client.offset_encoding = "utf-16"
                    client.server_capabilities.documentFormattingProvider = false
                end,
            })

            -- TypeScript/JavaScript
            lspconfig.ts_ls.setup({
                capabilities = capabilities,
            })

            -- C/C++
            lspconfig.clangd.setup({
                capabilities = capabilities,
            })
        end,
    },
    -- Autocompletion engine
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip", -- snippet engine
            "onsails/lspkind.nvim", -- nice vscode-like icons
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = {
                    autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                },
                formatting = {
                    format = lspkind.cmp_format({ with_text = true, maxwidth = 50 }),
                },
            })
        end,
    },
}
