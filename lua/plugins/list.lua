local fn = vim.fn

require('plugins.packer_compiled')

-- if Packer is not installed, download and install it
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path
  })
  vim.api.nvim_command("packadd packer.nvim")
end

local ok, packer = pcall(require, "packer")
if not ok then
  return
end

-- use float windows
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end
  }
})

-- util function for plugin configuration
local conf = function (plugin_name)
  return string.format("require('plugins.configs.%s')", plugin_name)
end

return packer.startup({
  function(use)
    -- Packer
    use("wbthomason/packer.nvim")

    -- Diverse tools
    use("nvim-lua/plenary.nvim")

    -- Improve performance
    use("lewis6991/impatient.nvim") -- until: https://github.com/neovim/neovim/pull/15436
    use({
      "monkoose/matchparen.nvim",
      config = conf("matchparen"),
    })

    -- Icons
    use("kyazdani42/nvim-web-devicons")

    -- Colors
    use({
      "norcalli/nvim-colorizer.lua",
      cmd = { "ColorizerToggle" },
    })
    use({
      "rebelot/kanagawa.nvim",
      after = "nvim-web-devicons",
      config = conf("colorschemes"),
    })

    -- LSP + diagnostics
    use("neovim/nvim-lspconfig")
    use({
      "jose-elias-alvarez/null-ls.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      rocks = { "luacheck" },
    })
    use({
      "stevearc/aerial.nvim",
      config = conf("aerial"),
    })
    use({
      "folke/trouble.nvim",
      cmd = "TroubleToggle",
      config = conf("trouble"),
      requires = "kyazdani42/nvim-web-devicons",
    })

    -- Autocompletion
    use({
      "hrsh7th/nvim-cmp",
      config = conf("nvim_cmp"),
    })
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-nvim-lua")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-path")

    -- Code icons
    use("onsails/lspkind-nvim")

    -- Snippet support
    use({
      "L3MON4D3/LuaSnip",
      config = conf("luasnip"),
    })
    use("saadparwaiz1/cmp_luasnip")

    -- Syntax
    use({
      "nvim-treesitter/nvim-treesitter",
      config = conf("treesitter"),
      run = ":TSUpdate",
    })
    use({
      "nvim-treesitter/nvim-treesitter-textobjects",
      requires = "nvim-treesitter/nvim-treesitter",
    })
    use({
      "nvim-treesitter/playground",
      cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
      opt = true,
    })

    -- Navigation
    use({
      "karb94/neoscroll.nvim",
      config = conf("neoscroll"),
    })
    use({
      "aserowy/tmux.nvim",
      config = conf("tmux"),
    })
    -- check: https://github.com/ggandor/lightspeed.nvim

    -- Fuzzy finding
    use({
      "nvim-telescope/telescope.nvim",
      cmd = "Telescope",
      config = conf("telescope"),
      module = "telescope",
      requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } },
    })
    use({
      "nvim-telescope/telescope-fzf-native.nvim",
      run = "make",
    })

    -- Tabs
    use({
      'akinsho/bufferline.nvim',
      config = conf("bufferline"),
      requires = 'kyazdani42/nvim-web-devicons',
    })

    -- Statusline
    use({
      "nvim-lualine/lualine.nvim",
      config = conf("lualine"),
      requires = { "kyazdani42/nvim-web-devicons", opt = true },
    })
    use({
      "SmiteshP/nvim-gps",
      requires = "nvim-treesitter/nvim-treesitter"
    })

    -- File tree
    use({
      "kyazdani42/nvim-tree.lua",
      config = conf("nvim_tree"),
    })

    -- Indent lines
    use({
      "lukas-reineke/indent-blankline.nvim",
      config = conf("indent_blankline"),
    })

    -- Commenting
    use({
      "numToStr/Comment.nvim",
      config = conf("comment"),
    })

    -- Autopairs
    use({
      "windwp/nvim-autopairs",
      config = conf("autopairs"),
    })

    -- Surround
    use("tpope/vim-surround")

    -- Substitution
    use("svermeulen/vim-subversive")

    -- Git
    use({
      "lewis6991/gitsigns.nvim",
      config = conf("gitsigns"),
    })
    use("tpope/vim-fugitive")
    use("tpope/vim-rhubarb")
    use({
      "junegunn/gv.vim",
      cmd = { "GV" },
    })
    -- check ThePrimeagen/git-worktree.nvim
    use({
      "TimUntersberger/neogit",
      config = conf("neogit"),
      requires = "nvim-lua/plenary.nvim",
    })

    -- Change cwd to project
    use({
      "ahmedkhalf/project.nvim",
      config = conf("project_nvim"),
    })

    -- Dashboard
    use({
      "glepnir/dashboard-nvim",
      config = conf("dashboard"),
    })

    -- Documentation generation
    use({
      "kkoomen/vim-doge",
      cmd = { "DogeGenerate" },
      config = conf("doge"),
      opt = true,
      run = ":call doge#install()",
    })

    -- Repeat
    use("tpope/vim-repeat")

    -- Targets
    use({
      "wellle/targets.vim",
      config = conf("targets"),
    })

    -- Debugging
    use({
      "mfussenegger/nvim-dap",
      config = conf("debug"),
    })
    use({
      "rcarriga/nvim-dap-ui",
      requires = { "mfussenegger/nvim-dap" },
    })

    -- Python
    use("Vimjas/vim-python-pep8-indent")
    use({
      "ahmedkhalf/jupyter-nvim",
      config = conf("jupyter"),
      run = ":UpdateRemotePlugins",
    })
    use({
      "dccsillag/magma-nvim",
      config = conf("magma"),
      run = ":UpdateRemotePlugins",
    })

    -- Markdown preview
    use({
      "iamcco/markdown-preview.nvim",
      config = conf("markdown_preview"),
      run = ":call mkdp#util#install()",
    })

    -- Tests
    use({
      "rcarriga/vim-ultest",
      config = conf("ultest"),
      requires = { "janko/vim-test" },
      run = ":UpdateRemotePlugins",
    })

    -- Diffview
    use({
      "sindrets/diffview.nvim",
      config = conf("diffview"),
    })

    -- Manage tab settings
    -- use("tpope/vim-sleuth")
    use({
      "Darazaki/indent-o-matic",
      config = conf("indent_o_matic"),
    })

    -- Which key
    use({
      "folke/which-key.nvim",
      config = conf("whichkey"),
    })

    -- Terminal
    use({
      "akinsho/nvim-toggleterm.lua",
      config = conf("toggleterm"),
    })

    -- Remote
    use({
      "kenn7/vim-arsync",
      cmd = { "ARshowConf", "ARsyncUp" },
    })
    -- check: https://github.com/chipsenkbeil/distant.nvim

    -- Quickfix
    use({
      "kevinhwang91/nvim-bqf",
      config = conf("bqf"),
    })
    use({
      "gabrielpoca/replacer.nvim",
      module = "replacer",
    })

    -- Startup time
    use({
      "dstein64/vim-startuptime",
      cmd = { "StartupTime" },
    })

    -- UI sugar
    use({
      'stevearc/dressing.nvim',
      config = conf("dressing"),
    })

    -- Refactoring
    -- use { "ThePrimeagen/refactoring.nvim",
    --   requires = {
    --     {"nvim-lua/plenary.nvim"},
    --     {"nvim-treesitter/nvim-treesitter"}
    --   }
    -- }

    if packer_bootstrap then
      require('packer').sync()
    end
  end,

  config = {
    compile_path = vim.fn.stdpath("config") .. "/lua/plugins/packer_compiled.lua",
    profile = {
      enable = true,
      threshold = 0.1,
    },
  },
})
