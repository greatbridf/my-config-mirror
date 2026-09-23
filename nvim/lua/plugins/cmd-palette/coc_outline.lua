local picker = require('plugins.cmd-palette.coc_symbol_picker')

return {
	prefix = '@',
	title = '  Coc Outline',
	open = function(query, attach_switcher, cfg)
		local bufnr = vim.api.nvim_get_current_buf()
		local ok, symbols = pcall(vim.fn.CocAction, 'documentSymbols', bufnr)
		if not ok or type(symbols) ~= 'table' then
			vim.notify('Coc could not provide document symbols for this buffer', vim.log.levels.WARN)
			return
		end
		if #symbols == 0 then
			vim.notify('Coc returned no document symbols for this buffer', vim.log.levels.INFO)
			return
		end

		local entries = {}
		for _, symbol in ipairs(symbols) do
			table.insert(entries, picker.document_entry(symbol))
		end
		picker.open({
			title = '  Coc Outline',
				query = query,
				cfg = cfg,
				mode = 'symbols',
				source_buf = bufnr,
				attach_switcher = attach_switcher,
				finder = require('telescope.finders').new_table({
					results = entries,
					-- Keep the prepared Telescope entry intact; the default table
					-- entry maker expects strings and drops/customizes table values.
					entry_maker = function(item) return item end,
				}),
			})
	end,
}
