local null_ls = require("null-ls")

null_ls.setup({
  diagnostics_format = "#{m} (#{s}: #{c})",
  sources = {
    null_ls.builtins.completion.spell,

    -- null_ls.builtins.formatting.gofmt,
    null_ls.builtins.diagnostics.golangci_lint,
    -- null_ls.builtins.diagnostics.staticcheck,

    null_ls.builtins.diagnostics.textlint,

    null_ls.builtins.formatting.jq,

    -- null_ls.builtins.diagnostics.terraform_validate,
    null_ls.builtins.formatting.terraform_fmt,
  },
})
