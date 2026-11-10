return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",

        config = function()
            local ts = require("nulldebaser.treesitter")

            require("nvim-treesitter").setup({
                install_dir = vim.fn.stdpath("data") .. "/site",
            })

            ts.setup_autocmds()

            vim.schedule(function()
                require("nvim-treesitter").install(ts.parsers):await(function(err)
                    if err then
                        vim.notify(
                            "Treesitter install: " .. tostring(err),
                            vim.log.levels.WARN
                        )
                        return
                    end

                    ts.refresh_open_buffers()
                end)
            end)
        end,
    },
}
