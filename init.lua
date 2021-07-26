local cmd = vim.cmd

-- Set mapleader to space
vim.g.mapleader = ' '

-- Add commands for reload and restart
cmd('command! Reload lua require("utils").Reload()')
cmd('command! Restart lua require("utils").Restart()')

-- General Settings
require('settings')

-- Load plugins
require('plugins_list')

-- Load keybinds
require('keybinds')

-- Load configuration
require('plugins_config')

vim.g.python3_host_prog = "/home/john/.pyenv/versions/nvim-env/bin/python3"

