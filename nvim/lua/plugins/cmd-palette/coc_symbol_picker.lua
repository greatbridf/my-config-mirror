local M = {}

local function entry(value, display, ordinal)
	return { value = value, display = display, ordinal = ordinal }
end

function M.document_entry(symbol)
	local name = symbol.text or symbol.name or ''
	local kind = tostring(symbol.kind or '')
	local line = tonumber(symbol.lnum) or 1
	return entry({
		filename = nil,
		line = line,
		column = math.max((tonumber(symbol.col) or 1) - 1, 0),
	}, string.rep('  ', tonumber(symbol.level) or 0) .. name .. ' [' .. kind .. ']', name .. ' ' .. kind)
end

function M.workspace_entry(symbol)
	local location = symbol.location or symbol
	local uri = location.uri or location.targetUri
	local range = location.range or location.targetSelectionRange or location.targetRange
	local name = symbol.name or symbol.text or ''
	local filename = uri and vim.uri_to_fname(uri) or ''
	local line = range and range.start and (range.start.line + 1) or 1
	local column = range and range.start and range.start.character or 0
	local kind = tostring(symbol.kind or '')
	local shown_path = filename ~= '' and vim.fn.fnamemodify(filename, ':~:.') or '[unknown file]'
	return entry({ filename = filename, line = line, column = column },
		string.format('%s [%s]  %s:%d', name, kind, shown_path, line),
		name .. ' ' .. kind .. ' ' .. filename)
end

function M.open(opts)
	local pickers = require('telescope.pickers')
	local telescope = require('telescope.config').values
	local previewers = require('telescope.previewers')
	local actions = require('telescope.actions')
	local action_state = require('telescope.actions.state')
	local tel_opts = require('command-palette.config').telescope_for(opts.cfg, opts.mode)
	local source_buf = opts.source_buf

	pickers.new(tel_opts, {
		prompt_title = opts.title,
		previewer = previewers.new_buffer_previewer({
			title = 'Source',
			define_preview = function(self, selected, status)
				local filename = selected.value.filename
				local bufnr = filename and filename ~= '' and vim.fn.filereadable(filename) == 1
					and vim.fn.bufadd(filename) or source_buf
				if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
					vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, { 'Source file is unavailable' })
					return
				end
				if not vim.api.nvim_buf_is_loaded(bufnr) then
					vim.fn.bufload(bufnr)
				end

				local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
				vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
				vim.bo[self.state.bufnr].filetype = vim.bo[bufnr].filetype
				local line = math.max(1, math.min(tonumber(selected.value.line) or 1, math.max(#lines, 1)))
				vim.api.nvim_buf_add_highlight(self.state.bufnr, -1, 'TelescopePreviewLine', line - 1, 0, -1)
				local preview_win = status.layout.preview and status.layout.preview.winid
				vim.schedule(function()
					if preview_win and vim.api.nvim_win_is_valid(preview_win) then
						pcall(vim.api.nvim_win_set_cursor, preview_win, { line, 0 })
					end
				end)
			end,
		}),
		finder = opts.finder,
		sorter = telescope.generic_sorter(tel_opts),
		default_text = opts.query,
		attach_mappings = function(prompt_bufnr, map)
			opts.attach_switcher(prompt_bufnr, map)
			actions.select_default:replace(function()
				local selected = action_state.get_selected_entry()
				actions.close(prompt_bufnr)
				if not selected then return end

				local location = selected.value
				if location.filename and location.filename ~= '' then
					vim.cmd.edit(vim.fn.fnameescape(location.filename))
				elseif source_buf and vim.api.nvim_buf_is_valid(source_buf) then
					vim.api.nvim_win_set_buf(0, source_buf)
				end
				vim.api.nvim_win_set_cursor(0, { location.line, location.column })
			end)
			return true
		end,
	}):find()
end

return M
