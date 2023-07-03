return {
  name = "git push HEAD",
  builder = function()
    return {
      cmd = { "git", "push", "-v", "origin", "HEAD" },
      components = { "user.default", "default" },
    }
  end,
}
