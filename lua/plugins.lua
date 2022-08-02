-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
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
    config = function()
      require("plugins/nvim-treesitter")
    end,
  }
  -- Additional textobjects for treesitter
  use 'nvim-treesitter/nvim-treesitter-textobjects'                               
  -- Collection of configurations for built-in LSP client
  use { 'neovim/nvim-lspconfig',                                                  
    config = function()
      require("plugins/nvim-lspconfig")
    end,
  }                                                     
  -- Automatically install language servers to stdpath
  use 'williamboman/nvim-lsp-installer'
  -- Autocompletion engine 
  use { 'hrsh7th/nvim-cmp', 
    requires = { 'hrsh7th/cmp-nvim-lsp' },
    config = function()
      require("plugins/nvim-cmp")
    end
  }               
  --use { 'L3MON4D3/LuaSnip', requires = { 'saadparwaiz1/cmp_luasnip' } }           -- Snippet Engine and Snippet Expansion
  -- Awesome motion plugin
  use { 'ggandor/lightspeed.nvim' }                                               
  -- Icons
  use 'kyazdani42/nvim-web-devicons'                                              
  -- Best theme ever
  use 'morhetz/gruvbox'                                                           
  -- Fancier statusline
  use 'nvim-lualine/lualine.nvim'                                                 
  --use 'lukas-reineke/indent-blankline.nvim'                                       -- Add indentation guides even on blank lines
  --use 'tpope/vim-sleuth'                                                          -- Detect tabstop and shiftwidth automatically
  -- Dot repeat for plugins
  use { 'tpope/vim-repeat' }                                                      
  -- Fuzzy Finder (files, lsp, etc)
  use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } } 

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable "make" == 1 }

  if is_bootstrap then
    require('packer').sync()
  end
end)
-- stylua: ignore end

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
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
  pattern = vim.fn.expand '$MYVIMRC',
})
