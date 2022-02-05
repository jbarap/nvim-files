require("ultest").setup({
  builders = {
    ["python#pytest"] = function(cmd)
      -- The command can start with python command directly or an env manager
      local non_modules = { "python", "pipenv", "poetry" }
      -- Index of the python module to run the test.
      local module, module_index
      if vim.tbl_contains(non_modules, cmd[1]) then
        module_index = 3
      else
        module_index = 1
      end

      module = cmd[module_index]

      -- Remaining elements are arguments to the module
      local args = vim.list_slice(cmd, module_index + 1)
      return {
        dap = {
          type = "python_launch",
          request = "launch",
          module = module,
          args = args,
        },
      }
    end,
  },
})

vim.g.ultest_output_on_line = 0
vim.cmd("let test#python#runner = 'pytest'")
vim.cmd('let test#enabled_runners = ["python#pytest"]')
vim.cmd("nmap <Leader>tl <Plug>(ultest-output-jump)")

