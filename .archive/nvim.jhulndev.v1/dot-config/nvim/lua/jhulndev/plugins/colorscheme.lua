return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        dim_inactive = {
          enabled = true,
          shade = "dark",
          percentage = 0.15,
        },
        styles = {
          comments = { "italic" },
          keywords = { "italic", "bold" },
        },
        integrations = {
          alpha = true,
          cmp = true,
          dap = true,
          dap_ui = true,
          gitsigns = true,
          harpoon = true,
          indent_blankline = {
            enabled = true,
            scope_color = "rosewater",
            colored_indent_levels = true,
          },
          lsp_trouble = true,
          markdown = true,
          mason = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
              ok = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
              ok = { "underline" },
            },
            inlay_hints = {
              background = true,
            },
          },
          noice = true,
          notify = true,
          nvim_surround = true,
          nvimtree = true,
          treesitter = true,
          which_key = true,
        },
      })
      -- load the colorscheme here
      vim.cmd([[colorscheme catppuccin]])
    end,
  },
}
