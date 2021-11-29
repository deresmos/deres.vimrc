nmap R <Nop>
nmap R <Plug>(operator-replace)
xmap R <Nop>
xmap R <Plug>(operator-replace)
nmap s <Nop>
xmap s <Nop>

nmap <silent>sa <Plug>(operator-surround-append)
nmap <silent>sd <Plug>(operator-surround-delete)
nmap <silent>sr <Plug>(operator-surround-replace)
nmap <silent>sc <Plug>(operator-camelize)gv
nmap <silent>sC <Plug>(operator-decamelize)gv
nmap <silent>se <Plug>(operator-html-escape)
nmap <silent>sE <Plug>(operator-html-unescape)

xmap <silent>sa <Plug>(operator-surround-append)
xmap <silent>sd <Plug>(operator-surround-delete)
xmap <silent>sr <Plug>(operator-surround-replace)
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
