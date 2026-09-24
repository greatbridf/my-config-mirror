return {
	dir = vim.fn.stdpath('config') .. '/local-plugins/gb-git/',
	ft = {
		'git', 'gitrebase', 'gitcommit',
	},
	opts = {
		keep = true,
	},
	config = true,
}
