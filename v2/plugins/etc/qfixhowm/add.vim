
  " functions {{{
  function! s:HowmEditDiary(filename) abort
    tabnew
    call qfixmemo#EditDiary(a:filename)
  endfunction

  function! s:pullHowm() abort
    execute 'AsyncRun -cwd=' . g:QFixHowm_RootDir 'git pull origin master'
  endfunction

  function! s:pushHowm() abort
    execute 'AsyncRun -cwd=' . g:QFixHowm_RootDir ' git add . && git commit -m "commit" && git push origin master'
  endfunction

  function! QFixMemoBufRead()
    setlocal foldenable
  endfunction

  " }}}

  " map {{{
  nnoremap <silent> <SPACE>hc :<C-u>call qfixmemo#Calendar()<CR>
  nnoremap <silent> <SPACE>hm :<C-u>call <SID>HowmEditDiary('memo')<CR>
  nnoremap <silent> <SPACE>hs :<C-u>call <SID>HowmEditDiary('schedule')<CR>
  nnoremap <silent> <SPACE>ht :<C-u>call <SID>HowmEditDiary(g:qfixmemo_diary)<CR>
  nnoremap <silent> <SPACE>hf :<C-u>call <SID>HowmEditDiary('filetype/' . &filetype)<CR>
  nnoremap <silent> <SPACE>ho :<C-u>call <SID>HowmEditDiary('memo/'.input('Name: '))<CR>
  nnoremap <silent> <SPACE>hlo :Denite file -path=`g:howm_dir`/memo<CR>
  nnoremap <silent> <SPACE>hg :<C-u>call qfixmemo#FGrep()<CR>
  nnoremap <silent> <SPACE>ha :<C-u>call qfixmemo#PairFile('%')<CR>
  nnoremap <silent> <SPACE>hid :<C-u>call qfixmemo#InsertDate('date')<CR>
  nnoremap <silent> <SPACE>hit :<C-u>call qfixmemo#InsertDate('time')<CR>
  nnoremap <silent> <SPACE>hlr :<C-u>call qfixmemo#ListMru()<CR>
  nnoremap <silent> <SPACE>hlt :<C-u>call qfixmemo#ListReminder('todo')<CR>
  nnoremap <silent> <SPACE>hls :<C-u>call qfixmemo#ListReminder('schedule')<CR>
  nnoremap <silent> <SPACE>hlc :<C-u>call qfixmemo#ListFile(g:qfixmemo_diary)<CR>
  nnoremap <silent> <SPACE>hlf :<C-u>call qfixmemo#ListFile('filetype/*')<CR>
  nnoremap <silent> <SPACE>hlw :<C-u>call qfixmemo#ListFile('wiki/*')<CR>
  nnoremap <silent> <SPACE>hll :<C-u>call qfixmemo#ListRecentTimeStamp()<CR>

  command! -nargs=1 HowmDir let g:howm_dir = g:QFixHowm_RootDir.'/'.<q-args>|echo 'Switched' <q-args>
  nnoremap <silent> <SPACE>hpw :<C-u>HowmDir work<CR>
  nnoremap <silent> <SPACE>hpm :<C-u>HowmDir main<CR>
  nnoremap <silent> <SPACE>hpl :<C-u>call <SID>pullHowm()<CR>
  nnoremap <silent> <SPACE>hps :<C-u>call <SID>pushHowm()<CR>
  " }}}

  let g:QFixHowm_MenuKey        = 0
  let g:QFixHowm_Key            = '<Nop>'
  let g:howm_fileencoding       = 'utf-8'
  let g:howm_fileformat         = 'unix'
  let g:qfixmemo_diary          = '%Y/%m/%Y-%m-%d'
  let g:QFixHowm_CalendarWinCmd = 'rightbelow'
  let g:QFixHowm_CalendarCount  = 3
  let g:QFixHowm_FileType       = 'qfix_memo'
  let g:qfixmemo_template       = ['%TITLE% ']
  let g:qfixmemo_use_addtime    = 0
  let g:qfixmemo_use_updatetime = 0
  let g:QFixHowm_SaveTime       = -1
  let g:QFixHowm_Wiki           = 1
  let g:QFixHowm_WikiDir        = 'wiki'
  let g:QFixHowm_Menufile       = 'menu.howm'
  let g:QFixHowm_MenuCloseOnJump = 1

  let g:QFixHowm_RootDir         = '~/.howm'
  let g:howm_dir                 = g:QFixHowm_RootDir . '/main'
  let g:qfixmemo_folding_pattern = '^=[^=]'
