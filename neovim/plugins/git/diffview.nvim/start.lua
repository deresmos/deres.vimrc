require 'diffview'.setup({
  file_panel = {
    listing_style = "list",
    tree_options = {
      flatten_dirs = true,
      folder_statuses = "only_folded"
    },
    win_config = {
      position = "bottom",
      height = 15,
      win_opts = {}
    },
  },
  hooks = {
    diff_buf_read = function(bufnr)
      -- if vim.fn.winnr() == 1 then
      --   -- local winhighlight = vim.api.nvim_win_get_option(vim.api.nvim_get_current_win(), "winhighlight")
      --   vim.api.nvim_set_option_value("winhighlight", "DiffChange:DiffLeftChange,DiffText:DiffLeftText,DiffAdd:DiffLeftAdd,DiffDelete:DiffLeftDelete", {win = vim.api.nvim_get_current_win()})
      -- end
      --
      -- if vim.fn.winnr() == 2 then
      --   -- local winhighlight = vim.api.nvim_win_get_option(vim.api.nvim_get_current_win(), "winhighlight")
      --   vim.api.nvim_set_option_value("winhighlight", "DiffChange:DiffRightChange,DiffText:DiffRightText,DiffAdd:DiffRightAdd,DiffDelete:DiffRightDelete", {win = vim.api.nvim_get_current_win()})
      -- end
      -- Change local options in diff buffers
      vim.opt_local.wrap = false
      vim.opt_local.list = false
      vim.opt_local.colorcolumn = { 80 }
    end,
    view_opened = function(view)
      print(
        ("A new %s was opened on tab page %d!")
        :format(view.class:name(), view.tabpage)
      )
    end,
  }
})
