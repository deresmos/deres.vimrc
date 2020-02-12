function! MyHighlights()
  if g:colors_name ==# 'hybrid'
    highlight Search           ctermfg=197  ctermbg=none cterm=bold,underline
    highlight IncSearch        ctermfg=197  ctermbg=235  cterm=bold,underline
  endif

  highlight Folded           ctermfg=34   ctermbg=235  cterm=bold
  highlight LineNr           ctermfg=242  ctermbg=235
  highlight CursorLineNr     ctermfg=221  ctermbg=235
  highlight TagbarSignature  ctermfg=none ctermfg=251
  highlight ZenSpace         ctermfg=none ctermbg=203
  highlight DeniteCursorLine ctermfg=none ctermbg=237
  highlight String           ctermfg=108  ctermbg=none
  highlight Function         ctermfg=73   ctermbg=none
  highlight Conditional      ctermfg=197  ctermbg=none
  highlight Number           ctermfg=166  ctermbg=none
  highlight Boolean          ctermfg=197  ctermbg=none
  highlight Statement        ctermfg=173  ctermbg=none
  highlight vimHighlight     ctermfg=166  ctermbg=none
  highlight VertSplit        ctermfg=244  ctermbg=none
  highlight IndentGuidesOdd  ctermbg=236
  highlight NormalFloat      ctermfg=none ctermbg=233

  " Left
  highlight DiffLeftChange       ctermfg=none ctermbg=52
  highlight DiffLeftText         ctermfg=none ctermbg=52
  highlight DiffLeftAdd          ctermfg=none ctermbg=52
  highlight DiffLeftDelete       ctermfg=236  ctermbg=236

  " Right
  highlight DiffRightChange       ctermfg=none ctermbg=22
  highlight DiffRightText         ctermfg=none ctermbg=22
  highlight DiffRightAdd          ctermfg=none ctermbg=22
  highlight DiffRightDelete       ctermfg=236  ctermbg=236

  " Normal
  highlight DiffChange       ctermfg=none ctermbg=none
  highlight DiffText         ctermfg=none ctermbg=28
  highlight DiffAdd          ctermfg=none ctermbg=28
  highlight DiffDelete       ctermfg=52   ctermbg=52

  highlight GitGutterAddLine    ctermfg=none ctermbg=22
  highlight GitGutterChangeLine ctermfg=none ctermbg=53
  highlight GitGutterDeleteLine ctermfg=52   ctermbg=52

  highlight link ALEVirtualTextError WarningMsg
  highlight link ALEVirtualTextInfo WarningMsg
  highlight link ALEVirtualTextStyleError WarningMsg
  highlight link ALEVirtualTextStyleWarning WarningMsg
  highlight link ALEVirtualTextWarning WarningMsg
endfunction

augroup MyHighlight
  autocmd!
  autocmd ColorScheme * call MyHighlights()
augroup END
