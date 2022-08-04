local fn = vim.fn

-- if Packer is not installed, download and install it
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
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
    end,
  },
})

-- util function for plugin configuration
local conf = function(plugin_name)
  return string.format("require('plugins.configs.%s')", plugin_name)
end

packer.startup({
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

    use({
      "kevinhwang91/nvim-ufo",
      requires = {
        {"kevinhwang91/promise-async", keys = { "za" }, module = "ufo" }
      },
      config = conf("nvim_ufo"),
      after = "promise-async",
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
      cmd = "AerialToggle",
      module = "aerial",
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
      "akinsho/bufferline.nvim",
      config = conf("bufferline"),
      requires = "kyazdani42/nvim-web-devicons",
    })

    -- Statusline
    use({
      "nvim-lualine/lualine.nvim",
      config = conf("lualine"),
      requires = { "kyazdani42/nvim-web-devicons", opt = true },
    })
    use({
      "SmiteshP/nvim-navic",
      requires = "neovim/nvim-lspconfig",
    })

    -- File tree
    use({
      "nvim-neo-tree/neo-tree.nvim",
      cmd = "Neotree",
      config = conf("neo_tree"),
      requires = {
        "nvim-lua/plenary.nvim",
        "kyazdani42/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      },
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
    use({
      "kylechui/nvim-surround",
      config = conf("surround"),
    })

    -- Substitution
    use("svermeulen/vim-subversive")

    -- Git integration
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
    -- check: https://github.com/ipod825/igit.nvim
    -- use({
    --   "TimUntersberger/neogit",
    --   config = conf("neogit"),
    --   module = "neogit",
    --   cmd = "Neogit",
    --   requires = "nvim-lua/plenary.nvim",
    -- })
    use({
      "akinsho/git-conflict.nvim",
      config = conf("git_conflict"),
      cmd = "GitConflictListQf",
      commit = "c3230fd0322b3d8e47b85478251f83d4587bdca5",
      -- broken by: 8b7ce8839e2aaa847d2d2f2dca0e8e2f62f1d356
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
      "danymat/neogen",
      config = conf("neogen"),
      module = "neogen",
      requires = "nvim-treesitter/nvim-treesitter",
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
      module = "dap",
    })
    use({
      "rcarriga/nvim-dap-ui",
      module = "dapui",
      requires = { "mfussenegger/nvim-dap" },
    })

    -- Python
    use("Vimjas/vim-python-pep8-indent")
    -- check ahmedkhalf/jupyter-nvim
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
    use {
      "rcarriga/neotest",
      requires = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-treesitter/nvim-treesitter" },
        { "antoinemadec/FixCursorHold.nvim", module = "neotest" },
        { "rcarriga/neotest-python", after = "FixCursorHold.nvim" },
      },
      after = { "neotest-python"},
      config = conf("neotest"),
    }

    -- Diffview
    use({
      "sindrets/diffview.nvim",
      cmd = { "DiffviewOpen", "DiffviewFileHistory" },
      config = conf("diffview"),
    })

    -- Manage tab settings
    -- use({
    --   "Darazaki/indent-o-matic",
    --   config = conf("indent_o_matic"),
    -- })
    use({
      "NMAC427/guess-indent.nvim",
      config = conf("guess_indent"),
    })
    -- check: https://github.com/NMAC427/guess-indent.nvim

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
      cmd = { "ARshowConf", "ARsyncUp", "ARsyncDown" },
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
      "stevearc/dressing.nvim",
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
      require("packer").sync()
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

require("plugins.packer_compiled")
