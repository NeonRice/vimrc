---
-- Global Config
---

local lsp_defaults = {
  flags = {
    debounce_text_changes = 150,
  },
  capabilities = require('cmp_nvim_lsp').default_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  ),
  on_attach = function(client, bufnr)
    vim.api.nvim_exec_autocmds('User', { pattern = 'LspAttached' })

    -- Hightlights symbol on cursor hold
    if client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_augroup('lsp_document_highlight', {
        clear = false
      })
      vim.api.nvim_clear_autocmds({
        buffer = bufnr,
        group = 'lsp_document_highlight',
      })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        group = 'lsp_document_highlight',
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        group = 'lsp_document_highlight',
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
    end

    -- Diagnostic config
    vim.diagnostic.config({
      virtual_text = {
        prefix = '●',
      }
    })
  end
}

-- Use signs for diagnostics
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local lspconfig = require('lspconfig')

-- Merge our set default config with global lspconfig
lspconfig.util.default_config = vim.tbl_deep_extend(
  'force',
  lspconfig.util.default_config,
  lsp_defaults
)

---
-- LSP Servers
---

lspconfig.sumneko_lua.setup({
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      telemetry = {
        enable = false
      },
      workspace = {
        checkThirdParty = false,
        -- If i want to see autocompletion for vim stuff.. Slow on a laptop
        -- library = vim.api.nvim_get_runtime_file('', true),
      }
    },
  },
})

lspconfig.pylsp.setup({})

local clangd_config = vim.deepcopy(lsp_defaults)
clangd_config.on_attach = function(client, bufnr)
  lsp_defaults.on_attach(client, bufnr)
  require("plugins/clangd_extensions").on_attach()
end
lspconfig.clangd.setup(clangd_config)
