return {
    "epwalsh/obsidian.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = {
      "ObsidianQuickSwitch",
      "ObsidianWorkspace",
    },
    lazy = true,
    event = { -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    "BufReadPre " .. vim.fn.expand "~" .. "Dropbox/Obsidian-Vaults/*.md",
    "BufNewFile " .. vim.fn.expand "~" .. "Dropbox/Obsidian-Vaults/*.md",
    -- "BufReadPre */Obsidian-Vaults/**.md",
    -- "BufNewFile */Obsidian-Vaults/**.md",
  },
    keys = {
        {
            "gf",
            function()
              if require("obsidian").util.cursor_on_markdown_link() then
                return "<cmd>ObsidianFollowLink<CR>"
              else
                return "gf"
              end
            end,
            noremap = false,
            expr = true,
          },
          {
            "<Leader>ot",
            ":ObsidianToday<CR>",
            desc = "Open Today's note",
          },
      {
        "<leader>os",
        "<cmd>ObsidianQuickSwitch<cr>",
        desc = "Quick Switch",
      },
    },
    opts = {
      dir = vim.fn.expand("~/Dropbox/Obsidian-Vaults/German"),
      finder = "telescope.nvim",
      workspaces = {
        {
          name = "Journal",
          path = vim.env.HOME .. "/Dropbox/Obsidian-Vaults/Journal",
        },
        {
          name = "Programming",
          path = vim.env.HOME .. "/Dropbox/Obsidian-Vaults/Programming",
        },
        {
          name = "Personal",
          path = vim.env.HOME .. "/Dropbox/Obsidian-Vaults/Personal",
        },
        {
          name = "Work",
          path = vim.env.HOME .. "/Dropbox/Obsidian-Vaults/Work",
        },
        {
          name = "German",
          path = vim.env.HOME .. "/Dropbox/Obsidian-Vaults/German",
        },
        {
          name = "ios",
          path = vim.env.HOME .. "/Dropbox/Apps/remotely-save/IOS VAULT",
        },
      },
      templates = {
        subdir = "templates",
        date_format = "%Y-%m-%d-%a",
        time_format = "%H:%M",
      },
    },
  }
