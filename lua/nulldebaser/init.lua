require("nulldebaser.set")
require("nulldebaser.remaps")
require("nulldebaser.highlights")

vim.opt.guicursor = {
    "n-v-c:block-Cursor/lCursor-blinkon500-blinkoff500-blinkwait500",
    "i-ci:ver25-Cursor-blinkon500-blinkoff500-blinkwait500",
    "r-cr:hor20-Cursor-blinkon500-blinkoff500-blinkwait500",
    "o:hor50-Cursor-blinkon500-blinkoff500-blinkwait500"
}

vim.api.nvim_set_hl(0, "@lsp.type.class", { link = "@type" })
vim.api.nvim_set_hl(0, "@lsp.type.enum", { link = "@type" })
vim.api.nvim_set_hl(0, "@lsp.type.struct", { link = "@type" })
vim.api.nvim_set_hl(0, "@lsp.type.interface", { link = "@type" })
vim.api.nvim_set_hl(0, "@lsp.type.namespace", { link = "@namespace" })
vim.api.nvim_set_hl(0, "@lsp.type.parameter", { link = "@parameter" })
vim.api.nvim_set_hl(0, "@lsp.type.variable", { link = "@variable" })
vim.api.nvim_set_hl(0, "@lsp.type.property", { link = "@property" })
vim.api.nvim_set_hl(0, "@lsp.type.function", { link = "@function" })

vim.opt.termguicolors = true
