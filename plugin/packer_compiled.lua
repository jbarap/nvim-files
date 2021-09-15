-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = true
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/john/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/john/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/john/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/john/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/john/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  LuaSnip = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/LuaSnip"
  },
  ["aerial.nvim"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/aerial.nvim"
  },
  ["barbar.nvim"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/barbar.nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/cmp-buffer"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp"
  },
  ["cmp-nvim-lua"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/cmp-nvim-lua"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/cmp-path"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/cmp_luasnip"
  },
  ["dashboard-nvim"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/dashboard-nvim"
  },
  ["diffview.nvim"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/diffview.nvim"
  },
  ["focus.nvim"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/focus.nvim"
  },
  ["gitsigns.nvim"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/gitsigns.nvim"
  },
  ["gv.vim"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/gv.vim"
  },
  ["impatient.nvim"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/impatient.nvim"
  },
  ["indent-blankline.nvim"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim"
  },
  ["jupyter-nvim"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/jupyter-nvim"
  },
  kommentary = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/kommentary"
  },
  ["lsp-trouble.nvim"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/lsp-trouble.nvim"
  },
  ["lspkind-nvim"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/lspkind-nvim"
  },
  ["lualine.nvim"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/lualine.nvim"
  },
  ["magma-nvim"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/magma-nvim"
  },
  ["markdown-preview.nvim"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/markdown-preview.nvim"
  },
  neogit = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/neogit"
  },
  ["neoscroll.nvim"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/neoscroll.nvim"
  },
  ["nightfox.nvim"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/nightfox.nvim"
  },
  ["null-ls.nvim"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/null-ls.nvim"
  },
  ["nvim-autopairs"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/nvim-autopairs"
  },
  ["nvim-bqf"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/nvim-bqf"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/nvim-cmp"
  },
  ["nvim-colorizer.lua"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua"
  },
  ["nvim-dap"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/nvim-dap"
  },
  ["nvim-dap-ui"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/nvim-dap-ui"
  },
  ["nvim-gps"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/nvim-gps"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-toggleterm.lua"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/nvim-toggleterm.lua"
  },
  ["nvim-tree.lua"] = {
    commands = { "NvimTreeToggle", "NvimTreeFindFile" },
    loaded = false,
    needs_bufread = false,
    path = "/home/john/.local/share/nvim/site/pack/packer/opt/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  playground = {
    commands = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
    loaded = false,
    needs_bufread = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/opt/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["project.nvim"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/project.nvim"
  },
  ["replacer.nvim"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/replacer.nvim"
  },
  ["targets.vim"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/targets.vim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["tmux.nvim"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/tmux.nvim"
  },
  ["tokyonight.nvim"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/tokyonight.nvim"
  },
  ["vim-arsync"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/vim-arsync"
  },
  ["vim-doge"] = {
    commands = { "DogeGenerate" },
    loaded = false,
    needs_bufread = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/opt/vim-doge"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/vim-fugitive"
  },
  ["vim-python-pep8-indent"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/vim-python-pep8-indent"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/vim-repeat"
  },
  ["vim-sleuth"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/vim-sleuth"
  },
  ["vim-subversive"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/vim-subversive"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/vim-surround"
  },
  ["vim-test"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/vim-test"
  },
  ["vim-ultest"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/vim-ultest"
  },
  ["which-key.nvim"] = {
    loaded = true,
    path = "/home/john/.local/share/nvim/site/pack/packer/start/which-key.nvim"
  }
}

time([[Defining packer_plugins]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file NvimTreeToggle lua require("packer.load")({'nvim-tree.lua'}, { cmd = "NvimTreeToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file NvimTreeFindFile lua require("packer.load")({'nvim-tree.lua'}, { cmd = "NvimTreeFindFile", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TSPlaygroundToggle lua require("packer.load")({'playground'}, { cmd = "TSPlaygroundToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TSHighlightCapturesUnderCursor lua require("packer.load")({'playground'}, { cmd = "TSHighlightCapturesUnderCursor", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file DogeGenerate lua require("packer.load")({'vim-doge'}, { cmd = "DogeGenerate", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

if should_profile then save_profiles(1) end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
