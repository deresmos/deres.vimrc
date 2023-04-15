local border = {
      {"╭", "FloatBorder"},
      {"─", "FloatBorder"},
      {"╮", "FloatBorder"},
      {"│", "FloatBorder"},
      {"╯", "FloatBorder"},
      {"─", "FloatBorder"},
      {"╰", "FloatBorder"},
      {"│", "FloatBorder"},
}
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

--local lsp_status = require('lsp-status')
--lsp_status.config{
--  current_function = false,
--}
--lsp_status.register_progress()

-- local navic = require("nvim-navic")

local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<Space>mgd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
vim.keymap.set('n', '<Space>mgt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
-- vim.keymap.set('n', '<Space>mpd', '<cmd>lua require("lspsaga.provider").preview_definition()<CR>', opts)
-- vim.keymap.set('n', '<Space>mgi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
vim.keymap.set('n', '<Space>mh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
vim.keymap.set('n', '<Space>ms', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
vim.keymap.set('n', '<Space>mca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
vim.keymap.set('n', '<Space>mr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
vim.keymap.set('n', '<Space>mfr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
-- vim.keymap.set('n', '<Space>mf', '<cmd>lua require("lspsaga.provider").lsp_finder()<CR>', opts)
vim.keymap.set('n', '<Space>ek', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.keymap.set('n', '<Space>ej', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)

vim.keymap.set('n', '<Space>mic', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>', opts)
vim.keymap.set('n', '<Space>moc', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', opts)

vim.keymap.set('n', '<Space>m=', '<cmd>lua vim.lsp.buf.format({ timeout_ms = 2000 })<CR>', opts)

local float_border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
local on_attach = function (client, bufnr)
  -- local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  -- buf_set_keymap('n', '<Space>mgd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  -- buf_set_keymap('n', '<Space>mgt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  -- -- buf_set_keymap('n', '<Space>mpd', '<cmd>lua require("lspsaga.provider").preview_definition()<CR>', opts)
  -- -- buf_set_keymap('n', '<Space>mgi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  -- buf_set_keymap('n', '<Space>mh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  -- buf_set_keymap('n', '<Space>mca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- buf_set_keymap('n', '<Space>mr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- buf_set_keymap('n', '<Space>mfr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- -- buf_set_keymap('n', '<Space>mf', '<cmd>lua require("lspsaga.provider").lsp_finder()<CR>', opts)
  -- buf_set_keymap('n', '<Space>ek', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  -- buf_set_keymap('n', '<Space>ej', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  --
  -- buf_set_keymap('n', '<Space>mic', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>', opts)
  -- buf_set_keymap('n', '<Space>moc', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', opts)
  --
  -- -- not work?
  -- -- buf_set_keymap('n', '<C-f>', '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>', opts)
  -- -- buf_set_keymap('n', '<C-b>', '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(-1)<CR>', opts)

  -- navic.attach(client, bufnr)
  --lsp_status.on_attach(client, bufnr)
  require'lsp_signature'.on_attach({
    bind = true,
    doc_lines = 15,
    floating_window = true,
    fix_pos = true,
    hint_enable = true,
    hint_prefix = "> ",
    hint_scheme = "String",
    use_lspsaga = false,
    hi_parameter = "Search",
    max_height = 15,
    max_width = 120,
    handler_opts = {
      border = "rounded"
    },
    extra_trigger_chars = {}
  })
end

local comp = require('cmp_nvim_lsp')
local nvim_lsp = require('lspconfig')
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers {
  function (server_name)
    local opts = {
      on_attach = on_attach,
      capabilities = comp.default_capabilities(vim.lsp.protocol.make_client_capabilities()),
    }

    nvim_lsp[server_name].setup(opts)
  end,
  -- ["rust_analyzer"] = function ()
  --     require("rust-tools").setup {}
  -- end
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
 vim.lsp.diagnostic.on_publish_diagnostics, {
   virtual_text = true,
   signs = false,
 }
)
