local constants = require("overseer.constants")
local util = require("overseer.util")
local STATUS = constants.STATUS

return {
  desc = "custom component",
  params = {
    statuses = {
      desc = "List of statuses to notify on",
      type = "list",
      subtype = {
        type = "enum",
        choices = STATUS.values,
      },
      default = {
        STATUS.FAILURE,
        STATUS.SUCCESS,
      },
    },
    system = {
      desc = "When to send a system notification",
      type = "enum",
      choices = { "always", "never", "unfocused" },
      default = "never",
    },
    on_change = {
      desc = "Only notify when task status changes from previous value",
      long_desc =
      "This is mostly used when a task is going to be restarted, and you want notifications only when it goes from SUCCESS to FAILURE, or vice-versa",
      type = "boolean",
      default = false,
    },
  },
  constructor = function(params)
    if type(params.statuses) == "string" then
      params.statuses = { params.statuses }
    end
    local lookup = util.list_to_map(params.statuses)

    return {
      on_start = function(self, task)
        -- require'my.notify'.notify("Start: " .. task.name)
        params.progress = require 'my.notify'.start_progress({
          title = 'Task',
          message = "Start: " .. task.name,
          percentage = 0
        })
      end,
      on_complete = function(self, task, status)
        if lookup[status] then
          if params.on_change then
            if status == self.last_status then
              return
            end
            self.last_status = status
          end
          local level = util.status_to_log_level(status)
          local message = string.format("%s %s", status, task.name)
          require 'my.notify'.finish_progress(params.progress, { message = message, level = level })
        end
      end,
    }
  end,
}
