require('guess-indent').setup({})

vim.api.nvim_exec([[ autocmd BufReadPost * :silent GuessIndent ]], false)
