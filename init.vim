" NeonRice Vim Config
              "████████              
          "████        ████          
        "██            ░░  ██        
      "██░░            ░░    ██      
    "██                        ██    
  "██                ░░          ██  
  "██    ░░                      ██  
"██              ░░                ██
"██          ████████████          ██
"██░░        ████████████    ░░    ██
"██  ░░      ████████████      ░░░░██
"██░░        ████████████      ░░░░██
"██░░░░░░░░░░████████████░░░░░░░░░░██
  "██░░░░░░░░████████████░░░░░░░░██  
    "████████████████████████████    

" Auto Install Vim-Plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let g:plug_home = stdpath("data") . "/plugged"
call plug#begin(plug_home)

" Fuzzy finder
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Theme
Plug 'morhetz/gruvbox'

" Syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" LSP Ecosystem
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Snippets
Plug 'honza/vim-snippets'

" Explorer
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'

" Lualine (Status line)
Plug 'nvim-lualine/lualine.nvim'

" Debug adapter protocol
Plug 'mfussenegger/nvim-dap'
Plug 'mfussenegger/nvim-dap-python'
Plug 'rcarriga/nvim-dap-ui'

" Easy jumping
Plug 'ggandor/lightspeed.nvim'

" . Repeat with plugins
Plug 'tpope/vim-repeat'

call plug#end()

" Hybrid Numbering
set number relativenumber

" Indentation
set tabstop=2 shiftwidth=2 expandtab

" Hide highlighting left after search
nnoremap <silent> <CR> :noh<CR><CR>

let mapleader = " " " space as leader key

" File Tree
lua << END
require('nvim-tree').setup {
  view = {
    mappings = {
      list = { 
        { key = "<C-e>", action = ""}
      },
    },
  },
} 
END
nnoremap <silent> <c-e> :NvimTreeToggle<CR>

" Lualine
lua << END
require('lualine').setup {
  sections = {
    lualine_c = {
      {
        'filename',
        file_status = true,
        path = 1
      }
    },
  },
}
END

" Tree sitter
lua <<EOF
require('nvim-treesitter.configs').setup {
  ensure_installed = "all",
  highlight = { enable = true },
  indent = { enable = true }
}
EOF

" coc.nvim Configuration
let g:coc_node_path = trim(system('which node'))
let g:coc_global_extensions = [
  \'coc-json', 'coc-pyright',
  \'coc-pairs', 'coc-snippets',
\]

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <leader>a for Code action
 nmap <silent><nowait> <space>a  <Plug>(coc-codeaction-cursor)

" Use ctrl-[hjkl] to select the active split!
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use leader + k to show documentation in preview window.
nnoremap <silent> <leader>k :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Moving through auto-completion suggestions
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Autocomplete-Format code on <cr>
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Coc snippets

" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

" Use <leader>x for convert visual selected code to snippet
xmap <leader>x  <Plug>(coc-convert-snippet)

" End of Coc settings

" No more capital :W or :Q
" nnoremap ; :| nnoremap : ;

" Copy (relative) file path with line
map <leader>l :let @*=fnamemodify(expand("%"), ":~:.") . ":" . line(".")<CR>

" Vim terminal emulator
"
" To exit terminal-mode:                                                                                                                            
:tnoremap <leader>q <C-\><C-n>                                                                                                                                                                      
" To simulate i_CTRL-R in terminal-mode:
:tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'                                                                                                                                    
" To use CTRL+{h,j,k,l} to navigate windows from any mode:
:tnoremap <C-h> <C-\><C-N><C-w>h
:tnoremap <C-j> <C-\><C-N><C-w>j
:tnoremap <C-k> <C-\><C-N><C-w>k
:tnoremap <C-l> <C-\><C-N><C-w>l
:inoremap <C-h> <C-\><C-N><C-w>h
:inoremap <C-j> <C-\><C-N><C-w>j
:inoremap <C-k> <C-\><C-N><C-w>k
:inoremap <C-l> <C-\><C-N><C-w>l
:nnoremap <C-h> <C-w>h
:nnoremap <C-j> <C-w>j
:nnoremap <C-k> <C-w>k
:nnoremap <C-l> <C-w>l

