return {
  "folke/trouble.nvim",
  dpendencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
  opts = {
    focus = true,
  },
  cmd = "Trouble",
  keys = {
    { "<leader>trw", "<cmd>Trouble diagnostics toggle<CR>",              desc = "Open trouble workspace diagnostics" },
    { "<leader>trd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Open trouble document diagnostics" },
    { "<leader>trq", "<cmd>Trouble quickfix toggle<CR>",                 desc = "Open trouble quickfix list" },
    { "<leader>trl", "<cmd>Trouble loclist toggle<CR>",                  desc = "Open trouble location list" },
    { "<leader>trt", "<cmd>Trouble todo toggle<CR>",                     desc = "Open todos in trouble" },
  },
}
