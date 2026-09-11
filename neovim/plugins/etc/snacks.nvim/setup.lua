require 'snacks'.setup({
  input = { enabled = true },
  picker = {
    enabled = true,
    -- telescopeのlayout_strategy = "vertical"相当: input/list/previewを
    -- 縦に並べ、previewを下部に表示する
    layout = {
      preset = "vertical",
      layout = { width = 0.8 },
    },
  },
})
