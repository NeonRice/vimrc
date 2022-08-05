local silent = { silent = true }
local map = vim.keymap.set
local g = vim.g

function mappings()
  core()
  -- Plugins
  telescope()
  LSP()
end

function core()
  -- Set <space> as the leader key
  --  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
  g.mapleader = ' '
  g.maplocalleader = ' '

  -- Keymaps for better default experience
  -- See `:help vim.keymap.set()`
  -- vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true }) TODO: ?

  -- Remap for dealing with word wrap TODO?
  -- vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
  -- vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

  -- Use ctrl-[hjkl] to select the active split!                                         
  map('n', '<C-k>', '<CMD>wincmd k<CR>', {silent = true})
  map('n', '<C-j>', '<CMD>wincmd j<CR>', {silent = true})
  map('n', '<C-h>', '<CMD>wincmd h<CR>', {silent = true})
  map('n', '<C-l>', '<CMD>wincmd l<CR>', {silent = true})

  map('n', '<CR>', '<CMD>noh<CR><CR>', {silent = true})

  -- Copy (relative) file path with line TODO
  -- map <leader>l :let @*=fnamemodify(expand("%"), ":~:.") . ":" . line(".")<CR>

  -- map('t', '<leader>q', '<C-\><C-n>')
  -- To exit terminal-mode:                                                                                                                            
  --  tnoremap <leader>q <C-\><C-n>                                                                                                                                                                      
  --   To simulate i_CTRL-R in terminal-mode: TODO
  --  tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'                                                                                                                                    
  --  TODO: Move to relevent places
  -- To use CTRL+{h,j,k,l} to navigate windows from any mode:
  --tnoremap <C-h> <C-\><C-N><C-w>h
  --tnoremap <C-j> <C-\><C-N><C-w>j
  --tnoremap <C-k> <C-\><C-N><C-w>k
  --tnoremap <C-l> <C-\><C-N><C-w>l
  --inoremap <C-h> <C-\><C-N><C-w>h
  --inoremap <C-j> <C-\><C-N><C-w>j
  --inoremap <C-k> <C-\><C-N><C-w>k
  --inoremap <C-l> <C-\><C-N><C-w>l
end

function telescope()
  map('n', '<leader>tf', '<cmd>Telescope find_files <cr>', silent)
  -- Navigate buffers and repos
  map('n', '<leader>tb', [[<cmd>Telescope buffers show_all_buffers=true theme=get_dropdown<cr>]], silent)
  -- map('n', '<leader>tr', [[<cmd>Telescope frecency theme=get_dropdown<cr>]], silent)
  map('n', '<leader>tg', [[<cmd>Telescope git_files theme=get_dropdown<cr>]], silent)
  map('n', '<leader>ts', [[<cmd>Telescope live_grep theme=get_dropdown<cr>]], silent)
  map('n', '<leader>th', [[<cmd>Telescope help_tags theme=get_dropdown<cr>]], silent)
end

function LSP()
  vim.api.nvim_create_autocmd('User', {
    pattern = 'LspAttached',
    desc = 'LSP actions',
    callback = function()
      local bufmap = function(mode, lhs, rhs)
        local opts = {buffer = true}
        map(mode, lhs, rhs, opts)
      end

      -- Displays hover information about the symbol under the cursor
      bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

      -- Jump to the definition
      bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')

      -- Jump to declaration
      bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')

      -- Lists all the implementations for the symbol under the cursor
      bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')

      -- Jumps to the definition of the type symbol
      bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')

      -- Lists all the references 
      bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')

      -- Displays a function's signature information TODO?
      --bufmap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

      -- Renames all references to the symbol under the cursor
      bufmap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>')

      -- Selects a code action available at the current cursor position
      bufmap('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<cr>')
      bufmap('x', '<leader>a', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')

      -- Show diagnostics in a floating window
      bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')

      -- Move to the previous diagnostic
      bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')

      -- Move to the next diagnostic
      bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
    end
  })
end


mappings()
