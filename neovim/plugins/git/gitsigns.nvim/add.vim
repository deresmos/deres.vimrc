nnoremap <silent> <SPACE>gk <cmd>lua require'gitsigns.actions'.prev_hunk({wrap=false})<CR>
nnoremap <silent> <SPACE>gj <cmd>lua require'gitsigns.actions'.next_hunk({wrap=false})<CR>
nnoremap <silent> <SPACE>gp <cmd>lua require'gitsigns'.preview_hunk()<CR>
nnoremap <silent> <SPACE>gu <Nop>
nnoremap <silent> <SPACE>gU <cmd>lua require'gitsigns'.reset_hunk()<CR>
xnoremap <silent> <SPACE>gU <cmd>lua require'gitsigns'.reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>
nnoremap <silent> <SPACE>ga <Nop>
nnoremap <silent> <SPACE>gA <cmd>lua require'gitsigns'.stage_hunk()<CR>
xnoremap <silent> <SPACE>gA <cmd>lua require'gitsigns'.stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>
nnoremap <silent> <SPACE>gtt <cmd>lua require'gitsigns'.toggle_signs()<CR>
nnoremap <silent> <SPACE>gtw <cmd>lua require'gitsigns'.toggle_word_diff()<CR>
nnoremap <silent> <SPACE>gtd <cmd>lua require'gitsigns'.toggle_deleted()<CR>
