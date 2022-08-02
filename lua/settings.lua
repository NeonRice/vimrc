local opt = vim.opt
local g = vim.g

settings()

function settings()
  options() 
  window_options()
  colorscheme()
end

function options()
   -- Case insensitive searching UNLESS /C or capital in search
  vim.o.ignorecase = true
  vim.o.smartcase = true 

  -- Decrease update time
  vim.o.updatetime = 250

  -- Tabs are 2 spaces
  opt.tabstop = 2
  opt.shiftwidth = 2
  opt.expandtab = true
  
  -- Numbering is relative
  -- opt.number = relativenumber

  -- TODO: Not sure about these
  -- Set highlight on search
  vim.o.hlsearch = false

  -- Enable break indent
  vim.o.breakindent = true

  -- Save undo history
  vim.o.undofile = true
end

function window_options()
  -- Make line numbers default
  vim.wo.number = true
end

function colorscheme()
  opt.background = 'light'
  opt.termguicolors = true -- Looks bad with dark mode
  vim.cmd [[colorscheme gruvbox]]
end
