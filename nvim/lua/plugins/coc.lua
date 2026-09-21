return {
	'neoclide/coc.nvim', branch = 'release',
	lazy = false,
	keys = {
		{
			'<leader>o',
			function() vim.cmd.CocList('outline') end,
			desc = 'Local Symbol Lookup',
		},
		{
			'<leader>s',
			function() vim.cmd.CocList({'-I', 'symbols'}) end,
			desc = 'Global Symbol Lookup',
		},
	},
}
