return {
  "Vigemus/iron.nvim",
  config = function()
    local iron = require("iron.core")
    local view = require("iron.view")

    iron.setup({
      config = {
        -- Whether a repl should be discarded or not
        scratch_repl = true,
        -- Your repl definitions come here
        repl_definition = {
          sh = {
            -- Can be a table or a function that
            -- returns a table (see below)
            command = { "zsh" }
          },
          python = {
            command = { "python3" }, -- or { "ipython", "--no-autoindent" }
            format = require("iron.fts.common").bracketed_paste_python
          }
        },
        -- How the repl window will be displayed
        -- See below for more information
        -- repl_open_cmd = require('iron.view').bottom(40),
        repl_open_cmd = view.split.botright(40),
      },

      -- If the highlight is on, you can change how it looks
      -- For the available options, check nvim_set_hl
      highlight = {
        italic = true
      },
      ignore_blank_lines = true, -- ignore blank lines when sending visual select lines

      -- You can set keymaps here or manually add keymaps to the functions in iron.core
      keymaps = {
        send_motion = "<leader>xc",
        visual_send = "<leader>xc",
        send_file = "<leader>xf",
        send_line = "<leader>xl",
        send_paragraph = "<leader>xp",
        send_until_cursor = "<leader>xu",
        send_mark = "<leader>xms",
        mark_motion = "<leader>xmc",
        mark_visual = "<leader>xmc",
        remove_mark = "<leader>xmd",
        cr = "<leader>x<cr>",
        interrupt = "<leader>x<space>",
        exit = "<leader>xq",
        clear = "<leader>xcl",
      },
    })

    -- iron also has a list of commands, see :h iron-commands for all available commands
    vim.keymap.set('n', '<leader>is', '<cmd>IronRepl<cr>')
    vim.keymap.set('n', '<leader>ir', '<cmd>IronRestart<cr>')
    vim.keymap.set('n', '<leader>if', '<cmd>IronFocus<cr>')
    vim.keymap.set('n', '<leader>ih', '<cmd>IronHide<cr>')
  end,
}
