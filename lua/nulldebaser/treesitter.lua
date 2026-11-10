--- Treesitter parsers and per-buffer feature toggles (Neovim 0.12 + neovim-treesitter).
local M = {}

-- Parsers aligned with LSP stack and previous ensure_installed list.
M.parsers = {
	"bash",
	"c",
	"cpp",
	"css",
	"ecma",
	"html",
	"html_tags",
	"javascript",
	"json",
	"jsx",
	"lua",
	"markdown",
	"markdown_inline",
	"python",
	"query",
	"rust",
	"typescript",
	"vim",
	"vimdoc",
}

M.filetypes = {
	"bash",
	"c",
	"cpp",
	"css",
	"html",
	"javascript",
	"javascriptreact",
	"json",
	"lua",
	"markdown",
	"python",
	"query",
	"rust",
	"sh",
	"typescript",
	"typescriptreact",
	"vim",
	"help",
}

M.no_ts_indent = {
	c = true,
	cpp = true,
}

local function language_for_buf(bufnr)
	local ft = vim.bo[bufnr].filetype
	if ft == "" then
		return nil
	end
	return vim.treesitter.language.get_lang(ft)
end

local function can_highlight(bufnr)
	local lang = language_for_buf(bufnr)
	if not lang then
		return false
	end
	return vim.treesitter.query.get(lang, "highlights") ~= nil
end

function M.enable(bufnr)
	bufnr = bufnr or 0
	if not vim.api.nvim_buf_is_valid(bufnr) or not vim.bo[bufnr].buflisted then
		return
	end
	if not can_highlight(bufnr) then
		return
	end

	pcall(vim.treesitter.start, bufnr)

	local ft = vim.bo[bufnr].filetype
	if not M.no_ts_indent[ft] then
		vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end
end

function M.refresh_open_buffers()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype ~= "" then
			M.enable(buf)
		end
	end
end

function M.setup_autocmds()
	local group = vim.api.nvim_create_augroup("nulldebaser_treesitter", { clear = true })

	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		pattern = M.filetypes,
		callback = function(args)
			M.enable(args.buf)
		end,
	})

	-- Enable highlighting for buffers already open when the plugin loads.
	vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter" }, {
		group = group,
		callback = function()
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype ~= "" then
					M.enable(buf)
				end
			end
		end,
	})
end

return M
