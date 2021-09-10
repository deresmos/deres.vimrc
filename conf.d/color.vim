function! MyHighlights()
  if g:colors_name ==# 'hybrid'
    highlight Search           ctermfg=197  ctermbg=none cterm=bold,underline
    highlight IncSearch        ctermfg=197  ctermbg=235  cterm=bold,underline
  endif

  " highlight Folded           ctermfg=34   ctermbg=235  cterm=bold
  " highlight LineNr           ctermfg=242  ctermbg=235
  " highlight CursorLineNr     ctermfg=221  ctermbg=235
  " highlight TagbarSignature  ctermfg=none ctermfg=251
  " highlight ZenSpace         ctermfg=none ctermbg=203
  " highlight DeniteCursorLine ctermfg=none ctermbg=237
  " highlight String           ctermfg=108  ctermbg=none
  " highlight Function         ctermfg=73   ctermbg=none
  " highlight Conditional      ctermfg=197  ctermbg=none
  " highlight Number           ctermfg=166  ctermbg=none
  " highlight Boolean          ctermfg=197  ctermbg=none
  " highlight Statement        ctermfg=173  ctermbg=none
  " highlight vimHighlight     ctermfg=166  ctermbg=none
  " highlight VertSplit        ctermfg=244  ctermbg=none
  " highlight IndentGuidesOdd  ctermbg=236
  highlight NormalFloat      ctermfg=none ctermbg=233

  highlight TabLineSel guifg=none guibg=#1e2142 gui=bold
  highlight TabLine guifg=none guibg=#2f3137
  highlight TablineLast guifg=#9a9ca5 guibg=#161821

  " Left
  highlight DiffLeftChange       ctermfg=none ctermbg=52 guifg=none guibg=#400000
  highlight DiffLeftText         ctermfg=none ctermbg=52 guifg=none    guibg=#400000
  highlight DiffLeftAdd          ctermfg=none ctermbg=52 guifg=none guibg=#400000
  highlight DiffLeftDelete       ctermfg=236  ctermbg=236 guifg=#161831 guibg=#161831

  " Right
  highlight DiffRightChange       ctermfg=none ctermbg=22 guifg=none guibg=#001000
  highlight DiffRightText         ctermfg=none ctermbg=22 guifg=none guibg=#004000
  highlight DiffRightAdd          ctermfg=none ctermbg=22 guifg=none guibg=#004000
  highlight DiffRightDelete       ctermfg=236  ctermbg=236 guifg=#161831 guibg=#161831

  " Normal
  highlight DiffChange ctermfg=none ctermbg=none guifg=none    guibg=none
  highlight DiffText   ctermfg=none ctermbg=28   guifg=none    guibg=#004000
  highlight DiffAdd    ctermfg=none ctermbg=28   guifg=none    guibg=#004000
  highlight DiffDelete ctermfg=52   ctermbg=52   guifg=#400000 guibg=#400000

  highlight GitGutterAdd    ctermfg=none ctermbg=22 guifg=#008000 guibg=#1e2132
  highlight GitGutterChange ctermfg=none ctermbg=53 guifg=#808000 guibg=#1e2132
  highlight GitGutterDelete ctermfg=52   ctermbg=52 guifg=#800000 guibg=#1e2132

  highlight GitAddText    ctermfg=none ctermbg=none guifg=#00e000 guibg=#2c323d
  highlight GitChangeText ctermfg=none ctermbg=none guifg=#e0e000 guibg=#2c323d
  highlight GitDeleteText ctermfg=52   ctermbg=none guifg=#e00000 guibg=#2c323d

  highlight link ALEVirtualTextError WarningMsg
  highlight link ALEVirtualTextInfo WarningMsg
  highlight link ALEVirtualTextStyleError WarningMsg
  highlight link ALEVirtualTextStyleWarning WarningMsg
  highlight link ALEVirtualTextWarning WarningMsg

  highlight LspDiagnosticsUnderlineError       guifg=none guibg=#800000
  highlight LspDiagnosticsUnderlineWarning     guifg=none guibg=#808000
  highlight LspDiagnosticsUnderlineInformation guifg=none guibg=#008000
  highlight LspDiagnosticsUnderlineHint        guifg=none

  highlight HopNextKey guifg=none guibg=#800000
endfunction

augroup MyHighlight
  autocmd!
  autocmd ColorScheme * call MyHighlights()
augroup END
