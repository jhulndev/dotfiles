return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    local treesitter = require("nvim-treesitter.configs")

    treesitter.setup({
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
      autotag = {
        -- nvim-ts-autotag plugin
        enable = true,
      },
      ensure_installed = {
        "bash",
        "c",
        "css",
        "csv",
        "dockerfile",
        "gitignore",
        "go",
        "graphql",
        "hcl",
        "helm",
        "html",
        "java",
        "javascript",
        "jsdoc",
        "json",
        "kotlin",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        -- "nginx",
        -- "nix",
        -- "norg",
        "python",
        -- "rego",
        -- "rust",
        "sql",
        -- "svelte",
        -- "templ",
        "terraform",
        "toml",
        "typescript",
        -- "tsx",
        "vim",
        "vimdoc",
        -- "xml",
        "yaml",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
}
