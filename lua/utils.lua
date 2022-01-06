local M = {}

--          autogroups
-- ──────────────────────────────

function M.create_augroup(name, autocmds)
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
    if value["quickfix"] == 1 then
      quickfix_open = true
    end
  end

  if quickfix_open then
    vim.cmd("cclose")
  else
    vim.cmd("copen")
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
  if print_output then
    print("\r\n", out)
  end
  return true
end

M.sudo_write = function(tmpfile, filepath)
  if not tmpfile then
    tmpfile = vim.fn.tempname()
  end
  if not filepath then
    filepath = vim.fn.expand("%")
  end
  if not filepath or #filepath == 0 then
    vim.notify("E32: No file name")
    return
  end
  -- `bs=1048576` is equivalent to `bs=1M` for GNU dd or `bs=1m` for BSD dd
  -- Both `bs=1M` and `bs=1m` are non-POSIX
  -- stylua: ignore
  local cmd = string.format(
    "dd if=%s of=%s bs=1048576",
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

M.search_word = function()
  vim.cmd([[let @/='\<]] .. vim.fn.expand("<cword>") .. [[\>']])
  vim.o["hlsearch"] = true
end

--            files
-- ──────────────────────────────

-- Get a python executable within a virtualenv
M.get_python_executable = function(bin_name)
  local result = bin_name
  if os.getenv("VIRTUAL_ENV") then
    local venv_bin_name = os.getenv("VIRTUAL_ENV") .. "/bin/" .. bin_name
    if vim.fn.executable(venv_bin_name) == 1 then
      result = venv_bin_name
    end
  end
  return result
end


--            keybinds
-- ──────────────────────────────

-- Wrapper around vim.api.nvim_set_keymap with default options
-- The default options are: { noremap = true, silent = true }
-- Any options passed as the fourth argument will override them
---@param modes string | table #mode(s) under which this keymap applies.
---@param lhs string #left hand side of the mapping.
---@param rhs string #right hand side of the mapping.
---@param opts table #additional options.
M.set_keybind = function (modes, lhs, rhs, opts)
  if type(modes) == "string" then
    modes = { modes }
  end

  opts = opts or {}
  opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts)

  for _, m in ipairs(modes) do
    vim.api.nvim_set_keymap(m, lhs, rhs, opts)
  end
end

--       highlight interface
-- ──────────────────────────────

local Highlight = {
  id = 0,
  name = "",
  highlights = {
    cterm = "NONE",
    ctermfg = "NONE",
    ctermbg = "NONE",
    gui = "NONE",
    guifg = "NONE",
    guibg = "NONE",
  },
  attributes = {
    "bold",
    "italic",
    "reverse", -- same as inverse
    "inverse",
    "standout",
    "underline",
    "undercurl",
    "strikethrough",
  },
}

function Highlight:_init(create_if_missing)
  if create_if_missing then
    self.id = vim.api.nvim_get_hl_id_by_name(self.name)
  else
    self.id = vim.fn.hlID(self.name)
  end

  if self.id == 0 then
    vim.notify(string.format("Highlight '%s' not defined", self.name), vim.log.levels.WARN)
  end

  self.id = vim.fn.synIDtrans(self.id)

  self.highlights = {}
  for hl_name, _ in pairs(M.Highlight.highlights) do
    local hl = self:_get_highlight(hl_name)
    if hl == "" then
      hl = "NONE"
    end
    self.highlights[hl_name] = hl
  end

  return self
end

function Highlight:_get_highlight(hl_name)
  hl_name = string.lower(hl_name)

  local highlight_value = ""
  local hl_type = string.match(hl_name, "gui") or string.match(hl_name, "cterm")

  if not hl_type then
    vim.notify(string.format("Highlight option %s not supported", hl_type), vim.log.levels.WARN)
  end

  hl_name = string.gsub(hl_name, hl_type, "")
  if hl_name ~= "" then
    -- fg/bg/sp highlights
    highlight_value = vim.fn.synIDattr(self.id, hl_name, hl_type)
  else
    -- attributes
    local attrs = {}
    for _, attr_name in ipairs(self.attributes) do
      if vim.fn.synIDattr(self.id, attr_name, hl_type) == "1" then
        table.insert(attrs, attr_name)
      end
    end

    highlight_value = table.concat(attrs, ",") or highlight_value
  end

  return highlight_value
end

function Highlight:_update()
  if self.id == 0 then
    return self
  end

  local formatted_hl = string.format("hi %s", self.name)
  for hl_name, hl_value in pairs(self.highlights) do
    formatted_hl = string.format("%s %s=%s", formatted_hl, hl_name, hl_value)
  end
  vim.cmd(formatted_hl)
end

function Highlight:new(name, create_if_missing)
  local obj = { name = name }
  setmetatable(obj, self)
  self.__index = self
  obj:_init(create_if_missing)
  return obj
end

function Highlight:set(hl_name, value)
  self.highlights[hl_name] = value
  self:_update()
  return self
end

function Highlight:clear()
  self.highlights = M.Highlight.highlights
  self:_update()
end

setmetatable(Highlight, {
  __call = function(self, ...)
    return self:new(...)
  end,
})

M.Highlight = Highlight

return M
