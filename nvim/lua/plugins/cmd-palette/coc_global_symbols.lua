local picker = require('plugins.cmd-palette.coc_symbol_picker')

return {
	prefix = '$',
	title = '  Coc Global Symbols',
	open = function(query, attach_switcher, cfg)
		local finders = require('telescope.finders')
		local function workspace_symbols(input)
			if input == '' then return {} end
			local ok, symbols = pcall(vim.fn.CocAction, 'getWorkspaceSymbols', input)
			if not ok or type(symbols) ~= 'table' then return {} end
			return symbols
		end

		picker.open({
			title = '  Coc Global Symbols',
			query = query,
			cfg = cfg,
			-- Match the document-symbol picker's Telescope layout.
			mode = 'symbols',
			attach_switcher = attach_switcher,
			finder = finders.new_dynamic({
				fn = workspace_symbols,
				entry_maker = picker.workspace_entry,
			}),
		})
	end,
}
