-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing
---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = {
        size = 1024 * 256,
        lines = 10000,
      }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
      autochdir = true, --  enable cwd to change automatically
    },
    lsp = {
      formatting = {
        Format_on_save = true,
      },
      servers = {
        jdtls = {
          mason = false,
        },
      },
      -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
      diagnostics = {
        virtual_text = true,
        underline = true,
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        spelllang = { "en", "de" },
        scrolloff = 2,
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = true, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = true, -- sets vim.opt.wrap
        -- AE: RTL Support
        termbidi = true,
        arabicshape = true,
        rightleft = false, -- This will be toggled when needed
        rightleftcmd = "search", -- For command line mode
        conceallevel = 2, -- for obsidian to hide symbols
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
        vim_markdown_conceal = 3,
      },
    },

    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus

        ["<leader>m"] = {
          desc = "✎ Markdown Preview",
        },
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = {
          function() require("astrocore.buffer").nav(vim.v.count1) end,
          desc = "Next buffer",
        },
        ["[b"] = {
          function() require("astrocore.buffer").nav(-vim.v.count1) end,
          desc = "Previous buffer",
        },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },
        --- python execution mappings
        ["<F5>"] = {
          "<cmd>w<cr><cmd>split<cr><cmd>term python3 '%'<cr>",
          desc = "Run Python file",
        },
        ["<leader>rp"] = {
          "<cmd>w<cr><cmd>split<cr><cmd>term python3 '%'<cr>",
          desc = "Run Python file",
        },

        -- Use Tab to navigate tabs in normal mode!
        ["<S-Tab>"] = {
          ":bprev<CR>",
          noremap = true,
        },
        ["<Tab>"] = {
          ":bnext<CR>",
          noremap = true,
        },
        -- Dictionary mappings
        ["<leader>dd"] = {
          ":TranslateW<CR>",
          desc = "Translate German to English",
        },
        ["<leader>de"] = {
          ":TranslateW!<CR>",
          desc = "Translate English to German",
        },
        -- Transparency toggle
        ["<leader>uT"] = {
          function()
            vim.g.transparent_enabled = not vim.g.transparent_enabled
            require("catppuccin").setup {
              transparent_background = vim.g.transparent_enabled,
            }
            vim.cmd "colorscheme catppuccin"
          end,
          desc = "Toggle transparency",
        },
      },
      -- insert mode mappings
      i = {
        -- Move cursor in insert mode with Ctrl + h, j, k, l
        ["<C-h>"] = {
          "<Left>",
          noremap = true,
          silent = true,
          desc = "Move cursor left in insert mode",
        },
        ["<C-j>"] = {
          "<Down>",
          noremap = true,
          silent = true,
          desc = "Move cursor down in insert mode",
        },
        ["<C-k>"] = {
          "<Up>",
          noremap = true,
          silent = true,
          desc = "Move cursor up in insert mode",
        },
        ["<C-l>"] = {
          "<Right>",
          noremap = true,
          silent = true,
          desc = "Move cursor right in insert mode",
        },
      },
      -- Add visual mode mappings
      v = {
        ["<leader>dg"] = {
          ":TranslateW<CR>",
          desc = "Translate selection German to English",
        },
        ["<leader>de"] = {
          ":TranslateW!<CR>",
          desc = "Translate selection English to German",
        },
      },

      -- Add terminal mode mappings
      t = {
        ["<Esc>"] = {
          "<C-\\><C-n>",
          desc = "Terminal normal mode",
        },
      },
      -- tables with just a `desc` key will be registered with which-key if it's installed
      -- this is useful for naming menus
      -- ["<Leader>b"] = { desc = "Buffers" },

      -- setting a mapping to false will disable it
      -- ["<C-S>"] = false,
    },
  },
}
