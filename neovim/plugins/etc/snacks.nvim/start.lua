-- Finder keymaps backed by Snacks.picker.

local finder = require('my.finder_snacks')
SnacksFinder = finder

vim.keymap.set('n', '<Space>ff', finder.files, { silent = true, noremap = true, desc = 'files' })
vim.keymap.set('n', '<Space>bf', finder.files_from_buffer, { silent = true, noremap = true, desc = 'files from buffer' })
vim.keymap.set('n', '<Space>pf', finder.files_from_project, { silent = true, noremap = true, desc = 'files from project' })
vim.keymap.set('n', '<Space>fr', finder.oldfiles, { silent = true, noremap = true, desc = 'recent files' })

vim.keymap.set('n', '<Space>bb', finder.buffers, { silent = true, noremap = true, desc = 'buffers' })

vim.keymap.set('n', '<Space>fg', finder.grep, { silent = true, noremap = true, desc = 'grep' })
vim.keymap.set('n', '<Space>fG', finder.grep_word, { silent = true, noremap = true, desc = 'grep word' })
vim.keymap.set('n', '<Space>bg', finder.grep_from_buffer, { silent = true, noremap = true, desc = 'grep from buffer' })
vim.keymap.set('n', '<Space>bG', finder.grep_word_from_buffer, { silent = true, noremap = true, desc = 'grep word from buffer' })
vim.keymap.set('n', '<Space>pg', finder.grep_from_project, { silent = true, noremap = true, desc = 'grep from project' })
vim.keymap.set('n', '<Space>pG', finder.grep_word_from_project, { silent = true, noremap = true, desc = 'grep word from project' })
vim.keymap.set('n', '<Space>fl', finder.resume, { silent = true, noremap = true, desc = 'resume last picker' })
vim.keymap.set('n', '<Space>fh', finder.history, { silent = true, noremap = true, desc = 'picker history' })

vim.keymap.set('n', '<Space>fb', finder.file_browser, { silent = true, noremap = true, desc = 'file browser' })
vim.keymap.set('n', '<Space>fB', finder.file_browser_from_buffer, { silent = true, noremap = true, desc = 'file browser from buffer dir' })
vim.keymap.set('n', '<Space>pb', finder.file_browser_from_project, { silent = true, noremap = true, desc = 'file browser from project root' })

vim.keymap.set('n', '<Space>sl', finder.sessions, { silent = true, noremap = true, desc = 'sessions' })
vim.keymap.set('n', '<Space>hlo', finder.memos, { silent = true, noremap = true, desc = 'memos' })
vim.keymap.set('n', '<Space>nc', finder.registers, { silent = true, noremap = true, desc = 'registers' })

vim.keymap.set('n', '<Space>dgs', finder.git_status, { silent = true, noremap = true, desc = 'git status' })
vim.keymap.set('n', '<Space>dgc', finder.git_log, { silent = true, noremap = true, desc = 'git log' })
vim.keymap.set('n', '<Space>dgC', finder.git_bcommits, { silent = true, noremap = true, desc = 'git log for current file' })
vim.keymap.set('n', '<Space>dgb', finder.git_branches, { silent = true, noremap = true, desc = 'git branches' })

vim.keymap.set('n', '<Space>mgd', finder.lsp_definitions, { silent = true, noremap = true, desc = 'lsp definitions' })
vim.keymap.set('n', '<Space>mgt', finder.lsp_type_definitions, { silent = true, noremap = true, desc = 'lsp type definitions' })
vim.keymap.set('n', '<Space>mfr', finder.lsp_references, { silent = true, noremap = true, desc = 'lsp references' })
vim.keymap.set('n', '<Space>mgi', finder.lsp_implementations, { silent = true, noremap = true, desc = 'lsp implementations' })
vim.keymap.set('n', '<Space>mic', finder.lsp_incoming_calls, { silent = true, noremap = true, desc = 'lsp incoming calls' })
vim.keymap.set('n', '<Space>moc', finder.lsp_outgoing_calls, { silent = true, noremap = true, desc = 'lsp outgoing calls' })
vim.keymap.set('n', '<Space>mfs', finder.lsp_document_symbols, { silent = true, noremap = true, desc = 'lsp document symbols' })
vim.keymap.set('n', '<Space>mdl', finder.diagnostics, { silent = true, noremap = true, desc = 'diagnostics' })
vim.keymap.set('n', '<Space>mdB', finder.diagnostics_buffer, { silent = true, noremap = true, desc = 'buffer diagnostics' })
vim.keymap.set('n', '<Space>mdL', finder.diagnostics_error, { silent = true, noremap = true, desc = 'errors and warnings' })
