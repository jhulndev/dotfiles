return {
  "nickjvandyke/opencode.nvim",
  version = "*",
  config = function()
    local connected_url
    local terminal_opts = {
      win = {
        position = "right",
        width = 0.4,
        enter = false,
      },
    }

    local function terminal_cmd(url)
      return { "opencode", "attach", url, "--continue" }
    end

    local function focus_terminal()
      if not connected_url then
        vim.notify("Connect to OpenCode with <leader>oa or <leader>os first", vim.log.levels.WARN)
        return
      end

      local terminal = require("snacks.terminal").get(terminal_cmd(connected_url), terminal_opts)
      if terminal.win and vim.api.nvim_get_current_win() == terminal.win then
        terminal:hide()
      else
        terminal:show():focus()
      end
    end

    ---@type opencode.Opts
    vim.g.opencode_opts = {
      server = {
        start = false,
      },
    }

    vim.o.autoread = true

    local opencode = require("opencode")

    vim.keymap.set({ "n", "x" }, "<leader>oa", function()
      opencode.ask("@this: ")
    end, { desc = "Ask OpenCode" })
    vim.keymap.set({ "n", "x" }, "<leader>os", function()
      opencode.select()
    end, { desc = "Select OpenCode" })

    vim.keymap.set({ "n", "x" }, "go", function()
      return opencode.operator("@this ")
    end, { desc = "Append range to OpenCode", expr = true })
    vim.keymap.set("n", "goo", function()
      return opencode.operator("@this ") .. "_"
    end, { desc = "Append line to OpenCode", expr = true })

    vim.keymap.set("n", "<S-C-u>", function()
      opencode.command("session.half.page.up")
    end, { desc = "Scroll OpenCode up" })
    vim.keymap.set("n", "<S-C-d>", function()
      opencode.command("session.half.page.down")
    end, { desc = "Scroll OpenCode down" })

    vim.keymap.set({ "n", "t" }, "<C-.>", focus_terminal, { desc = "Focus or hide OpenCode" })

    local group = vim.api.nvim_create_augroup("opencode_terminal", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "OpencodeEvent:*",
      callback = function(args)
        local data = args.data
        if not data or not data.url then
          return
        end

        connected_url = data.url

        local event = data.event
        if event.type == "tui.command.execute" and event.properties.command == "prompt.submit" then
          require("snacks.terminal").get(terminal_cmd(connected_url), terminal_opts):show()
        end
      end,
    })
  end,
}
