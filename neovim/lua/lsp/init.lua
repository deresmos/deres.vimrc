local border = {
  { "╭", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╮", "FloatBorder" },
  { "│", "FloatBorder" },
  { "╯", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╰", "FloatBorder" },
  { "│", "FloatBorder" },
}
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.go' },
  group = vim.api.nvim_create_augroup("my-formatting", {}),
  callback = function()
    vim.lsp.buf.format({ async = false })
  end
})

local lsp_status = require('lsp-status')
lsp_status.config {
  current_function = false,
}
lsp_status.register_progress()

local opts = { noremap = true, silent = true }
--vim.keymap.set('n', '<Space>mgd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
--vim.keymap.set('n', '<Space>mgt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
-- vim.keymap.set('n', '<Space>mpd', '<cmd>lua require("lspsaga.provider").preview_definition()<CR>', opts)
-- vim.keymap.set('n', '<Space>mgi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
vim.keymap.set('n', '<Space>mh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
vim.keymap.set('n', '<Space>ms', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
-- vim.keymap.set('n', '<Space>mca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
vim.keymap.set('n', '<Space>mr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
-- vim.keymap.set('n', '<Space>mfr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
-- vim.keymap.set('n', '<Space>mf', '<cmd>lua require("lspsaga.provider").lsp_finder()<CR>', opts)
vim.keymap.set('n', '<Space>ek', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.keymap.set('n', '<Space>ej', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)

-- vim.keymap.set('n', '<Space>mic', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>', opts)
-- vim.keymap.set('n', '<Space>moc', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', opts)

vim.keymap.set('n', '<Space>m=', '<cmd>lua vim.lsp.buf.format({ timeout_ms = 2000 })<CR>', opts)

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = false,
  }
)

vim.lsp.config('*', {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})
