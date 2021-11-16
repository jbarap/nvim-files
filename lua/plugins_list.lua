local fn = vim.fn

-- if Packer is not installed, download and install it
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path
  })
  vim.api.nvim_command("packadd packer.nvim")
end

local use = require("packer").use

return require("packer").startup({
  function()
    -- Packer
    use({ "wbthomason/packer.nvim" })

    -- Improve startup time until: https://github.com/neovim/neovim/pull/15436
    use("lewis6991/impatient.nvim")
    use("nathom/filetype.nvim")

    -- Diverse tools
    use("nvim-lua/plenary.nvim")

    -- Icons
    use("kyazdani42/nvim-web-devicons")

    -- Colors
    use({ "norcalli/nvim-colorizer.lua", cmd = { "ColorizerToggle" } })
    -- use 'folke/tokyonight.nvim'
    use("EdenEast/nightfox.nvim")

    -- LSP
    use("neovim/nvim-lspconfig")
    use({
      "folke/trouble.nvim",
      requires = "kyazdani42/nvim-web-devicons",
      config = function() require("trouble").setup({}) end,
      cmd = "TroubleToggle",
    })
    use({
      "jose-elias-alvarez/null-ls.nvim",
      requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
      rocks = {"luacheck"},
    })
    use("stevearc/aerial.nvim")

    -- Autocompletion
    use("hrsh7th/nvim-cmp")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-nvim-lua")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-path")
    -- use 'hrsh7th/cmp-cmdline'

    -- Code icons
    use("onsails/lspkind-nvim")

    -- Snippet support
    use("L3MON4D3/LuaSnip")
    use("saadparwaiz1/cmp_luasnip")

    -- Syntax
    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
    use({ "nvim-treesitter/nvim-treesitter-textobjects", requires = "nvim-treesitter/nvim-treesitter" })
    use({ "nvim-treesitter/playground", opt = true, cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" } })

    -- Navigation
    use("karb94/neoscroll.nvim")
    -- check: https://github.com/ThePrimeagen/harpoon

    -- Fuzzy finding
    use({
      "nvim-telescope/telescope.nvim",
      requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } },
      cmd = "Telescope",
      module = "telescope",
      config = function () require("plugins_config.telescope") end,
    })
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

    -- Tabs
    use("romgrk/barbar.nvim")

    -- Statusline
    use({ "nvim-lualine/lualine.nvim", requires = { "kyazdani42/nvim-web-devicons", opt = true } })
    use({ "SmiteshP/nvim-gps", requires = "nvim-treesitter/nvim-treesitter" })

    -- File tree
    use("kyazdani42/nvim-tree.lua")

    -- Indent lines
    use("lukas-reineke/indent-blankline.nvim")

    -- Commenting
    use("numToStr/Comment.nvim")

    -- Autopairs
    use("windwp/nvim-autopairs")

    -- Surround
    use("tpope/vim-surround")

    -- Substitution
    use("svermeulen/vim-subversive")

    -- Tmux navigation
    use({ "aserowy/tmux.nvim", disable = false })

    -- Git
    use("lewis6991/gitsigns.nvim")
    use("tpope/vim-fugitive")
    use("tpope/vim-rhubarb")
    use({ "junegunn/gv.vim", cmd = { "GV" } })
    use({ "TimUntersberger/neogit", requires = "nvim-lua/plenary.nvim" })

    -- Change cwd to project
    use("ahmedkhalf/project.nvim")

    -- Dashboard
    use("glepnir/dashboard-nvim")
    -- check: https://github.com/goolord/alpha-nvim it's slower due to VimEnter atm

    -- Documentation generation
    use({ "kkoomen/vim-doge", run = ":call doge#install()", opt = true, cmd = { "DogeGenerate" } })

    -- Repeat
    use("tpope/vim-repeat")

    -- Targets
    use("wellle/targets.vim")

    -- Debugging
    use("mfussenegger/nvim-dap")
    use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })

    -- Python
    use("Vimjas/vim-python-pep8-indent")
    use({ "ahmedkhalf/jupyter-nvim", run = ":UpdateRemotePlugins" })
    use({ "dccsillag/magma-nvim", run = ":UpdateRemotePlugins" })

    -- Markdown preview
    use({ "iamcco/markdown-preview.nvim", run = ":call mkdp#util#install()" })

    -- Tests
    use({ "rcarriga/vim-ultest", requires = { "janko/vim-test" }, run = ":UpdateRemotePlugins" })

    -- Diffview
    use("sindrets/diffview.nvim")

    -- Manage tab settings
    use("tpope/vim-sleuth")

    -- Which key
    use("folke/which-key.nvim")

    -- Terminal
    use("akinsho/nvim-toggleterm.lua")

    -- Remote
    use({ "kenn7/vim-arsync", cmd = { "ARshowConf", "ARsyncUp" } })
    -- check: https://github.com/chipsenkbeil/distant.nvim

    -- Quickfix
    use("kevinhwang91/nvim-bqf")
    use({ "gabrielpoca/replacer.nvim", module = "replacer" })

    -- Startup time
    use({ "dstein64/vim-startuptime", cmd = { "StartupTime" } })

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
    profile = {
      enable = true,
      threshold = 0.1,
    },
  },
})
