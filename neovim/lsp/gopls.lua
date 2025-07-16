return {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = {
    'go.mod',
    'go.sum',
  },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        QF1008 = false,
      },
      staticcheck = true,
      usePlaceholders = true,
      completeUnimported = true,
      gofumpt = true,
      semanticTokens = true,
      buildFlags = {
        '-tags=wireinject',
      },
    },
  }
}
