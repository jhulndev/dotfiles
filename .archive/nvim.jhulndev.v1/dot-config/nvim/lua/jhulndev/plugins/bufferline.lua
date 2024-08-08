return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  config = function()
    local bufferline = require("bufferline")
    local mocha = require("catppuccin.palettes").get_palette "mocha"

    bufferline.setup({
      highlights = require("catppuccin.groups.integrations.bufferline").get(), 
      options = {
        mode = "tabs",
        separator_style = "slant",
      },
    })

  end
}

