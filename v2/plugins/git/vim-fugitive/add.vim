function! FugitiveCommitError(error, tmpfile)
  if a:error =~? 'pre-commit'
    call s:applyQflist(a:tmpfile)
  endif
endfunction

function! s:applyQflist(tmpfile)
  let errors = []
  let contents = readfile(a:tmpfile)

  let filepath = ''
  for content in contents
    if empty(content)
      continue
    endif

    if content =~? '^/' && filereadable(content)
      let filepath = content
      continue
    endif

    if content =~? '\v\s*[0-9]+:[0-9]+'
      let csp = split(content)
      call add(errors, filepath . ':' . csp[0] . ':' . join(csp[2:-2], ' ') . '. [' . csp[-1] . ']')
    endif
  endfor

  setlocal errorformat=%f:%l:%c:%m
  cgetexpr join(errors, "\n")
  q
  copen
endfunction

nnoremap <silent> <SPACE>gs <cmd>Git<CR>
nnoremap <silent> <SPACE>gv <cmd>Gvdiff<CR>
nnoremap <silent> <SPACE>gb <cmd>Git blame<CR>
