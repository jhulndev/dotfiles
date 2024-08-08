return {
  "hashivim/vim-terraform",
  config = function()
    local keymap = vim.keymap

    keymap.set("n", "<leader>tff", "<cmd>TerraformFmt<cr>", { desc = "Run terraform fmt" })
    keymap.set("n", "<leader>tfi", ":execute 'cd %:p:h' | !terraform init -no-color<cr>", { desc = "Run terraform init" })
    keymap.set("n", "<leader>tfu", ":execute 'cd %:p:h' | !terraform init -upgrade -no-color<cr>", { desc = "Run terraform init -upgrade" })
    keymap.set("n", "<leader>tfv", ":execute 'cd %:p:h' | !terraform validate -no-color<cr>", { desc = "Run terraform validate" })
    keymap.set("n", "<leader>tfp", ":execute 'cd %:p:h' | !terraform plan -no-color<cr>", { desc = "Run terraform plan" })
  end,
}
