return {
  {
    "catppuccin/nvim",
    opts = {
      flavour = "mocha",
      dim_inactive = {
        enabled = true,
        shade = "dark",
        percentage = 0,
      },
      styles = {
        comments = { "italic" },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-nvim",
    },
  },
}
