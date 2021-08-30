lua << EOF
  local on_attach = function (client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', '<Space>mgd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', '<Space>mpd', '<cmd>lua require("lspsaga.provider").preview_definition()<CR>', opts)
    buf_set_keymap('n', '<Space>mgi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<Space>mh', '<cmd>lua require("lspsaga.hover").render_hover_doc()<CR>', opts)
    buf_set_keymap('n', '<Space>ca', '<cmd>lua require("lspsaga.code_action").code_action()<CR>', opts)
    buf_set_keymap('n', '<Space>mr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<Space>mf', '<cmd>lua require("lspsaga.provider").lsp_finder()<CR>', opts)
    buf_set_keymap('n', '<Space>ek', '<cmd>lua require"lspsaga.diagnostic".lsp_jump_diagnostic_prev()<CR>', opts)
    buf_set_keymap('n', '<Space>ej', '<cmd>lua require"lspsaga.diagnostic".lsp_jump_diagnostic_next()<CR>', opts)

    -- not work?
    buf_set_keymap('n', '<C-f>', '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>', opts)
    buf_set_keymap('n', '<C-b>', '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(-1)<CR>', opts)

    require'lsp_signature'.on_attach({
      bind = true,
      doc_lines = 10,
      floating_window = true,
      fix_pos = true,
      hint_enable = true,
      hint_prefix = "> ",
      hint_scheme = "String",
      use_lspsaga = false,
      hi_parameter = "Search",
      max_height = 12,
      max_width = 120,
      handler_opts = {
        border = "shadow"
      },
      extra_trigger_chars = {}
    })
  end

  local lsp_install = require("lspinstall")
  local nvim_lsp = require("lspconfig")

  lsp_install.setup()
  local servers = lsp_install.installed_servers()
  for _, server in pairs(servers) do
    nvim_lsp[server].setup{ on_attach = on_attach }
  end

  __definition = vim.lsp.handlers["textDocument/definition"]

  lsp_handlers = {}
  lsp_handlers.location_vsplit = function(...)
    vim.cmd("vsplit")
    __definition(...)
  end
  -- vim.lsp.handlers["textDocument/definition"] = lsp_handlers.location_vsplit

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
   vim.lsp.diagnostic.on_publish_diagnostics, {
     virtual_text = false,
     signs = false,
   }
  )

EOF
