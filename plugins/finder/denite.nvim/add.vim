let g:denite_cwd = ''

nnoremap <silent> <SPACE>ds :<C-u>call SwitchMatherRegexp() <Bar> echo 'Changed mather to [regexp]'<CR>
nnoremap <silent> <SPACE>dS :<C-u>call SwitchMatherFuzzy() <Bar> echo 'Changed mather to [fuzzy]'<CR>

nnoremap <silent> <SPACE>dr :<C-u>call SwitchGrepCommand('rg-sjis') <Bar> echo 'Changed grep cmd to [pt]'<CR>
nnoremap <silent> <SPACE>dR :<C-u>call SwitchGrepCommand('rg') <Bar> echo 'Changed grep cmd to [rg]'<CR>

function! SwitchMatherRegexp() abort " {{{1
  call s:switchMather('matcher_regexp')
endfunction

function! SwitchMatherFuzzy() abort " {{{1
  call s:switchMather('matcher_fuzzy')
endfunction

function! s:switchMather(matcher) abort " {{{1
  let l:lists = [
    \ 'file/rec', 'file', 'buffer', 'file_mru',
    \ 'line', 'jump', 'change', 'tag', 'gitdiff_file', 'grep']

  for l:list in l:lists
    call denite#custom#source(l:list, 'matchers',
      \ [a:matcher, 'matcher_ignore_globs'])
  endfor

  call denite#custom#source('gitdiff_log', 'matchers', [a:matcher])
endfunction

function! SwitchGrepCommand(command) abort " {{{1
  if a:command ==# 'ag'
    call denite#custom#var('grep', 'command', ['ag'])
    call denite#custom#var('grep', 'default_opts',
        \ ['--vimgrep', '--follow', '--hidden', '-S'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', [])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])

    call denite#custom#var('file/rec', 'command',
      \ ['ag', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', ''])

  elseif a:command ==# 'jvgrep'
    call denite#custom#var('grep', 'command', ['jvgrep'])
    call denite#custom#var('grep', 'default_opts', ['-i'])
    call denite#custom#var('grep', 'recursive_opts', ['-R'])
    call denite#custom#var('grep', 'pattern_opt', [])
    call denite#custom#var('grep', 'separator', [])
    call denite#custom#var('grep', 'final_opts', [])

  elseif a:command ==# 'rg' || a:command ==# 'rg-sjis'
    call denite#custom#var('grep', 'command', ['rg'])
    if a:command ==# 'rg-sjis'
      call denite#custom#var('grep', 'default_opts',
          \ ['--vimgrep', '--follow', '--hidden', '-S', '-E', 'sjis'])
    else
      call denite#custom#var('grep', 'default_opts',
          \ ['--vimgrep', '--follow', '--hidden', '-S'])
    endif
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])

    call denite#custom#var('file/rec', 'command',
      \ ['rg', '--files', '--follow', '--hidden', '--no-heading'])

  elseif a:command ==# 'pt'
    call denite#custom#var('grep', 'command', ['pt'])
    call denite#custom#var('grep', 'default_opts',
        \ ['--nogroup', '--nocolor', '--follow', '--hidden', '-S'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', ['-e'])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])
      endif
    endfunction
