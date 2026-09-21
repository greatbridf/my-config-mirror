local M = {}

function M.git_show(commit)
	if vim.fn.system("git describe --always " .. commit) and vim.v.shell_error ~= 0 then
		vim.api.nvim_echo(
			{{ commit .. " is not a valid git commit", "WarningMsg" }},
			false, {}
		)
		return
	end

	local lines = vim.fn.systemlist("git show --stat -p " .. commit)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].filetype = "git"
	vim.bo[buf].modifiable = false

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

	local caller_buf = vim.api.nvim_get_current_buf()
	local opts = { noremap = true, silent = true, nowait = true, buffer = caller_buf }

	local function close()
		if vim.api.nvim_win_is_valid(winid) then
			vim.api.nvim_win_close(winid, true)
		end
		vim.keymap.del("n", "<C-j>", { buffer = caller_buf })
		vim.keymap.del("n", "<C-k>", { buffer = caller_buf })
		vim.keymap.del("n", "<C-d>", { buffer = caller_buf })
		vim.keymap.del("n", "<C-u>", { buffer = caller_buf })
		vim.keymap.del("n", "q",     { buffer = caller_buf })
	end

	local au_id
	au_id = vim.api.nvim_create_autocmd("CursorMoved", {
		buffer = caller_buf,
		once = true,
		callback = function()
			close()
			vim.api.nvim_del_autocmd(au_id)
		end,
	})

	local function scroll(keys)
		return function()
			vim.api.nvim_win_call(winid, function() vim.cmd("normal! " .. keys) end)
		end
	end

	vim.keymap.set("n", "<C-j>", scroll("\x05"), opts) -- <C-e>
	vim.keymap.set("n", "<C-k>", scroll("\x19"), opts) -- <C-y>
	vim.keymap.set("n", "<C-d>", scroll("\x04"), opts)
	vim.keymap.set("n", "<C-u>", scroll("\x15"), opts)
	vim.keymap.set("n", "q",     close,          opts)
end

function M.setup(opts)
	vim.api.nvim_create_user_command("GreatbridfGitShow", function(opts)
		M.git_show(opts.args)
	end, { nargs = 1 })

	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "git", "gitrebase" },
		callback = function()
			vim.opt_local.keywordprg = ":GreatbridfGitShow"
		end,
	})
end

return M
