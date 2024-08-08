return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")

    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      ensure_installed = {
        -- "bashls",
        -- "cssls",
        -- "emmet_ls",
        -- "gopls",
        -- "graphql",
        "helm_ls",
        -- "html",
        -- "htmx",
        -- "jdtls",
        -- "jinja_lsp",
        "lua_ls",
        "pyright",
        "ruff",
        -- "tailwindcss",
        -- "templ",
        "terraformls",
        "tflint",
        -- "tsserver",
        -- "svelte",
        "yamlls",
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "prettier",
        -- "stylua",
        -- "isort",
        -- "black",
        -- "pylint",
        -- "eslint_d",
      },
    })
  end,
}
