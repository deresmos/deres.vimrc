local luasnip = require('luasnip')

require('blink.cmp').setup({
  enabled = function()
    return vim.bo.buftype ~= 'prompt'
  end,
  keymap = {
    preset = 'none',
    ['<C-j>'] = { 'select_next', 'show', 'fallback' },
    ['<C-k>'] = { 'select_prev', 'show', 'fallback' },
    ['<C-d>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
    ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<CR>'] = { 'select_and_accept', 'fallback' },
    ['<C-i>'] = {
      function()
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
          return true
        end
      end,
      'fallback',
    },
    ['<C-n>'] = {
      function()
        if luasnip.jumpable(1) then
          luasnip.jump(1)
          return true
        end
      end,
      'select_next',
      'show',
      'fallback',
    },
    ['<C-p>'] = {
      function()
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
          return true
        end
      end,
      'select_prev',
      'show',
      'fallback',
    },
  },
  snippets = {
    preset = 'luasnip',
  },
  completion = {
    list = {
      selection = {
        preselect = false,
        auto_insert = false,
      },
    },
    menu = {
      border = 'rounded',
    },
    documentation = {
      auto_show = true,
      window = {
        border = 'rounded',
      },
    },
    ghost_text = {
      enabled = false,
    },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  cmdline = {
    keymap = {
      preset = 'none',
      ['<C-j>'] = { 'select_next', 'show', 'fallback' },
      ['<C-k>'] = { 'select_prev', 'show', 'fallback' },
      ['<Tab>'] = { 'select_next', 'show', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'show', 'fallback' },
      ['<C-Space>'] = { 'show', 'fallback' },
      ['<CR>'] = { 'select_accept_and_enter', 'fallback' },
      ['<C-e>'] = { 'cancel', 'fallback' },
      ['<C-y>'] = { 'select_and_accept', 'fallback' },
    },
    sources = { 'path', 'cmdline' },
    completion = {
      list = {
        selection = {
          preselect = false,
          auto_insert = false,
        },
      },
      menu = {
        auto_show = true,
      },
    },
  },
  fuzzy = {
    implementation = 'prefer_rust_with_warning',
  },
})