" nvim-dap 
lua << EOF
local dap = require('dap')

vim.fn.sign_define('DapBreakpoint', {text='🟥', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='⭐️', texthl='', linehl='', numhl=''})

-- Will remove if codellbd proves to be better
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode-10', -- adjust as needed
  name = "lldb"
}
dap.adapters.codelldb = {
    type = 'server',
    host = '127.0.0.1',
    port = 13000
}

-- TODO: Might want to remove hardcoded debugpy venv path
-- and instead find the path dynamically
require('dap-python').setup('~/.venvs/debugpy/bin/python')
table.insert(require('dap').configurations.python, {
  type = 'python',
  request = 'attach',
  name = 'Docker launch configuration',
  host = "127.0.0.1",
  port = 5678,
  justMyCode = false,
  pathMappings = {{
    localRoot = vim.fn.getcwd();
    remoteRoot = "/backend";
  }};
})

dap.configurations.cpp = {
  {
    name = "Launch",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    --program = '${fileDirname}/${fileBasenameNoExtension}',
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
    runInTerminal = false,
  },
  {
    -- If you get an "Operation not permitted" error, try disabling YAMA:
    --  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    name = "Attach to process",
    type = 'codelldb',
    request = 'attach',
    pid = require('dap.utils').pick_process,
    args = {},
  },
}
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

require("dapui").setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
  },
  sidebar = {
    -- You can change the order of elements in the sidebar
    elements = {
      -- Provide as ID strings or tables with "id" and "size" keys
      {
        id = "scopes",
        size = 0.25, -- Can be float or integer > 1
      },
      { id = "breakpoints", size = 0.25 },
      { id = "stacks", size = 0.25 },
      { id = "watches", size = 00.25 },
    },
    size = 40,
    position = "left", -- Can be "left", "right", "top", "bottom"
  },
  tray = {
    elements = { "repl" },
    size = 10,
    position = "bottom", -- Can be "left", "right", "top", "bottom"
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
})
-- Open UI and close with events from dap
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
EOF

nnoremap <leader>dh :lua require'dap'.toggle_breakpoint()<CR>
"nnoremap <S-k> :lua require'dap'.step_out()<CR>
"nnoremap <S-l> :lua require'dap'.step_into()<CR>
"nnoremap <S-j> :lua require'dap'.step_over()<CR>
nnoremap <leader>ds :lua require'dap'.stop()<CR>
nnoremap <leader>dn :lua require'dap'.continue()<CR>
nnoremap <leader>dk :lua require'dap'.up()<CR>
nnoremap <leader>dj :lua require'dap'.down()<CR>
nnoremap <leader>d_ :lua require'dap'.disconnect();require'dap'.stop();require'dap'.run_last()<CR>
nnoremap <leader>dr :lua require'dap'.repl.open({}, 'vsplit')<CR><C-w>l
nnoremap <leader>di :lua require'dap.ui.variables'.hover()<CR>
"vnoremap <leader>di :lua require'dap.ui.variables'.visual_hover()<CR>
"nnoremap <leader>d? :lua require'dap.ui.variables'.scopes()<CR>
nnoremap <leader>de :lua require'dap'.set_exception_breakpoints({"all"})<CR>
nnoremap <leader>da :lua require'debugHelper'.attach()<CR>
nnoremap <leader>dA :lua require'debugHelper'.attachToRemote()<CR>
nnoremap <leader>di :lua require'dap.ui.widgets'.hover()<CR>
nnoremap <leader>d? :lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>
" UI
vnoremap <leader>di <Cmd>lua require("dapui").eval()<CR>
nnoremap <leader>d? :lua require'dap.ui.variables'.scopes()<CR>

" Indentation?
if has("autocmd")
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on
  " ...
endif

" Telescope
nnoremap <leader>tf <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>tg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>tb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>th <cmd>lua require('telescope.builtin').help_tags()<cr>

" Gruvbox theme
colorscheme gruvbox
set background=light
set termguicolors " Dark looks better without this
