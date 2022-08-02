function mappings()
  core() 
  -- Plugins
  telescope() 
end

function core()
  -- Set <space> as the leader key
  --  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  -- Keymaps for better default experience
  -- See `:help vim.keymap.set()`
  -- vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true }) TODO: ?

  -- Remap for dealing with word wrap TODO?
  -- vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
  -- vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

  -- Use ctrl-[hjkl] to select the active split!                                         
  vim.keymap.set('n', '<C-k>', '<CMD>wincmd k<CR>', {silent = true})
  vim.keymap.set('n', '<C-j>', '<CMD>wincmd j<CR>', {silent = true})
  vim.keymap.set('n', '<C-h>', '<CMD>wincmd h<CR>', {silent = true})
  vim.keymap.set('n', '<C-l>', '<CMD>wincmd l<CR>', {silent = true})

  vim.keymap.set('n', '<CR>', '<CMD>noh<CR><CR>', {silent = true, nnoremap = true})

  -- Copy (relative) file path with line TODO
  -- map <leader>l :let @*=fnamemodify(expand("%"), ":~:.") . ":" . line(".")<CR>

  -- To exit terminal-mode:                                                                                                                            
  --  tnoremap <leader>q <C-\><C-n>                                                                                                                                                                      
  --   To simulate i_CTRL-R in terminal-mode:
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
  local telescope = require('telescope.builtin')
  vim.keymap.set('n', '<leader>tf', telescope.find_files(), {silent=true})
--nnoremap <leader>tf <cmd>lua require('telescope.builtin').find_files()<cr>
--nnoremap <leader>tg <cmd>lua require('telescope.builtin').live_grep()<cr>
--nnoremap <leader>tb <cmd>lua require('telescope.builtin').buffers()<cr>
--nnoremap <leader>th <cmd>lua require('telescope.builtin').help_tags()<cr>
end
