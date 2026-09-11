local conform = require('conform')
local util = require('conform.util')

conform.setup({
  formatters_by_ft = {
    html = { 'tidy' },
    xhtml = { 'tidy' },
    javascript = { 'eslint' },
    javascriptreact = { 'eslint' },
    typescript = { 'eslint' },
    typescriptreact = { 'eslint' },
    css = { 'stylelint', 'csscomb' },
    php = { 'phpcbf' },
    python = { 'isort', 'black' },
    kotlin = { 'ktlint' },
    markdown = { 'textlint' },
    sql = { 'sqlformat' },
    go = { 'goimports', 'gofmt' },
    svelte = { 'prettier' },
    json = { 'jq' },
  },
  formatters = {
    tidy = {
      command = 'tidy',
      args = { '-config', vim.fn.expand('~/.tidy_fix') },
      stdin = true,
      exit_codes = { 0, 1, 2 },
    },
    eslint = {
      command = util.from_node_modules('eslint'),
      args = { '--config', '.eslintrc.js', '--fix', '$FILENAME' },
      stdin = false,
    },
    stylelint = {
      prepend_args = { '--config', 'stylelint', '--fix' },
    },
    phpcbf = {
      prepend_args = { '--standard=PSR2' },
    },
    csscomb = {
      command = 'csscomb',
      args = { '-c', vim.fn.expand('~/.csscomb.json'), '$FILENAME' },
      stdin = false,
    },
    textlint = {
      command = 'textlint',
      args = { '--config', vim.fn.expand('~/.config/textlintrc'), '--fix', '--no-color', '--quiet', '$FILENAME' },
      stdin = false,
    },
    sqlformat = {
      command = 'sqlformat',
      args = { '--reindent', '--keywords', 'upper', '-s' },
      stdin = true,
    },
  },
})

vim.keymap.set({ 'n', 'v' }, '<Space>af', function()
  conform.format({
    async = false,
    lsp_format = 'fallback',
  })
end, { silent = true, noremap = true, desc = 'format buffer or selection' })
