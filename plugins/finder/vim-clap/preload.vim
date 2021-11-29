  function! s:clap_buffer_mapping() abort
    nmap <silent><buffer> q <ESC>
    nnoremap <silent><buffer> l :<C-u>call clap#handler#cr_action()<CR>
    nnoremap h :<C-u>call clap#handler#bs_action()<CR>

    nmap <silent><buffer> v <C-v>
    nmap <silent><buffer> s <C-x>
    nmap <silent><buffer> t <C-t>
                                                                        
    imap <silent><buffer> <C-h> <BS>
    imap <silent><buffer> <C-l> <ENTER>i
  endfunction

  augroup CustomVimClap
    autocmd!
    autocmd FileType clap_input call s:clap_buffer_mapping()
  augroup END
