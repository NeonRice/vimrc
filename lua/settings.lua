local opt = vim.opt
local o = vim.o
local wo = vim.wo
local g = vim.g

local function options()
  -- Case insensitive searching UNLESS /C or capital in search
  o.ignorecase = true
  o.smartcase = true

  -- Decrease update time
  o.updatetime = 250

  -- Tabs are 2 spaces
  opt.tabstop = 2
  opt.softtabstop = 2
  opt.shiftwidth = 2
  opt.expandtab = true

  -- Hide command line
  opt.cmdheight = 0

  -- Round indent to multiple of shiftwidth
  opt.shiftround = true

  -- Numbering is relative
  o.relativenumber = true

  -- TODO: Not sure about these
  -- Set highlight on search
  o.hlsearch = false

  -- Enable break indent
  o.breakindent = true

  -- Save undo history
  o.undofile = true

  -- Make popups transparent
  o.pumblend = 20

  -- Hightlight cursor line
  o.cursorline = true

  -- nvim-cmp Documentation asked to set these
  opt.completeopt = { 'menu', 'menuone', 'noselect' }
end

local function window_options()
  -- Make line numbers default
  wo.number = true
end

local function colorscheme()
  opt.background = 'light'
  opt.termguicolors = true -- Looks bad with dark mode
  g.gruvbox_material_diagnostic_virtual_text = 'colored'
  g.gruvbox_material_better_performance = 1
  vim.cmd [[colorscheme gruvbox-material]]
end

local function settings()
  options()
  window_options()
  colorscheme()
end

settings()
