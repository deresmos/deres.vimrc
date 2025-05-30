vim.g.is_windows_os = vim.fn.has('win64') or vim.fn.has('win32')

-- vimディレクトリの取得
if vim.g.is_windows_os == 1 then
  vim.g.vim_dir = os.getenv("LOCALAPPDATA") .. "/.vim"
  vim.g.nvim_dir = os.getenv("LOCALAPPDATA") .. "/nvim"
else
  vim.g.vim_dir = os.getenv("HOME") .. "/.vim"
  vim.g.nvim_dir = "~/.config/nvim"
end

-- その他のディレクトリの設定
vim.g.undo_dir = vim.g.vim_dir .. "/undo"
vim.g.view_dir = vim.g.vim_dir .. "/view"
vim.g.startify_session_dir = vim.g.vim_dir .. "/session"

require "plugins"


vim.cmd('source ' .. vim.g.nvim_dir .. '/vimrc')

local vim_conf_path = vim.fn.expand('$HOME/.config/nvim')
if vim.fn.filereadable(vim_conf_path .. '/custom.vim') == 1 then
  vim.cmd('source ' .. vim_conf_path .. '/custom.vim')
end

local augroup = {
  highlighted_yank = 'highlighted-yank',
  custom_filetype = 'custom-filetype',
}

-- init.vim
vim.api.nvim_create_augroup(augroup.highlighted_yank, {})
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup.highlighted_yank,
  callback = function() vim.highlight.on_yank({ higroup = "Search", timeout = 500 }) end
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup(augroup.custom_filetype, {}),
  pattern = { "qf,help,qfreplace,diff" },
  callback = function()
    vim.bo.bufhidden = "wipe"
    vim.keymap.set("n", "q", [[<Cmd>quit<CR>]], { nowait = true, buffer = true })
  end,
})

local function sourcePlugins()
  local packer_path = vim.fn.stdpath("config") .. "/lua/plugins.lua"
  vim.cmd("source " .. packer_path)
end

local function packerCompile()
  sourcePlugins()
  -- vim.cmd("PackerCompile")
end

local function packerSync()
  sourcePlugins()
  -- vim.cmd("PackerSync")
end

vim.keymap.set('n', '<Space>uP', packerSync, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>up', packerCompile, { silent = true, noremap = true })

-- autocmd User PackerComplete quitall

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("packer-setting", {}),
  pattern = "PackerCompileDone",
  callback = function()
    vim.notify("[packer] Compiled.")
  end,
})


-- vimrc

vim.cmd('filetype plugin indent on')
if vim.fn.exists('+termguicolors') then
  vim.opt.termguicolors = true
end

-- vim.opt.guicursor = {
--   "n-v-c:block",
--   "i-ci-ve:ver25",
--   "r-cr:hor20,o:hor50",
--   "a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor",
--   "sm:block-blinkwait175-blinkoff150-blinkon175"
-- }
vim.opt.scrollback = 100000

vim.keymap.set('n', '<Space>qr', ':<C-u>Qfreplace tabnew<CR>', { silent = true, noremap = true })
vim.keymap.set('x', '<Space>ld', ':Linediff<CR>', { silent = true, noremap = true })
vim.keymap.set('n', '<Space>bo', '<cmd>BufOnly<CR>', { silent = true, noremap = true })
vim.keymap.set('n', '<Space>bu', ':<C-u>call CloseUnloadedBuffers()<CR>', { silent = true, noremap = true })
vim.keymap.set('n', '<Space>bl', ':<C-u>BuffergatorToggle<CR>', { silent = true, noremap = true })

for i = 1, 9 do
  vim.keymap.set('n', string.format('<Space>t%d', i), string.format(':<C-u>tabnext%d<CR>', i),
    { silent = true, noremap = true })
end

vim.keymap.set('n', '[TNumber]', '<Nop>', { silent = true, noremap = true })
vim.keymap.set('n', '<Space>tn', '[TNumber]', { silent = true, noremap = true })
vim.keymap.set('n', '[TNumber]n', '<cmd>set number!<CR>', { silent = true, noremap = true })
vim.keymap.set('n', '[TNumber]r', '<cmd>set relativenumber!<CR>', { silent = true, noremap = true })

vim.keymap.set('n', '<Space>tsl', ':<C-u>setlocal list!<CR>', { silent = true, noremap = true })

vim.keymap.set('n', 'q', '<Nop>', { silent = true, noremap = true })
vim.keymap.set('x', 'q', '<Nop>', { silent = true, noremap = true })
vim.keymap.set('n', '<Space>rc', 'q', { silent = true, noremap = true })

vim.keymap.set('n', '<Space>cd', ':<C-u>lcd %:h<CR>:echo \'Change dir: \' . expand(\'%:p:h\')<CR>',
  { silent = true, noremap = true })


local function closeUnloadedBuffers()
  local last_buffer = vim.fn.bufnr('$')
  local delete_count = 0

  for n = 1, last_buffer do
    if vim.fn.buflisted(n) and not vim.fn.bufloaded(n) then
      vim.cmd("silent execute 'bdelete! ' .. " .. n)
      delete_count = delete_count + 1
    end
  end

  local single = ' buffer deleted'
  local multi = ' buffers deleted'
  print(delete_count .. (delete_count <= 1 and single or multi))
end

vim.keymap.set('n', '<Space>bQ', closeUnloadedBuffers, { silent = true, noremap = true })


vim.opt.fillchars = {
  fold = ' ',
  diff = '╱',
  wbr = '─',
  msgsep = '─',
  horiz = ' ',
  horizup = '│',
  horizdown = '│',
  vertright = '│',
  vertleft = '│',
  verthoriz = '│',
}

require("lsp")
