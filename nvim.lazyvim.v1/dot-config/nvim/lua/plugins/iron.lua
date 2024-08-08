return {
  "Vigemus/iron.nvim",
  lazy = true,
  keys = {
    -- REPL Management and Control
    {
      "<leader>r",
      desc = "+repl",
    },
    {
      "<leader>r",
      mode = "v",
      desc = "+repl",
    },
    {
      "<leader>rc",
      desc = "Clear REPL",
    },
    {
      "<leader>rf",
      desc = "Focus REPL",
    },
    {
      "<leader>rh",
      desc = "Hide REPL",
    },
    {
      "<leader>rq",
      desc = "Exit REPL",
    },
    {
      "<leader>rr",
      desc = "Toggle REPL",
    },
    {
      "<leader>rR",
      desc = "Restart REPL",
    },
    {
      "<leader>r<space>",
      desc = "Interrupt REPL",
    },

    -- REPL Marks
    {
      "<leader>rm",
      desc = "+mark",
    },
    {
      "<leader>rm",
      mode = "v",
      desc = "+mark",
    },
    {
      "<leader>rmc",
      desc = "Mark text motion",
    },
    {
      "<leader>rmc",
      mode = "v",
      desc = "Mark visual selection",
    },
    {
      "<leader>rmd",
      desc = "Remove mark",
    },

    -- REPL Send Commands
    {
      "<leader>rs",
      desc = "+send",
    },
    {
      "<leader>rs",
      mode = "v",
      desc = "+send",
    },
    {
      "<leader>rs<cr>",
      desc = "Send carriage return",
    },
    {
      "<leader>rsc",
      desc = "Send code motion",
    },
    {
      "<leader>rsc",
      mode = "v",
      desc = "Send visual selection",
    },
    {
      "<leader>rsl",
      desc = "Send current line",
    },
    {
      "<leader>rsf",
      desc = "Send entire file",
    },
    {
      "<leader>rsp",
      desc = "Send paragraph",
    },
    {
      "<leader>rsu",
      desc = "Send until cursor",
    },
    {
      "<leader>rsm",
      desc = "Send marked text",
    },
  },

  cmd = {
    "IronRelp",
    "IronRestart",
    "IronFocus",
    "IronHide",
  },

  config = function()
    local iron = require("iron.core")
    local view = require("iron.view")
    local common = require("iron.fts.common")
    local marks = require("iron.marks")

    iron.setup({
      config = {
        -- Whether a repl should be discarded or not
        scratch_repl = true,

        -- Your repl definitions come here
        repl_definition = {
          sh = {
            -- Can be a table or a function that
            -- returns a table (see below)
            command = { "zsh" },
          },
          python = {
            command = { "python3" }, -- or { "ipython", "--no-autoindent" }
            format = common.bracketed_paste_python,
            block_dividers = { "# %%", "#%%" },
          },
        },

        -- set the file type of the newly created repl to ft
        -- bufnr is the buffer id of the REPL and ft is the filetype of the
        -- language being used for the REPL.
        repl_filetype = function(bufnr, ft)
          return ft
          -- or return a string name such as the following
          -- return "iron"
        end,

        -- How the repl window will be displayed
        -- See below for more information
        -- repl_open_cmd = view.bottom(40),
        repl_open_cmd = view.split.botright(40),

        -- repl_open_cmd can also be an array-style table so that multiple
        -- repl_open_commands can be given.
        -- When repl_open_cmd is given as a table, the first command given will
        -- be the command that `IronRepl` initially toggles.
        -- Moreover, when repl_open_cmd is a table, each key will automatically
        -- be available as a keymap (see `keymaps` below) with the names
        -- toggle_repl_with_cmd_1, ..., toggle_repl_with_cmd_k
        -- For example,
        --
        -- repl_open_cmd = {
        --   view.split.vertical.rightbelow("%40"), -- cmd_1: open a repl to the right
        --   view.split.rightbelow("%25")  -- cmd_2: open a repl below
        -- }
      },

      -- If the highlight is on, you can change how it looks
      -- For the available options, check nvim_set_hl
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
    })

    -- Custom keymaps with proper descriptions for which-key
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
    end

    -- Custom keymap functions referenced from:
    -- https://github.com/Vigemus/iron.nvim/blob/c005b01b779f1b6c038e11248db403bb3df6a7f3/lua/iron/core.lua#L687-L721

    local function iron_send_cr()
      iron.send(nil, string.char(13))
    end

    local function iron_send_interrupt()
      iron.send(nil, string.char(03))
    end

    local function iron_send_clear()
      iron.send(nil, string.char(12))
    end

    -- REPL Management and Control
    map("n", "<leader>r", "", "+repl")
    map("v", "<leader>r", "", "+repl")
    map("n", "<leader>rc", iron_send_clear, "Clear REPL")
    map("n", "<leader>rf", "<cmd>IronFocus<cr>", "Focus REPL")
    map("n", "<leader>rh", "<cmd>IronHide<cr>", "Hide REPL")
    map("n", "<leader>rq", iron.close_repl, "Exit REPL")
    map("n", "<leader>rr", "<cmd>IronRepl<cr>", "Toggle REPL")
    map("n", "<leader>rR", "<cmd>IronRestart<cr>", "Restart REPL")
    map("n", "<leader>r<space>", iron_send_interrupt, "Interrupt REPL")

    -- REPL Marks
    map("n", "<leader>rm", "", "+mark")
    map("v", "<leader>rm", "", "+mark")
    map("n", "<leader>rmc", iron.mark_motion, "Mark text motion")
    map("v", "<leader>rmc", iron.mark_visual, "Mark visual selection")
    map("n", "<leader>rmd", marks.drop_last, "Remove mark")

    -- REPL Send Commands
    map("n", "<leader>rs", "", "+send")
    map("v", "<leader>rs", "", "+send")
    map("n", "<leader>rs<cr>", iron_send_cr, "Send carriage return")
    map("n", "<leader>rsc", iron.send_motion, "Send code motion")
    map("v", "<leader>rsc", iron.visual_send, "Send visual selection")
    map("n", "<leader>rsl", iron.send_line, "Send current line")
    map("n", "<leader>rsf", iron.send_file, "Send entire file")
    map("n", "<leader>rsp", iron.send_paragraph, "Send paragraph")
    map("n", "<leader>rsu", iron.send_until_cursor, "Send until cursor")
    map("n", "<leader>rsm", iron.send_mark, "Send marked text")

    map("n", "<leader>rsb", function()
      iron.send_code_block(false)
    end, "Send code block")

    map("n", "<leader>rsn", function()
      iron.send_code_block(true)
    end, "Send code block and move")
  end,
}
