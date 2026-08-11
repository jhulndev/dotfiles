return {
  "lmilojevicc/herdr-splits.nvim",
  tag = "v0.5.1",
  cond = vim.env.HERDR_ENV == "1",
  event = "VeryLazy",
  opts = {
    at_edge = "stop",
    nav_at_edge = "stop",
  },
  keys = {
    { "<C-h>", function() require("herdr-splits").move_cursor_left() end, desc = "Navigate left" },
    { "<C-j>", function() require("herdr-splits").move_cursor_down() end, desc = "Navigate down" },
    { "<C-k>", function() require("herdr-splits").move_cursor_up() end, desc = "Navigate up" },
    { "<C-l>", function() require("herdr-splits").move_cursor_right() end, desc = "Navigate right" },
  },
}
