local view = require("nvim-tree.view")

local function grep_directory(node)
  if node.name == ".." then
    print("not support")
    return
  end

  if node.fs_stat.type == "directory" then
    -- view.close()
    require('telescope.builtin').live_grep({ cwd = node.absolute_path })
  end
end

local function find_files(node)
  if node.name == ".." then
    print("not support")
    return
  end

  if node.fs_stat.type == "directory" then
    require('telescope.builtin').find_files({ cwd = node.absolute_path })
  end
end

local api = require('nvim-tree.api')

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    float = {
      enable = true,
      quit_on_focus_loss = true,
      open_win_config = {
        width = 60,
        height = 50,
      },
    },
    width = 40,
    mappings = {
      list = {
        { key = "l",         action = "edit" },
        { key = "L",         action = "cd" },
        { key = "h",         action = "dir_up" },
        { key = "y",         action = "copy" },
        { key = "c",         action = "create" },
        { key = "s",         action_cb = api.node.open.horizontal },
        { key = "v",         action_cb = api.node.open.vertical },
        { key = "t",         action_cb = api.node.open.tab },
        { key = "<Space>gj", action = "next_git_item" },
        { key = "<Space>gk", action = "prev_git_item" },
        { key = "<Space>ff", action_cb = find_files },
        { key = "<Space>fg", action_cb = grep_directory },
      },
    },
  },
  renderer = {
    group_empty = false,
    indent_markers = {
      enable = true,
      inline_arrows = true,
      icons = {
        corner = "└",
        edge = "│",
        item = "│",
        bottom = "─",
        none = " ",
      },
    },
    icons = {
      show = {
        file = false,
        folder = false,
        folder_arrow = true,
        git = false,
        modified = true,
      },
    },
  },
  filters = {
    dotfiles = true,
  },
})
