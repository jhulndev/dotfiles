return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        local harpoon = require("harpoon")

        harpoon:setup({})

        -- basic telescope configuration
        local conf = require("telescope.config").values
        local function toggle_telescope(harpoon_files)
            local file_paths = {}
            for _, item in ipairs(harpoon_files.items) do
                table.insert(file_paths, item.value)
            end

            require("telescope.pickers").new({}, {
                prompt_title = "Harpoon",
                finder = require("telescope.finders").new_table({
                    results = file_paths,
                }),
                previewer = conf.file_previewer({}),
                sorter = conf.generic_sorter({}),
            }):find()
        end

        -- set keymaps
        local keymap = vim.keymap

        keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Add to Harpoon"})
        keymap.set("n", "<leader>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Open Harpoon window"})
        -- keymap.set("n", "<leader>hl", function() toggle_telescope(harpoon:list()) end, { desc = "Open harpoon window" })

        keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "Go to 1st Harpoon entry"})
        keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "Go to 2nd Harpoon entry"})
        keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = "Go to 3rd Harpoon entry"})
        keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = "Go to 4th Harpoon entry"})
        keymap.set("n", "<leader>h5", function() harpoon:list():select(5) end, { desc = "Go to 5th Harpoon entry"})

        -- Toggle previous & next buffers stored within Harpoon list
        keymap.set("n", "<leader>hk", function() harpoon:list():prev() end, { desc = "Go to previous Harpoon entry"})
        keymap.set("n", "<leader>hj", function() harpoon:list():next() end, { desc = "Go to next Harpoon entry"})
    end,

}
