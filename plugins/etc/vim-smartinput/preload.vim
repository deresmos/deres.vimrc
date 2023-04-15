  call smartinput#define_rule({
  \   'at'       : '^\s*\%(\<def\>\|\<if\>\|\<for\>\|\<while\>\|\<class\>\|\<with\>\)\s*\w\+.*\%#',
  \   'char'     : '(',
  \   'input'    : '():<Left><Left>',
  \   'filetype' : ['python'],
  \   })
  call smartinput#define_rule({
  \   'at'       : '^\s*\%(\<def\>\|\<if\>\|\<for\>\|\<while\>\|\<class\>\|\<with\>\)\s*\w\+.*\%#.*:',
  \   'char'     : '(',
  \   'input'    : '()<Left>',
  \   'filetype' : ['python'],
  \   })
