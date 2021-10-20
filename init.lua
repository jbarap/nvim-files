-- Set mapleader to space
vim.g.mapleader = " "

-- setup 'require' improvements
require('impatient')

-- General Settings
require("settings")

-- Load plugins
require("plugins_list")

-- Load keybinds
require("keybinds")

-- Load configuration
require("plugins_config")

vim.g.python3_host_prog = "/home/john/.pyenv/versions/nvim-env/bin/python3"
