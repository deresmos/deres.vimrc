nnoremap <silent> <SPACE>to :ToggleTerm direction=horizontal size=20<CR>
nnoremap <silent> <SPACE>tf :ToggleTerm direction=float size=20<CR>

function! s:setup_term() abort
  nnoremap <buffer> I i<C-a>
  nnoremap <buffer> A a<C-e>
  nnoremap <buffer> dd i<C-e><C-u><C-\><C-n>
  nnoremap <buffer> cc i<C-e><C-u>
  nnoremap <buffer> q :<C-u>quit<CR>
endfunction

augroup term-custom
  autocmd!
  autocmd TermOpen term://* call s:setup_term()
augroup END

lua << EOF
require("toggleterm").setup{
  size = function(term)
    if term.direction == "horizontal" then
      return 20
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  -- open_mapping = [[<c-\>]],
  -- hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = 'horizontal',
  close_on_exit = false,
  shell = vim.o.shell,
  float_opts = {
    border = 'curved',
    highlights = {
      border = "Normal",
      background = "Normal",
    },
  },
}
EOF
