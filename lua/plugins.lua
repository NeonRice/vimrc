-- Install packer
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

-- stylua: ignore start
require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'
  --use 'tpope/vim-fugitive'                                                        -- Git commands in nvim
  --use 'tpope/vim-rhubarb'                                                         -- Fugitive-companion to interact with github
  --use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }       -- Add git related info in the signs columns and popups
  --use 'numToStr/Comment.nvim'                                                     -- "gc" to comment visual regions/lines

  -- Highlight, edit, and navigate code TODO: do :TSUpdate?
  use { 'nvim-treesitter/nvim-treesitter',
    config = [[require("plugins/nvim-treesitter")]],
  }
  -- Additional textobjects for treesitter
  use 'nvim-treesitter/nvim-treesitter-textobjects'

  -- Collection of configurations for built-in LSP client
  use { 'neovim/nvim-lspconfig',
    config = [[require("plugins/nvim-lspconfig")]],
  }

  -- Automatically install language servers to stdpath
  use { 'williamboman/mason.nvim',
    -- Helper wrappers for LSP (LspInstall)
    requires = { 'williamboman/mason-lspconfig.nvim' },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup()
    end,
  }

  -- Autocompletion engine 
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'L3MON4D3/LuaSnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' },
      { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp-document-symbol', after = 'nvim-cmp' },
      --'lukas-reineke/cmp-under-comparator',
    },
    config = [[require("plugins/nvim-cmp")]],
    event = 'InsertEnter *',
  }

  -- Awesome motion plugin
  use { 'ggandor/lightspeed.nvim' }

  -- Best theme ever
  use 'morhetz/gruvbox'

  -- Fancier statusline
  use { 'nvim-lualine/lualine.nvim',
    config = [[require("plugins/lualine")]],
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
  }

  --use 'lukas-reineke/indent-blankline.nvim'                                       -- Add indentation guides even on blank lines
  --use 'tpope/vim-sleuth'                                                          -- Detect tabstop and shiftwidth automatically

  -- Dot repeat for plugins
  use { 'tpope/vim-repeat' }

  -- Fuzzy Finder (files, lsp, etc)
  use {
    {
      'nvim-telescope/telescope.nvim',
      requires = {
        --'nvim-lua/popup.nvim',
        'nvim-lua/plenary.nvim',
        --'telescope-frecency.nvim',
        'telescope-fzf-native.nvim',
        --'nvim-telescope/telescope-ui-select.nvim',
      },
      wants = {
        --'popup.nvim',
        'plenary.nvim',
        --'telescope-frecency.nvim',
        'telescope-fzf-native.nvim',
      },
      --setup = [[require('config.telescope_setup')]],
      config = [[require('plugins/telescope')]],
      cmd = 'Telescope',
      module = 'telescope',
    },
    --{
    --  'nvim-telescope/telescope-frecency.nvim',
    --  after = 'telescope.nvim',
    --  requires = 'tami5/sqlite.lua',
    --},
    -- Fuzzy Finder Algorithm which requires local dependencies
    -- to be built. Only load if `make` is available
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      cond = vim.fn.executable "make" == 1,
      run = 'make',
    },
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
-- stylua: ignore end

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if packer_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | PackerCompile',
  group = packer_group,
  pattern = 'plugins.lua',
})
