lua << EOF
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

  local lsp_status = require('lsp-status')
  lsp_status.register_progress()

  float_border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
  local on_attach = function (client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', '<Space>mgd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    -- buf_set_keymap('n', '<Space>mpd', '<cmd>lua require("lspsaga.provider").preview_definition()<CR>', opts)
    buf_set_keymap('n', '<Space>mgi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<Space>mh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<Space>mca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', '<Space>mr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    -- buf_set_keymap('n', '<Space>mf', '<cmd>lua require("lspsaga.provider").lsp_finder()<CR>', opts)
    buf_set_keymap('n', '<Space>ek', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', '<Space>ej', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)

    buf_set_keymap('n', '<Space>mic', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>', opts)
    buf_set_keymap('n', '<Space>moc', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', opts)

    -- not work?
    -- buf_set_keymap('n', '<C-f>', '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>', opts)
    -- buf_set_keymap('n', '<C-b>', '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(-1)<CR>', opts)

    lsp_status.on_attach(client, bufnr)
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
        border = "rounded"
      },
      extra_trigger_chars = {}
    })
  end

  local lsp_installer = require("nvim-lsp-installer")
  local comp = require('cmp_nvim_lsp')

  lsp_installer.on_server_ready(function(server)
    local opts = {
      on_attach = on_attach,
      capabilities = comp.update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    }

    server:setup(opts)
  end)

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
   vim.lsp.diagnostic.on_publish_diagnostics, {
     virtual_text = true,
     signs = false,
   }
  )
EOF
