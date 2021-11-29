  let g:lmap =  {} " {{{
  let g:lmap = {
  \   'f': {
  \     'name': 'file',
  \   },
  \   'q': {
  \     'name': 'quit and Qfreplace',
  \   },
  \   'd': {
  \     'name': 'denite',
  \   },
  \   'b': {
  \     'name': 'buffer',
  \   },
  \   'p': {
  \     'name': 'project and paste',
  \   },
  \   'y': {
  \     'name': 'yank',
  \   },
  \   't': {
  \     'name': 'tab, tags, terminal and toggle',
  \   },
  \   'w': {
  \     'name': 'window',
  \   },
  \   'g': {
  \     'name': 'git',
  \   },
  \   'v': {
  \     'name': 'fold',
  \   },
  \   's': {
  \     'name': 'session and SeachBuffers',
  \   },
  \   'h': {
  \     'name': 'howm',
  \   },
  \   'r': {
  \     'name': 'reset, replace, rename and record',
  \   },
  \   'j': {
  \     'name': 'etc',
  \   },
  \   'c': {
  \     'name': 'commenter',
  \   },
  \   'o': {
  \     'name': 'browser and markdown',
  \   },
  \   'm': {
  \     'name': 'mark and program',
  \   },
  \   'u': {
  \     'name': 'update and undo',
  \   },
  \   'a': {
  \     'name': 'align',
  \   },
  \   'e': {
  \     'name': 'linter',
  \   },
  \ }
  " }}}

  call leaderGuide#register_prefix_descriptions("<Space>", "g:lmap")
