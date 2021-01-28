call denite#custom#option('default', 'prompt', '>')

" menus {{{1
let s:menus = {}
let s:menus.dein = {'description': 'Dein menu'}
let s:_dein_commands = [
  \ ['Dein: Update plugins', 'call dein#update()'],
  \ ['Dein: Recache RuntimePath', 'call dein#recache_runtimepath()'],
  \ ['Dein: Clear state', 'call dein#clear_state()']
  \ ]
let s:menus.dein.command_candidates = s:_dein_commands

let s:menus.all = {'description': 'All commands'}
let s:menus.all.command_candidates = []
  \ + s:_dein_commands

call denite#custom#var('menu', 'menus', s:menus)

" custom mapping {{{1
call denite#custom#map(
  \ 'normal',
  \ 'gj',
  \ '<denite:jump_to_next_by:path>',
  \ 'noremap')

call denite#custom#map(
  \ 'normal',
  \ 'gk',
  \ '<denite:jump_to_previous_by:path>',
  \ 'noremap')

call denite#custom#map(
  \ 'insert',
  \ '<C-n>',
  \ '../',
  \ 'noremap')

" custom color {{{1
call denite#custom#option('default', 'highlight_matched_char', 'Search')
call denite#custom#option('default', 'highlight_mode_insert', 'DeniteCursorLine')
call denite#custom#option('default', 'highlight_mode_normal', 'DeniteCursorLine')
call denite#custom#option('default', 'mode', 'normal')

" custom command {{{1
if executable('rg')
  call SwitchGrepCommand('rg')
elseif executable('pt')
  call SwitchGrepCommand('pt')
endif

call SwitchMatherFuzzy()

call denite#custom#source('file/rec', 'matchers',
  \ ['matcher_fuzzy', 'matcher_ignore_globs'])
call denite#custom#source('file', 'matchers',
  \ ['matcher_fuzzy', 'matcher_ignore_globs'])

call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
  \ [ '*~', '*.o', '*.exe', '*.bak',
  \ '.DS_Store', '*.pyc', '*.sw[po]',
  \ '.hg/', '.git/', '.bzr/', '.svn/',
  \ 'node_modules/', 'bower_components/', 'vendor/ruby',
  \ '.mypy_cache/',
  \ '.idea/', '.tags'])

" https://qiita.com/hrsh7th@github/items/303d46ba13532c502828 {{{1
function! DeniteQfreplace(context)
  let qflist = []
  for target in a:context['targets']
    call add(qflist, {
      \ 'filename': target['action__path'],
      \ 'lnum': target['action__line'],
      \ 'text': target['word'],
    \ })
  endfor

  call setqflist(qflist)
  call qfreplace#start('tabnew')
endfunction

call denite#custom#action('file', 'qfreplace', function('DeniteQfreplace'))
