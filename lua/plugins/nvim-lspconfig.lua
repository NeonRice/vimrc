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
        globals = {"vim"},
      },
      telemetry = {
        enable = false
      }
    },
  },
})

lspconfig.pyright.setup({})

lspconfig.clangd.setup({})
