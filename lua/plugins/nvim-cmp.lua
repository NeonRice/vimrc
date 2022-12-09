local cmp = require('cmp')
-- To help cmp expand luasnip snippets
local luasnip = require('luasnip')
-- To let lspkind handle my completion style
local lspkind = require('lspkind')
require('luasnip.loaders.from_vscode').lazy_load()

local select_opts = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
  -- Autocompletion sources, order determines priority
  sources = {
    { name = 'nvim_lua' },
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'luasnip' },
    { name = 'buffer', keyword_length = 5 },
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  -- Appearance and settings for the documentation window
  window = {
    -- TODO: Customize
    -- Preset to add some borders
    documentation = cmp.config.window.bordered()
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol_text",
      menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[Snip]",
        nvim_lua = "[Lua]",
        latex_symbols = "[LaTeX]",
      })
    }),
  },
  experimental = { ghost_text = true },
  -- Mappings for completion TODO: Move to mappings.lua
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
    ['<C-n>'] = cmp.mapping.select_next_item(select_opts),

    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),

    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),

    ['<C-space>'] = cmp.mapping.complete(),

    -- Jump to next placeholder in the snippet
    ['<C-d>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, { 'i', 's' }),

    -- Jump to previous placeholder in the snippet
    ['<C-b>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
})

-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

vim.api.nvim_set_hl(0, 'CmpItemMenu', { link = "Grey" })
