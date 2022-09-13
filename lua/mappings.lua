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
  map('n', '<C-k>', '<CMD>wincmd k<CR>', { silent = true })
  map('n', '<C-j>', '<CMD>wincmd j<CR>', { silent = true })
  map('n', '<C-h>', '<CMD>wincmd h<CR>', { silent = true })
  map('n', '<C-l>', '<CMD>wincmd l<CR>', { silent = true })

  map('n', '<CR>', '<CMD>noh<CR><CR>', { silent = true })

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
  map('n', '<leader>tm', [[<cmd>Telescope marks theme=get_dropdown<cr>]], silent)
  map('n', '<leader>t/', [[<cmd>Telescope current_buffer_fuzzy_find theme=get_dropdown<cr>]], silent)
  map('n', '<leader>t"', [[<cmd>Telescope spell_suggest theme=get_dropdown<cr>]], silent)
  map('n', '<leader>tt', [[<cmd>Telescope treesitter theme=get_dropdown<cr>]], silent)
  -- TODO: Not sure if I need these
  map('n', '<leader>tld', [[<cmd>Telescope lsp_definitions theme=get_dropdown<cr>]], silent)
  map('n', '<leader>tli', [[<cmd>Telescope lsp_implementations theme=get_dropdown<cr>]], silent)
  map('n', '<leader>tlr', [[<cmd>Telescope lsp_references theme=get_dropdown<cr>]], silent)
  map('n', '<leader>tls', [[<cmd>Telescope lsp_document_symbols theme=get_dropdown<cr>]], silent)
  -- TODO: Dynamic for performance?
  map('n', '<leader>tlws', [[<cmd>Telescope lsp_dynamic_workspace_symbols theme=get_dropdown<cr>]], silent)
  map('n', '<leader>tlD', [[<cmd>Telescope diagnostics theme=get_dropdown<cr>]], silent)
  map('n', '<leader>tlci', [[<cmd>Telescope lsp_incoming_calls theme=get_dropdown<cr>]], silent)
  map('n', '<leader>tlco', [[<cmd>Telescope lsp_outgoing_calls theme=get_dropdown<cr>]], silent)

  -- TODO: (Currently in Telescope config)
  -- ['<c-d>'] = require('telescope.actions').delete_buffer

end

function LSP()
  vim.api.nvim_create_autocmd('User', {
    pattern = 'LspAttached',
    desc = 'LSP actions',
    callback = function()
      local bufmap = function(mode, lhs, rhs)
        local opts = { buffer = true }
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
      bufmap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

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

      -- Workspace actions
      bufmap('n', '<space>wa', vim.lsp.buf.add_workspace_folder)
      bufmap('n', '<space>wr', vim.lsp.buf.remove_workspace_folder)
      bufmap('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end)

      -- Format
      bufmap('n', '<space>f', vim.lsp.buf.formatting)
    end
  })
end

function gitsigns(bufnr)
  local gs = package.loaded.gitsigns

  -- TODO: Standardize..
  local function bufmap(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, l, r, opts)
  end

  -- Navigation
  bufmap('n', ']c', function()
    if vim.wo.diff then return ']c' end
    vim.schedule(function() gs.next_hunk() end)
    return '<Ignore>'
  end, {expr=true})

  bufmap('n', '[c', function()
    if vim.wo.diff then return '[c' end
    vim.schedule(function() gs.prev_hunk() end)
    return '<Ignore>'
  end, {expr=true})

  -- Actions
  bufmap({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
  bufmap({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
  bufmap('n', '<leader>hS', gs.stage_buffer)
  bufmap('n', '<leader>hu', gs.undo_stage_hunk)
  bufmap('n', '<leader>hR', gs.reset_buffer)
  bufmap('n', '<leader>hp', gs.preview_hunk)
  bufmap('n', '<leader>hb', function() gs.blame_line{full=true} end)
  bufmap('n', '<leader>bt', gs.toggle_current_line_blame)
  bufmap('n', '<leader>hd', gs.diffthis)
  bufmap('n', '<leader>hD', function() gs.diffthis('~') end)
  bufmap('n', '<leader>td', gs.toggle_deleted)

  -- Text object
  bufmap({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
end

mappings()
