return {
	prefix = '#',
	title = '  Find Files',
	open = function(query, attach_switcher)
		require('telescope.builtin').find_files({
			default_text = query,
			attach_mappings = function(prompt_bufnr, map)
				attach_switcher(prompt_bufnr, map)
				return true
			end,
		})
	end,
}
