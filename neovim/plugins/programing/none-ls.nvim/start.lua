local null_ls = require("null-ls")

null_ls.setup({
  diagnostics_format = "#{m} (#{s}: #{c})",
  sources = {
    -- null_ls.builtins.formatting.gofmt,
    null_ls.builtins.diagnostics.golangci_lint,
    -- null_ls.builtins.diagnostics.staticcheck,

    null_ls.builtins.diagnostics.textlint,

    -- null_ls.builtins.formatting.jq,

    -- null_ls.builtins.diagnostics.terraform_validate,
    null_ls.builtins.formatting.terraform_fmt,

    -- null_ls.builtins.diagnostics.cspell.with({
    --   diagnostics_postprocess = function(diagnostic)
    --     diagnostic.severity = vim.diagnostic.severity.WARN
    --   end,
    --   condition = function()
    --     return vim.fn.executable('cspell') > 0
    --   end
    -- })
  },
})
