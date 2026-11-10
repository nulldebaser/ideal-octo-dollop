local M = {}

--- Project root for the current buffer (CMake, git, Rust, Python).
function M.root(bufnr)
	bufnr = bufnr or 0
	local name = vim.api.nvim_buf_get_name(bufnr)
	local start = name ~= "" and vim.fs.dirname(name) or nil
	return vim.fs.root(start or 0, {
		"CMakeLists.txt",
		".git",
		"Cargo.toml",
		"pyproject.toml",
		"package.json",
	}) or vim.fn.getcwd()
end

--- Default projects directory for telescope (<leader>p).
function M.dev_dir()
	local dir = vim.g.nulldebaser_dev_dir
	if dir and dir ~= "" then
		return vim.fn.expand(dir)
	end
	return vim.fn.expand("~/dev")
end

--- Resolve a Python interpreter (venv-aware).
function M.python()
	local venv = os.getenv("VIRTUAL_ENV")
	if venv and venv ~= "" then
		local py = venv .. "/bin/python"
		if vim.fn.executable(py) == 1 then
			return py
		end
	end

	local function from_dir(dir)
		if not dir then
			return nil
		end
		local found = vim.fs.find(".venv", { path = dir, upward = true, type = "directory" })
		if found[1] then
			local py = found[1] .. "/bin/python"
			if vim.fn.executable(py) == 1 then
				return py
			end
		end
	end

	local buf = vim.api.nvim_buf_get_name(0)
	if buf ~= "" then
		local py = from_dir(vim.fs.dirname(buf))
		if py then
			return py
		end
	end

	return from_dir(vim.fn.getcwd()) or "python3"
end

--- Configure and build a CMake project under root.
function M.cmake_build(root)
	root = root or M.root()
	if vim.fn.filereadable(root .. "/CMakeLists.txt") == 0 then
		vim.notify("No CMakeLists.txt found", vim.log.levels.WARN)
		return false
	end
	if vim.fn.isdirectory(root .. "/build") == 0 then
		vim.cmd("!cmake -S " .. vim.fn.shellescape(root) .. " -B " .. vim.fn.shellescape(root .. "/build"))
	end
	vim.cmd("!cmake --build " .. vim.fn.shellescape(root .. "/build"))
	return true
end

return M
