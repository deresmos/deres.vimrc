set completeopt=menuone,noselect
let g:compe = {}
let g:compe.enabled = v:true
let g:compe.source = {
  \ 'path': {'ignored_filetypes': ['clap_input', 'denite-filter']},
  \ 'buffer': {'ignored_filetypes': ['clap_input', 'denite-filter']},
  \ 'calc': v:true,
  \ 'nvim_lsp': v:true,
  \ 'nvim_lua': v:true,
  \ }
