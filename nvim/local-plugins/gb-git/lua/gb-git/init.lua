local M = {}

M.config = {
	-- Keep the git show buffer around (listed and named) after the popup is
	-- closed, so it can later be opened in a split, vsplit or tab via
	-- :GreatbridfGitOpen or the usual buffer commands.
	keep = true,
}

local function buf_name(commit)
	return "gb-git://" .. commit
end

local BUF_PREFIX = "gb-git://"

local state_file = vim.fn.stdpath("state") .. "/gb-git-last-commit"

local function save_last_commit(commit)
	local f = io.open(state_file, "w")
	if f then
		f:write(commit)
		f:close()
	end
end

local function read_last_commit()
	local f = io.open(state_file, "r")
	if not f then
		return nil
	end
	local commit = f:read("*l")
	f:close()
	if not commit or commit == "" then
		return nil
	end
	return commit
end

local function is_gb_buf(b)
	return b ~= nil
		and vim.api.nvim_buf_is_valid(b)
		and vim.api.nvim_buf_get_name(b):sub(1, #BUF_PREFIX) == BUF_PREFIX
end

local function find_buf(name)
	for _, b in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(b) and vim.api.nvim_buf_get_name(b) == name then
			return b
		end
	end
end

local function find_any_buf()
	local cur = vim.api.nvim_get_current_buf()
	if is_gb_buf(cur) then
		return cur
	end
	for _, b in ipairs(vim.api.nvim_list_bufs()) do
		if is_gb_buf(b) then
			return b
		end
	end
end

local function valid_commit(commit)
	vim.fn.system("git describe --always " .. commit)
	return vim.v.shell_error == 0
end

local function open_buf(buf, mode)
	if mode == "tab" then
		vim.cmd("tab sbuffer " .. buf)
	elseif mode == "split" then
		vim.cmd("sbuffer " .. buf)
	elseif mode == "vsplit" then
		vim.cmd("vertical sbuffer " .. buf)
	else
		vim.cmd("buffer " .. buf)
	end
end

--- Create or reuse the buffer for `commit` and fill it with `git show`
--- output. The buffer is left modifiable; the caller decides when it has
--- actually been displayed and can be locked again.
function M.load(commit)
	local lines = vim.fn.systemlist("git show --stat -p " .. commit)

	local buf
	if M.config.keep then
		buf = find_buf(buf_name(commit))
	end
	if not buf then
		buf = vim.api.nvim_create_buf(M.config.keep, false)
		if M.config.keep then
			vim.api.nvim_buf_set_name(buf, buf_name(commit))
		end
	end
	M.last_buf = buf
	M.last_commit = commit
	save_last_commit(commit)

	vim.bo[buf].modifiable = true
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].filetype = "git"
	-- Synthetic buffer: never write it to disk, keep no swap file, and do not
	-- let it participate in :q / :wq "no write since last change" checks.
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].swapfile = false
	vim.bo[buf].modified = false
	return buf
end

--- Open the most recently shown git buffer in the current window, a split,
--- a vertical split, or a new tab. Falls back to an existing gb-git buffer,
--- then to the last shown commit, then to HEAD, so it works even without a
--- prior :GreatbridfGitShow.
function M.open_last(mode)
	local buf = M.last_buf
	if not buf or not vim.api.nvim_buf_is_valid(buf) then
		-- M.last_buf is lost across restarts/session restores, so fall back
		-- to an existing gb-git buffer before giving up.
		buf = find_any_buf()
	end
	if not buf then
		local commit = M.last_commit
		if not commit or not valid_commit(commit) then
			commit = "HEAD"
		end
		if valid_commit(commit) then
			buf = M.load(commit)
		end
	end
	if not buf then
		vim.api.nvim_echo({ { "gb-git: no buffer to open", "WarningMsg" } }, false, {})
		return
	end
	M.last_buf = buf
	open_buf(buf, mode or "edit")
	vim.bo[buf].modifiable = false
end

function M.git_show(commit)
	if not valid_commit(commit) then
		vim.api.nvim_echo(
			{ { commit .. " is not a valid git commit", "WarningMsg" } },
			false, {}
		)
		return
	end

	local buf = M.load(commit)

	local width = math.min(math.floor(vim.o.columns * 0.9), vim.o.columns - 6)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local winid = vim.api.nvim_open_win(buf, false, {
		relative = "editor",
		row = row,
		col = col,
		width = width,
		height = height,
		style = "minimal",
		border = "single",
		focusable = false,
	})

	vim.bo[buf].modifiable = false

	local caller_buf = vim.api.nvim_get_current_buf()
	local opts = { noremap = true, silent = true, nowait = true, buffer = caller_buf }
	local keymaps = { "<C-j>", "<C-k>", "<C-d>", "<C-u>", "q" }

	local closed = false
	local au_id
	local function close()
		if closed then
			return
		end
		closed = true
		if au_id then
			pcall(vim.api.nvim_del_autocmd, au_id)
		end
		if vim.api.nvim_win_is_valid(winid) then
			vim.api.nvim_win_close(winid, true)
		end
		for _, lhs in ipairs(keymaps) do
			pcall(vim.keymap.del, "n", lhs, { buffer = caller_buf })
		end
	end

	au_id = vim.api.nvim_create_autocmd("CursorMoved", {
		buffer = caller_buf,
		once = true,
		callback = close,
	})

	local function scroll(keys)
		return function()
			if vim.api.nvim_win_is_valid(winid) then
				vim.api.nvim_win_call(winid, function()
					vim.cmd("normal! " .. keys)
				end)
			end
		end
	end

	vim.keymap.set("n", "<C-j>", scroll("\x05"), opts) -- <C-e>
	vim.keymap.set("n", "<C-k>", scroll("\x19"), opts) -- <C-y>
	vim.keymap.set("n", "<C-d>", scroll("\x04"), opts)
	vim.keymap.set("n", "<C-u>", scroll("\x15"), opts)
	vim.keymap.set("n", "q", close, opts)
end

function M.setup(opts)
	opts = opts or {}
	M.config = vim.tbl_deep_extend("force", M.config, opts)

	if M.last_commit == nil then
		M.last_commit = read_last_commit()
	end

	vim.api.nvim_create_user_command("GreatbridfGitShow", function(cmd_opts)
		M.git_show(cmd_opts.args)
	end, { nargs = 1 })

	vim.api.nvim_create_user_command("GreatbridfGitOpen", function(cmd_opts)
		M.open_last(cmd_opts.args ~= "" and cmd_opts.args or "edit")
	end, {
		nargs = "?",
		complete = function()
			return { "edit", "split", "vsplit", "tab" }
		end,
	})

	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "git", "gitrebase" },
		callback = function()
			vim.opt_local.keywordprg = ":GreatbridfGitShow"
		end,
	})
end

return M
