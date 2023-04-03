require("github-theme").setup({
  theme_style = "dark",
  function_style = "italic",
  sidebars = {"qf", "vista_kind", "terminal", "packer"},
  colors = {hint = "orange", error = "#ff0000"},
  overrides = function(c)
    return {
      Folded = {bg="#384049"},
      -- htmlTag = {fg = c.red, bg = "#282c34", sp = c.hint, style = "underline"},
      -- DiagnosticHint = {link = "LspDiagnosticsDefaultHint"},
      -- this will remove the highlight groups
      -- TSField = {},
    }
  end
})
