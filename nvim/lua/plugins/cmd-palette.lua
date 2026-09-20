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
			'<leader>p',
			function() require('command-palette').open() end,
			desc = 'Open Command Palette',
		}
	},
	opts = {
		keymap = false,
		commands = commands,
	},
	config = function(_, opts)
		require('command-palette').setup(opts)
	end,
}
