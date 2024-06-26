local types = require('cmp.types')
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      require 'luasnip'.lsp_expand(args.body)
    end
  },
  completion = {
    autocomplete = {
      types.cmp.TriggerEvent.TextChanged,
    },
    completeopt = 'menuone,noinsert,noselect',
    keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
    keyword_length = 1,
  },
  experimental = {
    ghost_text = false,
  },
  enabled = function()
    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
    --or require("cmp_dap").is_dap_buffer()
  end,
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.SelectBehavior.Replace }),
    ['<C-i>'] = cmp.mapping(function(fallback)
      if require 'luasnip'.expand_or_jumpable() then
        require 'luasnip'.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-n>'] = cmp.mapping(function(fallback)
      if require 'luasnip'.jumpable(1) then
        require 'luasnip'.jump(1)
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-p>'] = cmp.mapping(function(fallback)
      if require 'luasnip'.jumpable(-1) then
        require 'luasnip'.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' })
  }),
  sources = cmp.config.sources({
    { name = 'dap' },
  }, {
    { name = "copilot", keyword_length = 0 },
    { name = "luasnip" },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'nvim_lua' },
    {
      name = "dictionary",
      keyword_length = 2,
    },
  }, {
    { name = 'path' },
  }, {
    { name = 'calc' },
    -- { name = 'nvim_lsp_signature_help' },
  }),
  sorting = {
    comparators = {
      require("copilot_cmp.comparators").prioritize,
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      require "cmp-under-comparator".under,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
})

local function select_next_item()
  if cmp.visible() then
    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
  else
    cmp.complete()
  end
end

local function select_prev_item()
  if cmp.visible() then
    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
  else
    cmp.complete()
  end
end

local cmdline_mapping = {
  ['<C-j>'] = {
    c = select_next_item
  },
  ['<C-k>'] = {
    c = select_prev_item
  },
  ['<Tab>'] = {
    c = select_next_item
  },
  ['<S-Tab>'] = {
    c = select_prev_item
  },
  ['<C-Space>'] = {
    c = cmp.mapping.complete(),
  },
  ['<CR>'] = {
    c = cmp.mapping.confirm({ select = true, behavior = cmp.SelectBehavior.Replace }),
  },
  ['<C-e>'] = {
    c = cmp.mapping.abort(),
  },
  ['<C-y>'] = {
    c = cmp.mapping.confirm({ select = false }),
  },
}
-- cmp.setup.cmdline('/', {
--   mapping = cmdline_mapping,
--   sources = {
--     { name = 'buffer' }
--   }
-- })
cmp.setup.cmdline(':', {
  mapping = cmdline_mapping,
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    {
      name = 'cmdline',
      option = {
        ignore_cmds = { 'Man', '!' }
      }
    }
  })
})

cmp.setup.cmdline('q:', {
  mapping = cmdline_mapping,
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    {
      name = 'cmdline',
      option = {
        ignore_cmds = { 'Man', '!' }
      }
    }
  })
})
