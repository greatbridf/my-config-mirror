local commands = {
	{
		cmd = ':CocCommand document.toggleInlayHint',
		label = 'Toggle Inlay Hints',
		desc = 'toggleinlayhint',
	},
}

local git_diff_command = {
	cmd = ':GreatbridfGitOpen vsplit',
	label = 'Split Commit Vertically',
	desc = 'Open the commit diff buffer in a vertical split',
	action = function()
		local ok, gb = pcall(require, 'gb-git')
		if ok then
			gb.open_last('vsplit')
		else
			vim.notify('No commit diff buffer to split', vim.log.levels.WARN)
		end
	end,
}

local git_filetypes = {
	git = true,
	gitrebase = true,
	gitcommit = true,
}

--- Commands available for the current buffer's filetype.
local function active_commands()
	local all = {}
	vim.list_extend(all, commands)
	if git_filetypes[vim.bo.filetype] then
		table.insert(all, git_diff_command)
	end
	return all
end

return {
	'tommyme/command-palette.nvim',
	dependencies = {
		'nvim-telescope/telescope.nvim',
		'nvim-lua/plenary.nvim',
	},
	keys = {
		{
			'<leader>o',
			function()
				local cp = require('command-palette')
				if cp._config then
					cp._config.commands = active_commands()
				end
				cp.open()
			end,
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
