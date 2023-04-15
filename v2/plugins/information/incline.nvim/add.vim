lua << EOF

require('incline').setup {
  render = "basic",
  debounce_threshold = {
    falling = 50,
    rising = 10
  },
  hide = {
    focused_win = false,
  },
  highlight = {
    groups = {
      InclineNormal = "IncSearch",
      InclineNormalNC = "Visual"
    },
  },
  ignore = {
    buftypes = "special",
    filetypes = {},
    floating_wins = true,
    unlisted_buffers = true,
    wintypes = "special",
  },
  window = {
    margin = {
      horizontal = {
        left = 1,
        right = 1
      },
      vertical = {
        bottom = 0,
        top = 1
      },
    },
    options = {
      signcolumn = "no",
      wrap = false
    },
    padding = {
      left = 1,
      right = 1
    },
    padding_char = " ",
    placement = {
      horizontal = "right",
      vertical = "top",
    },
    width = "fit",
    winhighlight = {
      active = {
        EndOfBuffer = "None",
        Normal = "InclineNormal",
        Search = "None"
      },
      inactive = {
        EndOfBuffer = "None",
        Normal = "InclineNormalNC",
        Search = "None"
      }
    },
    zindex = 50,
  },
}

EOF
