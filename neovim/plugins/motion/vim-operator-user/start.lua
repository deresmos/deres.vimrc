local map = vim.keymap

-- Camelize and decamelize
-- map.set('n', 'sc', '<Plug>(operator-camelize)gv', {silent=true, noremap=false})
-- map.set('n', 'sC', '<Plug>(operator-decamelize)gv', {silent=true, noremap=false})
-- map.set('n', 'se', '<Plug>(operator-html-escape)', {silent=true, noremap=false})
-- map.set('n', 'sE', '<Plug>(operator-html-unescape)', {silent=true, noremap=false})

map.set('x', 'sc', '<Plug>(operator-camelize)gv', {silent=true, noremap=false})
map.set('x', 'sC', '<Plug>(operator-decamelize)gv', {silent=true, noremap=false})
map.set('x', 'se', '<Plug>(operator-html-escape)', {silent=true, noremap=false})
map.set('x', 'sE', '<Plug>(operator-html-unescape)', {silent=true, noremap=false})

-- Operator surround blocks
vim.g.operator_surround_blocks = {
  ['-'] = {
    { block = {'(', ')'}, motionwise = {'char', 'line', 'block'}, keys = {'b'} },
    { block = {'{', '}'}, motionwise = {'char', 'line', 'block'}, keys = {'B'} },
    { block = {"'", "'"}, motionwise = {'char', 'line', 'block'}, keys = {'q'} },
    { block = {'"', '"'}, motionwise = {'char', 'line', 'block'}, keys = {'Q'} }
  }
}
