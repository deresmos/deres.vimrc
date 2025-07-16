local function wrap_node(f)
  return function(node, ...)
    node = node or require("nvim-tree.lib").get_node_at_cursor()
    f(node, ...)
  end
end

local function grep_directory(node)
  if node.name == ".." then
    print("not support")
    return
  end

  if node.fs_stat.type == "directory" then
    -- view.close()
    require('my.finder').set_cwd(node.absolute_path)
    Finder.grep()
  end
end

local function find_files(node)
  if node.name == ".." then
    print("not support")
    return
  end

  if node.fs_stat.type == "directory" then
    require('my.finder').set_cwd(node.absolute_path)
    Finder.files()
  end
end

local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent, opts('Up'))
  vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))

  vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', 'L', api.tree.change_root_to_node, opts('Cd'))
  vim.keymap.set('n', 'h', api.tree.change_root_to_parent, opts('Edit'))
  vim.keymap.set('n', 's', api.node.open.horizontal, opts('Open horizontal'))
  vim.keymap.set('n', 'v', api.node.open.vertical, opts('Open vertical'))
  vim.keymap.set('n', 't', api.node.open.tab, opts('Open tab'))
  vim.keymap.set('n', 'c', api.fs.create, opts('Create'))
  vim.keymap.set('n', 'y', api.fs.copy.node, opts('Copy'))
  vim.keymap.set('n', '<Space>gj', api.node.navigate.git.next, opts('Next git file'))
  vim.keymap.set('n', '<Space>gk', api.node.navigate.git.prev, opts('Prev git file'))
  vim.keymap.set('n', '<Space>ff', wrap_node(find_files), opts('Find files'))
  vim.keymap.set('n', '<Space>fg', wrap_node(grep_directory), opts('Grep files'))
end

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  on_attach = my_on_attach,
  view = {
    float = {
      enable = false,
      quit_on_focus_loss = true,
      open_win_config = {
        width = 60,
        height = 50,
      },
    },
    width = 40,
    -- mappings = {
    --   list = {
    --     { key = "l",         action = "edit" },
    --     { key = "L",         action = "cd" },
    --     { key = "h",         action = "dir_up" },
    --     { key = "y",         action = "copy" },
    --     { key = "c",         action = "create" },
    --     { key = "s",         action_cb = api.node.open.horizontal },
    --     { key = "v",         action_cb = api.node.open.vertical },
    --     { key = "t",         action_cb = api.node.open.tab },
    --     { key = "<Space>gj", action = "next_git_item" },
    --     { key = "<Space>gk", action = "prev_git_item" },
    --     { key = "<Space>ff", action_cb = find_files },
    --     { key = "<Space>fg", action_cb = grep_directory },
    --   },
    -- },
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
