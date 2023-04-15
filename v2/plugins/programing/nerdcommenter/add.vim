let g:NERDCommentEmptyLines      = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDSpaceDelims            = 1
let g:NERDCompactSexyComs        = 1
let g:NERDDefaultAlign           = 'left'

let g:NERDCustomDelimiters = {
    \ 'wsh': { 'left': "'" },
\ }

map <SPACE>cn <plug>NERDCommenterNested
map <SPACE>cy <plug>NERDCommenterYank
map <SPACE>cm <plug>NERDCommenterMinimal
map <SPACE>cc <plug>NERDCommenterToggle
map <SPACE>cs <plug>NERDCommenterSexy
map <SPACE>ci <plug>NERDCommenterToEOL
map <SPACE>cA <plug>NERDCommenterAppend
map <SPACE>cx <plug>NERDCommenterAltDelims
