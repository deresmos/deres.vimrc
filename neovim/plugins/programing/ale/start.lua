-- vim.api.nvim_create_autocmd("FileType", {
--   group = vim.api.nvim_create_augroup("my-ale", {}),
--   pattern = { "go" },
--   callback = function()
--     vim.b.ale_enabled = 1
--     vim.b.ale_fix_on_save = 1
--   end,
-- })
vim.g.ale_disable_lsp = 1

vim.g.ale_use_neovim_diagnostics_api = 1
vim.g.ale_go_golangci_lint_package = 1
vim.g.ale_go_staticcheck_lint_package = 1

vim.cmd [[

nnoremap <silent> <SPACE>af :<C-u>silent! ALEFix<CR>

let g:ale_sign_column_always   = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_text_changed = 'normal'
let g:ale_enabled              = 1
let g:ale_virtualtext_cursor   = 1
let g:ale_virtualtext_prefix   = ' >> '

let g:ale_sign_error           = '>>'
let g:ale_sign_warning         = '>>'
let g:ale_echo_msg_error_str   = 'E'
let g:ale_echo_msg_warning_str = 'W'

let g:ale_echo_msg_format   = '[%severity%] %code%: %s | %linter%'

function! AleStatus()
  if !get(b:, 'ale_enabled', 0) && !g:ale_enabled
    return ''
  endif

  let counts = ale#statusline#Count(bufnr(''))

  if !counts['total']
    return 'OK'
  endif

  return printf('E%d W%d', counts[0], counts[1])
endfunction

" function! s:parseCfnLint(line) abort
"   let words = split(a:line, ":")
"   return {"text": words[6], "lnum": words[1], "col": words[2], "type": "W"}
" endfunction
"
" call ale#linter#Define('yaml', {
"   \ 'name': 'cfn-lint',
"   \ 'executable': 'cfn-lint',
"   \ 'command': 'cfn-lint -f parseable %t',
"   \ 'callback': {buffer, lines -> map(lines, 's:parseCfnLint(v:val)')},
"   \ })

let g:ale_linters = {
  \ 'python': ['flake8', 'mypy', 'bandit'],
  \ 'javascript': ['eslint'],
  \ 'php': ['phpcs'],
  \ 'css': ['stylelint'],
  \ 'xhtml': ['tidy'],
  \ 'cs': ['OmniSharp'],
  \ 'swift': ['swiftlint'],
  \ 'kotlin': ['ktlint'],
  \ 'go': ['staticcheck'],
  \ 'yaml': ['yamllint', 'cfn-lint'],
  \ }


augroup TestALE
    autocmd!
    autocmd User ALELintPre    echomsg 1
    autocmd User ALELintPost   echomsg 2

    " autocmd User ALEJobStarted call YourFunction()
    "
    " autocmd User ALEFixPre     call YourFunction()
    " autocmd User ALEFixPost    call YourFunction()
augroup END

let g:ale_type_map = {'flake8': {'ES': 'WS'}}
let g:ale_css_stylelint_options='-c stylelint'
let g:ale_python_mypy_options='--ignore-missing-imports'
let g:ale_python_flake8_options='--ignore=E501'
" let g:ale_go_golangci_lint_options='--fast'

let g:ale_html_tidy_options='-config ~/.tidy_linter -e'
let g:ale_php_phpcs_standard='PSR2'
let g:ale_linter_aliases = {'xhtml': 'html'}

let g:ale_fixers = {
  \ 'html': [
  \   {buffer, lines -> {
  \   'command': 'tidy -config ~/.tidy_fix %s'}}
  \ ],
  \ 'xhtml': [
  \   {buffer, lines -> {
  \   'command': 'tidy -config ~/.tidy_fix %s'}}
  \ ],
  \ 'javascript': [
  \   {buffer, lines -> {
  \   'command': 'eslint --config ~/.eslintrc.js --fix %t',
  \   'read_temporary_file': 1}}
  \ ],
  \ 'css': [
  \   {buffer, lines -> {
  \   'command': 'stylelint -c stylelint --fix %t',
  \   'read_temporary_file': 1}},
  \   {buffer, lines -> {
  \   'command': 'csscomb -c ~/.csscomb.json %s'}}
  \ ],
  \ 'php': [
  \   {buffer, lines -> {
  \   'command': 'phpcbf --standard=PSR2 %t',
  \   'read_temporary_file': 1}}
  \ ],
  \ 'python': [
  \   'isort',
  \   {buffer, lines -> {
  \   'command': 'black %t',
  \   'read_temporary_file': 1}}
  \ ],
  \ 'kotlin': [
  \   {buffer, lines -> {
  \   'command': 'ktlint -F %t',
  \   'read_temporary_file': 1}}
  \ ],
  \ 'markdown': [
  \   {buffer, lines -> {
  \   'command': 'textlint -c ~/.config/textlintrc -o /dev/null --fix --no-color --quiet %t',
  \   'read_temporary_file': 1}}
  \ ],
  \ 'sql': [
  \   {buffer, lines -> {
  \   'command': 'sqlformat --reindent --keywords upper -s %t | sql-formatter-cli -o %t',
  \   'read_temporary_file': 1}}
  \ ],
  \ 'go': ['gofmt', 'goimports'],
  \ 'svelte': ['prettier'],
  \ 'json': ['jq'],
  \ }
" let g:ale_fix_on_save = 1

highlight link ALEWarningSign SpellCap
]]
