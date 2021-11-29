  if system('uname') == "Linux\n"
    let g:openbrowser_browser_commands = [
      \ {"name": "firefox",
      \  "args": ["{browser}", "{uri}"]},
    \ ]
  endif
