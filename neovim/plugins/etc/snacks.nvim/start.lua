-- Test keymaps for comparing snacks.nvim's picker against the telescope
-- pickers wired up in neovim/plugins/finder/telescope.nvim/start.lua.
--
-- These are deliberately kept on a separate <Space>z prefix so they don't
-- collide with (or replace) the existing telescope <Space>f/b/d.../mappings.
-- Once snacks.nvim is confirmed to cover what we need, these can be merged
-- into lua/my/finder.lua and the telescope mappings removed.

local finder = require('my.finder_snacks')
SnacksFinder = finder

vim.keymap.set('n', '<Space>zf', finder.files, { silent = true, noremap = true, desc = 'snacks: files' })
vim.keymap.set('n', '<Space>zF', finder.files_from_buffer, { silent = true, noremap = true, desc = 'snacks: files from buffer' })
vim.keymap.set('n', '<Space>zp', finder.files_from_project, { silent = true, noremap = true, desc = 'snacks: files from project' })
vim.keymap.set('n', '<Space>zr', finder.oldfiles, { silent = true, noremap = true, desc = 'snacks: recent files' })

vim.keymap.set('n', '<Space>zb', finder.buffers, { silent = true, noremap = true, desc = 'snacks: buffers' })

vim.keymap.set('n', '<Space>zg', finder.grep, { silent = true, noremap = true, desc = 'snacks: grep' })
vim.keymap.set('n', '<Space>zG', finder.grep_from_buffer, { silent = true, noremap = true, desc = 'snacks: grep from buffer' })
vim.keymap.set('n', '<Space>zw', finder.grep_word, { silent = true, noremap = true, desc = 'snacks: grep word under cursor' })
vim.keymap.set('n', '<Space>zl', finder.resume, { silent = true, noremap = true, desc = 'snacks: resume last picker' })

vim.keymap.set('n', '<Space>ze', finder.file_browser, { silent = true, noremap = true, desc = 'snacks: file browser (flat, non-tree)' })
vim.keymap.set('n', '<Space>zE', finder.file_browser_from_buffer, { silent = true, noremap = true, desc = 'snacks: file browser from buffer dir' })
vim.keymap.set('n', '<Space>zP', finder.file_browser_from_project, { silent = true, noremap = true, desc = 'snacks: file browser from project root' })

vim.keymap.set('n', '<Space>zsl', finder.sessions, { silent = true, noremap = true, desc = 'snacks: sessions' })

vim.keymap.set('n', '<Space>zdgs', finder.git_status, { silent = true, noremap = true, desc = 'snacks: git status' })
vim.keymap.set('n', '<Space>zdgc', finder.git_log, { silent = true, noremap = true, desc = 'snacks: git log' })
vim.keymap.set('n', '<Space>zdgb', finder.git_branches, { silent = true, noremap = true, desc = 'snacks: git branches' })

vim.keymap.set('n', '<Space>zmgd', finder.lsp_definitions, { silent = true, noremap = true, desc = 'snacks: lsp definitions' })
vim.keymap.set('n', '<Space>zmfr', finder.lsp_references, { silent = true, noremap = true, desc = 'snacks: lsp references' })
vim.keymap.set('n', '<Space>zmgi', finder.lsp_implementations, { silent = true, noremap = true, desc = 'snacks: lsp implementations' })
vim.keymap.set('n', '<Space>zmfs', finder.lsp_document_symbols, { silent = true, noremap = true, desc = 'snacks: lsp document symbols' })
vim.keymap.set('n', '<Space>zmdl', finder.diagnostics, { silent = true, noremap = true, desc = 'snacks: diagnostics' })
