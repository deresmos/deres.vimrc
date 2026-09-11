local lint = require('lint')

lint.linters_by_ft = {
  python = { 'flake8', 'mypy', 'bandit' },
  javascript = { 'eslint' },
  javascriptreact = { 'eslint' },
  typescript = { 'eslint' },
  typescriptreact = { 'eslint' },
  php = { 'phpcs' },
  css = { 'stylelint' },
  html = { 'tidy' },
  xhtml = { 'tidy' },
  swift = { 'swiftlint' },
  kotlin = { 'ktlint' },
  go = { 'staticcheck' },
  yaml = { 'yamllint', 'cfn_lint' },
}

local function prepend_args(name, args)
  local linter = lint.linters[name]
  if type(linter) == 'table' then
    linter.args = vim.list_extend(args, vim.deepcopy(linter.args or {}))
  end
end

prepend_args('flake8', { '--ignore=E501' })
prepend_args('mypy', { '--ignore-missing-imports' })
prepend_args('phpcs', { '--standard=PSR2' })

vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
  callback = function()
    lint.try_lint()
  end,
})
