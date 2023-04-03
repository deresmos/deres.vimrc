nmap <silent>sc <Plug>(operator-camelize)gv
nmap <silent>sC <Plug>(operator-decamelize)gv
nmap <silent>se <Plug>(operator-html-escape)
nmap <silent>sE <Plug>(operator-html-unescape)

xmap <silent>sc <Plug>(operator-camelize)gv
xmap <silent>sC <Plug>(operator-decamelize)gv
xmap <silent>se <Plug>(operator-html-escape)
xmap <silent>sE <Plug>(operator-html-unescape)

let g:operator#surround#blocks = {
  \ '-' : [
  \ {'block' : ['(', ')'],
  \ 'motionwise' : ['char', 'line', 'block'], 'keys' : ['b'] },
  \ {'block' : ['{', '}'],
  \ 'motionwise' : ['char', 'line', 'block'], 'keys' : ['B'] },
  \ {'block' : ["'", "'"],
  \ 'motionwise' : ['char', 'line', 'block'], 'keys' : ['q'] },
  \ {'block' : ['"', '"'],
  \ 'motionwise' : ['char', 'line', 'block'], 'keys' : ['Q'] }
  \ ]}
