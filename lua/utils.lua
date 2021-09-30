local M = {}

local types = { o = vim.o, b = vim.bo, w = vim.wo }


--       reload functions
-- ──────────────────────────────
function M.UnloadAllModules()
  -- Lua patterns for the modules to unload
  local unload_modules = {
    "^utils$",
    "^settings$",
    "^plugins_list$",
    "^keybinds$",
    "^plugins_config$",
  }

  for k, _ in pairs(package.loaded) do
    for _, v in ipairs(unload_modules) do
      if k:match(v) then
        package.loaded[k] = nil
        break
      end
    end
  end
end

-- Reload Vim configuration
function M.Reload()
  vim.cmd("lua vim.lsp.stop_client(vim.lsp.get_active_clients())")

  M.UnloadAllModules()

  -- Source init.lua
  vim.cmd("luafile $MYVIMRC")
end

-- Restart Vim without having to close and run again
function M.Restart()
  M.Reload()

  -- Manually run VimEnter autocmd to emulate a new run of Vim
  vim.cmd("doautocmd VimEnter")
end


--        options utils
-- ──────────────────────────────
function M.get_opt(type, name)
  return types[type][name]
end

-- Set option
function M.set_opt(type, name, value)
  types[type][name] = value

  if type ~= "o" then
    types["o"][name] = value
  end
end

-- Append option to a list of options
function M.append_opt(type, name, value)
  local current_value = M.get_opt(type, name)

  if not string.match(current_value, value) then
    M.set_opt(type, name, current_value .. value)
  end
end

-- Remove option from a list of options
function M.remove_opt(type, name, value)
  local current_value = M.get_opt(type, name)

  if string.match(current_value, value) then
    M.set_opt(type, name, string.gsub(current_value, value, ""))
  end
end


--          autogroups
-- ──────────────────────────────
function M.create_augroup(autocmds, name)
  vim.cmd("augroup " .. name)
  vim.cmd("autocmd!")

  for _, autocmd in ipairs(autocmds) do
    vim.cmd("autocmd " .. table.concat(autocmd, " "))
  end

  vim.cmd("augroup END")
end


--          togglers
-- ──────────────────────────────
-- Toggle the quickfix list
function M.toggle_quickfix()
  local windows = vim.fn.getwininfo()
  local quickfix_open = false

  for _, value in pairs(windows) do
    if value['quickfix'] == 1 then
      quickfix_open = true
    end
  end

  if quickfix_open then
    vim.cmd('cclose')
  else
    vim.cmd('copen')
  end

end


--           sudo
-- ──────────────────────────────
-- Use sudo to execute commands and write files
-- from: https://github.com/ibhagwan/nvim-lua/blob/main/lua/utils.lua#L280
M.sudo_exec = function(cmd, print_output)
  local password = vim.fn.inputsecret("Password: ")
  if not password or #password == 0 then
      vim.notify("Invalid password, sudo aborted")
      return false
  end
  local out = vim.fn.system(string.format("sudo -p '' -S %s", cmd), password)
  if vim.v.shell_error ~= 0 then
    print("\r\n")
    vim.notify(out)
    return false
  end
  if print_output then print("\r\n", out) end
  return true
end

M.sudo_write = function(tmpfile, filepath)
  if not tmpfile then tmpfile = vim.fn.tempname() end
  if not filepath then filepath = vim.fn.expand("%") end
  if not filepath or #filepath == 0 then
    vim.notify("E32: No file name")
    return
  end
  -- `bs=1048576` is equivalent to `bs=1M` for GNU dd or `bs=1m` for BSD dd
  -- Both `bs=1M` and `bs=1m` are non-POSIX
  local cmd = string.format("dd if=%s of=%s bs=1048576",
    vim.fn.shellescape(tmpfile),
    vim.fn.shellescape(filepath))
  -- no need to check error as this fails the entire function
  vim.api.nvim_exec(string.format("write! %s", tmpfile), true)
  if M.sudo_exec(cmd) then
    vim.notify(string.format('\r\n"%s" written', filepath))
    vim.cmd("e!")
  end
  vim.fn.delete(tmpfile)
end


--           search
-- ──────────────────────────────
M.search_word = function ()
  vim.cmd([[let @/='\<]] .. vim.fn.expand("<cword>") .. [[\>']])
  M.set_opt("o", "hlsearch", true)
end


--            files
-- ──────────────────────────────
-- Get a python executable within a virtualenv
M.get_python_executable = function(bin_name)
  local result = bin_name
  if os.getenv('VIRTUAL_ENV') then
    local venv_bin_name = os.getenv('VIRTUAL_ENV') .. '/bin/' .. bin_name
    if vim.fn.executable(venv_bin_name) == 1 then
      result = venv_bin_name
    end
  end
  return result
end


return M
