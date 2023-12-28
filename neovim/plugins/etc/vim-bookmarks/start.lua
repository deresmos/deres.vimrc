require('bookmarks').setup()

local bm = require 'bookmarks'
vim.keymap.set('n', '<Space>hdb', require('my.hydra').set_hydra('Bookmarks', {
   { 'a', bm.bookmark_ann,    { desc = 'annotation', exit = true } },
   { 't', bm.bookmark_toggle, { desc = 'toggle', exit = true } },
   { 'C', bm.bookmark_clean,  { desc = 'clean', exit = true, sep = '' } },
   { 'j', bm.bookmark_next,   { desc = 'next' } },
   { 'k', bm.bookmark_prev,   { desc = 'prev' } },
   { 'l', bm.bookmark_list,   { desc = 'list', exit = true } },
   { 'q', nil,                { exit = true, nowait = true, desc = 'exit', sep = '' } },
}), { silent = true, noremap = true })
