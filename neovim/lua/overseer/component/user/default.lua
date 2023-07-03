return {
  desc = "custom component",
  constructor = function(params)
    return {
      on_start = function(self, task)
        vim.notify("Start: " .. task.name)
      end,
    }
  end,
}
