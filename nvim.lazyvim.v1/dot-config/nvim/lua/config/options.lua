-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- LSP Server to use for Python.
-- Set to "basedpyright" to use basedpyright instead of pyright.
vim.g.lazyvim_python_lsp = "basedpyright"
-- Set to "ruff_lsp" to use the old LSP implementation version.
vim.g.lazyvim_python_ruff = "ruff"

-- Enable this option to avoid conflicts with Prettier.
vim.g.lazyvim_prettier_needs_config = true

local opt = vim.opt

opt.scrolloff = 999
opt.winbar = "%=%m %f"
opt.colorcolumn = "80"

-- Configure clipboard behavior for remote multiplexer sessions.
if vim.env.SSH_CONNECTION and vim.env.HERDR_ENV == "1" then
  local osc52 = require("vim.ui.clipboard.osc52")

  opt.clipboard = "unnamedplus"
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = osc52.copy("+"),
      ["*"] = osc52.copy("*"),
    },
    paste = {
      ["+"] = osc52.paste("+"),
      ["*"] = osc52.paste("*"),
    },
  }
elseif vim.env.SSH_CONNECTION and vim.env.TMUX then
  opt.clipboard = "unnamedplus"

  vim.g.clipboard = {
    name = "tmux+system",
    copy = {
      -- -w = also write to the system clipboard (via tmux set-clipboard / OSC52)
      ["+"] = { "tmux", "load-buffer", "-w", "-" },
      ["*"] = { "tmux", "load-buffer", "-w", "-" },
    },
    paste = {
      ["+"] = { "tmux", "show-buffer" },
      ["*"] = { "tmux", "show-buffer" },
    },
    cache_enabled = 0,
  }
end
