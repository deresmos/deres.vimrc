function HowmEditDiary(filename)
  vim.cmd("tabnew")
  vim.api.nvim_call_function("qfixmemo#EditDiary", { filename })
end

-- function pullHowm()
--   vim.cmd("AsyncRun -cwd=" .. vim.g.QFixHowm_RootDir .. " git pull origin master")
-- end
--
-- function pushHowm()
--   vim.cmd("AsyncRun -cwd=" .. vim.g.QFixHowm_RootDir .. " git add . && git commit -m 'commit' && git push origin master")
-- end

function QFixMemoBufRead()
  vim.api.nvim_buf_set_option(0, "foldenable", true)
end

vim.keymap.set("n", "<SPACE>hc", ":<C-u>call qfixmemo#Calendar()<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<SPACE>hm", ":<C-u>lua HowmEditDiary('memo')<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<SPACE>hs", ":<C-u>lua HowmEditDiary('schedule')<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<SPACE>ht", ":<C-u>lua HowmEditDiary(vim.g.qfixmemo_diary)<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<SPACE>hf", ":<C-u>lua HowmEditDiary('filetype/' .. vim.bo.filetype)<CR>",
  { silent = true, noremap = true })
vim.keymap.set("n", "<SPACE>ho", ":<C-u>lua HowmEditDiary('memo/'..vim.fn.input('Name: '))<CR>",
  { silent = true, noremap = true })
-- vim.keymap.set("n", "<SPACE>hlo", ":Denite file -path=`" .. vim.g.howm_dir .. "/memo`<CR>", {silent=true, noremap=true})
vim.keymap.set("n", "<SPACE>hg", ":<C-u>call qfixmemo#FGrep()<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<SPACE>ha", ":<C-u>call qfixmemo#PairFile('%')<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<SPACE>hid", ":<C-u>call qfixmemo#InsertDate('date')<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<SPACE>hit", ":<C-u>call qfixmemo#InsertDate('time')<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<SPACE>hlr", ":<C-u>call qfixmemo#ListMru()<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<SPACE>hlt", ":<C-u>call qfixmemo#ListReminder('todo')<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<SPACE>hls", ":<C-u>call qfixmemo#ListReminder('schedule')<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<SPACE>hlc", ":<C-u>call qfixmemo#ListFile(vim.g.qfixmemo_diary)<CR>",
  { silent = true, noremap = true })

vim.keymap.set('n', '<SPACE>hlf', ':<C-u>call qfixmemo#ListFile("filetype/*")<CR>', { silent = true })
vim.keymap.set('n', '<SPACE>hlw', ':<C-u>call qfixmemo#ListFile("wiki/*")<CR>', { silent = true })
vim.keymap.set('n', '<SPACE>hll', ':<C-u>call qfixmemo#ListRecentTimeStamp()<CR>', { silent = true })

function HowmDir(dir)
  vim.g.howm_dir = vim.g.QFixHowm_RootDir .. '/' .. dir
  print('Switched ' .. dir)
end

vim.cmd('command! -nargs=1 HowmDir lua HowmDir(<q-args>)')
vim.keymap.set('n', '<SPACE>hpw', ':<C-u>HowmDir work<CR>', { silent = true })
vim.keymap.set('n', '<SPACE>hpm', ':<C-u>HowmDir main<CR>', { silent = true })
-- vim.keymap.set('n', '<SPACE>hpl', ':<C-u>lua require("<SID>").pullHowm()<CR>', { silent = true })
-- vim.keymap.set('n', '<SPACE>hps', ':<C-u>lua require("<SID>").pushHowm()<CR>', { silent = true })

vim.g.QFixHowm_MenuKey = 0
vim.g.QFixHowm_Key = '<Nop>'
vim.g.howm_fileencoding = 'utf-8'
vim.g.howm_fileformat = 'unix'
vim.g.qfixmemo_diary = '%Y/%m/%Y-%m-%d'
vim.g.QFixHowm_CalendarWinCmd = 'rightbelow'
vim.g.QFixHowm_CalendarCount = 3
vim.g.QFixHowm_FileType = 'qfix_memo'
vim.g.qfixmemo_template = { '%TITLE% ' }
vim.g.qfixmemo_use_addtime = 0
vim.g.qfixmemo_use_updatetime = 0
vim.g.QFixHowm_SaveTime = -1
vim.g.QFixHowm_Wiki = 1
vim.g.QFixHowm_WikiDir = 'wiki'
vim.g.QFixHowm_Menufile = 'menu.howm'
vim.g.QFixHowm_MenuCloseOnJump = 1
vim.g.QFixHowm_RootDir = '~/.howm'
vim.g.howm_dir = vim.g.QFixHowm_RootDir .. '/main'
vim.g.qfixmemo_folding_pattern = '^=[^=]'
