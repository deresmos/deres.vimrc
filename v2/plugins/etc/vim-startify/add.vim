let g:startify_disable_at_vimenter = 1
let g:startify_files_number = 10
let g:startify_custom_indices = ['a', 'b', 'c', 'd', 'f', 'g', 'i', 'm',
  \ 'n', 'o', 'p', 'r', 's', 't', 'u', 'v', 'w', 'x', 'z']
let g:startify_list_order = [
  \ ['Bookmarks:'],
  \ 'bookmarks',
  \ ['Recentry open files:'],
  \ 'files',
  \ ['Recentry open files in dir:'],
  \ 'dir',
  \ ]

let g:startify_session_sort = 0
let g:startify_session_persistence = 0
let g:startify_session_savevars = [
  \ ]

let g:startify_session_before_save = [
  \ 'echo "Cleaning up before saving..."',
  \ 'silent! call CloseUnloadedBuffers()',
  \ 'silent! bd __XtermColorTable__',
  \ ]

let g:startify_custom_header = [
\"        _                                   _            ",
\"     __| |  ___  _ __   ___  ___    __   __(_) _ __ ___  ",
\"    / _` | / _ \\| '__| / _ \\/ __|   \\ \\ / /| || '_ ` _ \\ ",
\"   | (_| ||  __/| |   |  __/\\__ \\ _  \\ V / | || | | | | |",
\"    \\__,_| \\___||_|    \\___||___/(_)  \\_/  |_||_| |_| |_|",
\ ]
let g:startify_change_to_dir = 1
