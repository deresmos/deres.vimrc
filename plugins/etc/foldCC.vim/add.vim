  set foldtext=FoldCCtext()
  let g:foldCCtext_maxchars = 79
  let g:foldCCtext_head     = 'v:folddashes . " "'
  let g:foldCCtext_tail     = 'printf(" %s [ %4d lines ]",
    \ v:folddashes, v:foldend-v:foldstart+1)'
  let g:foldCCnavi_maxchars = 60
