vim.o.background = vim.env.SYSTEM_APPEARANCE or 'dark'

-- Set leader keys first
vim.g.mapleader = ','
vim.g.maplocalleader = ' '

-- Load other config modules
require('config.options')
require('config.lazy')
require('config.keymaps')
require('config.autocmds')
