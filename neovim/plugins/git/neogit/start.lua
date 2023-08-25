local neogit = require('neogit')
neogit.setup {
  auto_show_console = false,
  disable_context_highlighting = true,
  kind = 'split',
  integrations = {
    diffview = true,
  },
  sections = {
    untracked = {
      folded = true,
      hidden = false,
    },
    unstaged = {
      folded = false,
      hidden = false,
    },
    staged = {
      folded = false,
      hidden = false,
    },
    stashes = {
      folded = true,
      hidden = true,
    },
    unpulled = {
      folded = true,
      hidden = false,
    },
    unmerged = {
      folded = false,
      hidden = false,
    },
    recent = {
      folded = true,
      hidden = false,
    },
  },
}
