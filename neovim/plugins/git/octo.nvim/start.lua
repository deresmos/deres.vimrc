require("octo").setup({
  ssh_aliases = {
    ["github-deresmos"] = "github.com",
  },
  mappings = {
    review_diff = {
      -- submit_review = { lhs = "<leader>vs", desc = "submit review" },
      -- discard_review = { lhs = "<leader>vd", desc = "discard review" },
      -- add_review_comment = { lhs = "<space>ca", desc = "add a new review comment" },
      -- add_review_suggestion = { lhs = "<space>sa", desc = "add a new review suggestion" },
      -- focus_files = { lhs = "<leader>e", desc = "move focus to changed file panel" },
      -- toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
      -- next_thread = { lhs = "]t", desc = "move to next thread" },
      -- prev_thread = { lhs = "[t", desc = "move to previous thread" },
      -- select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
      -- select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
      -- select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
      -- select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
      -- close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
      toggle_viewed = { lhs = "<Space>", desc = "toggle viewer viewed state" },
      -- goto_file = { lhs = "gf", desc = "go to file" },
    },
  },
})
