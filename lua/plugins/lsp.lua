return {

{
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = true,
},

{
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },

    config = function()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "pyright",
                "ruff",
                "clangd",
                "rust_analyzer",
                "html",
                "cssls",
                "ts_ls",
            },
        })
    end,
},

{
    "neovim/nvim-lspconfig",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "p00f/clangd_extensions.nvim",
    },

    config = function()

        local capabilities =
            require("cmp_nvim_lsp").default_capabilities()
        local lspconfig = require("lspconfig")

        if vim.fn.exists(":LspInfo") == 0 then
            vim.api.nvim_create_user_command("LspInfo", function()
                vim.cmd("checkhealth vim.lsp")
            end, { desc = "Show LSP health information" })
        end

        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(ev)
                local opts = { buffer = ev.buf }

                vim.keymap.set("n", "K", function()
                    local line = vim.api.nvim_win_get_cursor(0)[1] - 1
                    local line_diags = vim.diagnostic.get(0, { lnum = line })

                    if #line_diags > 0 then
                        vim.diagnostic.open_float(nil, { scope = "cursor" })
                        return
                    end

                    vim.lsp.buf.hover()
                end, opts)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
            end,
        })

        local servers = {
            lua_ls = {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
            },
            pyright = {
                capabilities = capabilities,
            },
            ruff = {
                capabilities = capabilities,
                on_attach = function(client)
                    client.server_capabilities.documentFormattingProvider = false
                end,
            },
            html = {
                capabilities = capabilities,
            },
            cssls = {
                capabilities = capabilities,
            },
            ts_ls = {
                capabilities = capabilities,
            },
            rust_analyzer = {
                capabilities = capabilities,
            },
        }

        require("clangd_extensions").setup({
            server = {
                capabilities = capabilities,
            },
        })
        if vim.lsp.config and vim.lsp.enable then
            for name, config in pairs(servers) do
                vim.lsp.config(name, config)
            end
            vim.lsp.enable(vim.tbl_keys(servers))
            vim.lsp.enable("clangd")
            return
        end

       for name, config in pairs(servers) do
            lspconfig[name].setup(config)
        end
        lspconfig.clangd.setup({
            capabilities = capabilities,
        })
    end,
},

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

            mapping = cmp.mapping.preset.insert({
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ["<CR>"] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),

            sources = {
                { name = "nvim_lsp" },
                { name = "buffer" },
                { name = "path" },
                { name = "luasnip" },
            },

            formatting = {
                format = lspkind.cmp_format(),
            },
        })
    end,
},
}
