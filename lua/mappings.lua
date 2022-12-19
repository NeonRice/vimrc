local silent = { silent = true }
local map = vim.keymap.set
local g = vim.g

local function bufmap(mode, l, r, opts)
  opts = opts or {}
  opts.buffer = true
  vim.keymap.set(mode, l, r, opts)
end

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

  map('n', '<CR>', '<CMD>noh<CR><CR>', silent)

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
  -- Open
  map('n', '<leader>of', '<cmd>Telescope find_files <cr>', silent)
  -- Navigate buffers and repos
  map('n', '<leader>ob', [[<cmd>Telescope buffers show_all_buffers=true theme=get_dropdown<cr>]], silent)
  -- map('n', '<leader>tr', [[<cmd>Telescope frecency theme=get_dropdown<cr>]], silent)
  map('n', '<leader>og', [[<cmd>Telescope git_files theme=get_dropdown<cr>]], silent)
  map('n', '<leader>op', [[<cmd>Telescope resume theme=get_dropdown<cr>]], silent)

  -- Find
  map('n', '<leader>fd', [[<cmd>Telescope live_grep theme=get_dropdown<cr>]], silent)
  map('n', '<leader>fh', [[<cmd>Telescope help_tags theme=get_dropdown<cr>]], silent)
  map('n', '<leader>fm', [[<cmd>Telescope marks theme=get_dropdown<cr>]], silent)
  map('n', '<leader>ff', [[<cmd>Telescope current_buffer_fuzzy_find theme=get_dropdown<cr>]], silent)
  map('n', '<leader>fp"', [[<cmd>Telescope spell_suggest theme=get_dropdown<cr>]], silent)
  map('n', '<leader>ft', [[<cmd>Telescope treesitter theme=get_dropdown<cr>]], silent)
  -- TODO: Not sure if I need these
  map('n', '<leader>fld', [[<cmd>Telescope lsp_definitions theme=get_dropdown<cr>]], silent)
  map('n', '<leader>fi', [[<cmd>Telescope lsp_implementations theme=get_dropdown<cr>]], silent)
  map('n', '<leader>fr', [[<cmd>Telescope lsp_references theme=get_dropdown<cr>]], silent)
  map('n', '<leader>fs', [[<cmd>Telescope lsp_document_symbols theme=get_dropdown<cr>]], silent)
  -- TODO: Dynamic for performance?
  map('n', '<leader>fS', [[<cmd>Telescope lsp_dynamic_workspace_symbols theme=get_dropdown<cr>]], silent)
  map('n', '<leader>fci', [[<cmd>Telescope lsp_incoming_calls theme=get_dropdown<cr>]], silent)
  map('n', '<leader>fco', [[<cmd>Telescope lsp_outgoing_calls theme=get_dropdown<cr>]], silent)

  -- Show
  map('n', '<leader>sd', [[<cmd>Telescope diagnostics theme=get_dropdown<cr>]], silent)

  -- TODO: (Currently in Telescope config)
  -- ['<c-d>'] = require('telescope.actions').delete_buffer

end

function LSP()
  vim.api.nvim_create_autocmd('User', {
    pattern = 'LspAttached',
    desc = 'LSP actions',
    callback = function()
      bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>',
        { desc = "Display hover information about the symbol under the cursor" })

      bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>',
        { desc = "Jump to definition" })

      bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>',
        { desc = "Jump to declaration" })

      bufmap('n', 'gI', '<cmd>lua vim.lsp.buf.implementation()<cr>',
        { desc = "List all the implementations for the symbol under the cursor" })

      bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>',
        { desc = "Jump to the definition of the type symbol" })

      bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>',
        { desc = "List all the references" })

      -- Displays a function's signature information
      bufmap({ 'n', 'i' }, '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>',
        { desc = "Display a function's signature info" })

      bufmap('n', '<leader>rf', vim.lsp.buf.format,
        { desc = "Format current buffer" })

      -- Renames all references to the symbol under the cursor
      bufmap('n', '<leader>rr', '<cmd>lua vim.lsp.buf.rename()<cr>',
        { desc = "Rename all references" })

      -- Selects a code action available at the current cursor position
      bufmap('n', '<leader>sa', '<cmd>lua vim.lsp.buf.code_action()<cr>',
        { desc = "Show code actions" })
      bufmap('x', '<leader>sa', '<cmd>lua vim.lsp.buf.range_code_action()<cr>',
        { desc = "Show code actions for selection" })

      -- Show diagnostics in a floating window
      bufmap('n', '<leader>se', '<cmd>lua vim.diagnostic.open_float()<cr>',
        { desc = "Show diagnostics" })

      -- Move to the previous diagnostic
      bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>',
        { desc = "Previous diagnostic" })

      -- Move to the next diagnostic
      bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>',
        { desc = "Next diagnostic" })

      -- Workspace actions
      bufmap('n', '<leader>wa', vim.lsp.buf.add_workspace_folder,
        { desc = "Add workspace folder" })
      bufmap('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder,
        { desc = "Remove workspace folder" })
      bufmap('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, { desc = "List workspace folders" })

      -- Open symbol outline
      bufmap('n', '<leader>ss', ":SymbolsOutline<CR>",
        { desc = "Show symbols outline" })
    end
  })
end

function gitsigns(bufnr)
  local gs = package.loaded.gitsigns

  -- Navigation
  bufmap('n', ']c', function()
    if vim.wo.diff then return ']c' end
    vim.schedule(function() gs.next_hunk() end)
    return '<Ignore>'
  end, { expr = true })

  bufmap('n', '[c', function()
    if vim.wo.diff then return '[c' end
    vim.schedule(function() gs.prev_hunk() end)
    return '<Ignore>'
  end, { expr = true })

  -- Actions
  bufmap({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
  bufmap({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
  bufmap('n', '<leader>hS', gs.stage_buffer)
  bufmap('n', '<leader>hu', gs.undo_stage_hunk)
  bufmap('n', '<leader>hR', gs.reset_buffer)
  bufmap('n', '<leader>hp', gs.preview_hunk)
  bufmap('n', '<leader>hb', function() gs.blame_line { full = true } end)
  bufmap('n', '<leader>sb', gs.toggle_current_line_blame)
  bufmap('n', '<leader>sd', gs.diffthis)
  bufmap('n', '<leader>sD', function() gs.diffthis('~') end)
  bufmap('n', '<leader>td', gs.toggle_deleted)

  -- Text object
  bufmap({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
end

mappings()
