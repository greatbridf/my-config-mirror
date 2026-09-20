local confpath = vim.fn.stdpath('config')

require('config.lazy')
require('config.edit')
require('config.pretty')

vim.cmd('source ' .. confpath .. '/compat.vim')
