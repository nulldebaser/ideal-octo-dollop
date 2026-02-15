return {

    -----------------------------------------------------------
    -- Mason
    -----------------------------------------------------------
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = true,
    },

    -----------------------------------------------------------
    -- Mason <-> LSP bridge
    -----------------------------------------------------------
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "pyright",
                    "ts_ls",
                    "clangd",
                    "html",
                    "cssls",
                    "ruff",
                },
                automatic_installation = true,
            })
        end,
    },

    -----------------------------------------------------------
    -- Core LSP (NEW API, CORRECT)
    -----------------------------------------------------------
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "p00f/clangd_extensions.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },

        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local util = require("lspconfig.util")

            ---------------------------------------------------
            -- HTML
            ---------------------------------------------------
            vim.lsp.config.html = {
                capabilities = capabilities,
            }

            ---------------------------------------------------
            -- CSS
            ---------------------------------------------------
            vim.lsp.config.cssls = {
                capabilities = capabilities,
            }

            ---------------------------------------------------
            -- Lua
            ---------------------------------------------------
            vim.lsp.config.lua_ls = {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
            }

            ---------------------------------------------------
            -- Python: Pyright
            ---------------------------------------------------
            vim.lsp.config.pyright = {
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
            }

            ---------------------------------------------------
            -- Python: Ruff
            ---------------------------------------------------
            vim.lsp.config.ruff = {
                capabilities = vim.tbl_deep_extend("force", capabilities, {
                    offsetEncoding = { "utf-16" },
                }),
                on_attach = function(client)
                    client.server_capabilities.documentFormattingProvider = false
                end,
            }

            ---------------------------------------------------
            -- TypeScript
            ---------------------------------------------------
            vim.lsp.config.ts_ls = {
                capabilities = capabilities,
            }

            ---------------------------------------------------
            -- Enable non-clangd servers
            ---------------------------------------------------
            vim.lsp.enable({
                "html",
                "cssls",
                "lua_ls",
                "pyright",
                "ruff",
                "ts_ls",
            })

            ---------------------------------------------------
            -- C / C++ : clangd (via clangd_extensions)
            ---------------------------------------------------
            require("clangd_extensions").setup({
                server = {
                    capabilities = vim.tbl_deep_extend("force", capabilities, {
                        offsetEncoding = { "utf-16" },
                    }),

                    cmd = {
                        "clangd",
                        "--background-index",
                        "--clang-tidy",
                        "--completion-style=detailed",
                        "--cross-file-rename",
                        "--header-insertion=never",
                    },

                    root_dir = util.root_pattern(
                        ".clangd",
                        "compile_commands.json",
                        "Makefile"
                    ),

                    on_attach = function(client)
                        client.server_capabilities.documentFormattingProvider = false
                    end,
                },

                extensions = {
                    inlay_hints = {
                        only_current_line = false,
                        show_parameter_hints = true,
                        parameter_hints_prefix = "⟪ ",
                        other_hints_prefix = "⟫ ",
                    },
                },
            })
        end,
    },

    -----------------------------------------------------------
    -- nvim-cmp (UNCHANGED)
    -----------------------------------------------------------
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
            "onsails/lspkind.nvim",
            "rafamadriz/friendly-snippets",
        },

        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },

                completion = {
                    autocomplete = {
                        require("cmp.types").cmp.TriggerEvent.TextChanged,
                    },
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
                    format = lspkind.cmp_format({
                        with_text = true,
                        maxwidth = 50,
                    }),
                },
            })
        end,
    },
}
