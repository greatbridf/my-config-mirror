local commands = {
	{
		cmd = ':CocCommand document.toggleInlayHint',
		label = 'Toggle Inlay Hints',
		desc = 'toggleinlayhint',
	},
}

return {
	'tommyme/command-palette.nvim',
	dependencies = {
		'nvim-telescope/telescope.nvim',
		'nvim-lua/plenary.nvim',
	},
	keys = {
		{
			'<leader>o',
			function() require('command-palette').open() end,
			desc = 'Open Command Palette',
		}
	},
	opts = {
		keymap = false,
		commands = commands,
	},
	config = function(_, opts)
		local palette = require('command-palette')
		palette.setup(opts)
		palette.register_mode('symbols', require('plugins.cmd-palette.coc_outline'))
		palette.register_mode('global_symbols', require('plugins.cmd-palette.coc_global_symbols'))
		palette.register_mode('file_fuzzy', require('plugins.cmd-palette.file_fuzzy'))
	end,
}
