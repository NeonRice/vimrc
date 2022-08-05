local opt = vim.opt
local o = vim.o
local wo = vim.wo

function options()
   -- Case insensitive searching UNLESS /C or capital in search
  o.ignorecase = true
  o.smartcase = true

  -- Decrease update time
  o.updatetime = 250

  -- Tabs are 2 spaces
  opt.tabstop = 2
  opt.shiftwidth = 2
  opt.expandtab = true

  -- Numbering is relative
  -- opt.number = relativenumber

  -- TODO: Not sure about these
  -- Set highlight on search
  o.hlsearch = false

  -- Enable break indent
  o.breakindent = true

  -- Save undo history
  o.undofile = true

  -- nvim-cmp Documentation asked to set these
  opt.completeopt = {'menu', 'menuone', 'noselect'}
end

function window_options()
  -- Make line numbers default
  wo.number = true
end

function colorscheme()
  opt.background = 'light'
  opt.termguicolors = true -- Looks bad with dark mode
  vim.cmd [[colorscheme gruvbox]]
end

function settings()
  options()
  window_options()
  colorscheme()
end

settings()
