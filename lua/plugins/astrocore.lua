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
                lines = 10000
            }, -- set global limits for large files for disabling features like treesitter
            autopairs = true, -- enable autopairs at start
            cmp = true, -- enable completion at start
            diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
            highlighturl = true, -- highlight URLs at start
            notifications = true -- enable notifications at start
        },
        lsp = {
            formatting = {
                format_on_save = true
            },
            servers = {
                jdtls = {
                    mason = false
                }
            },
            -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
            diagnostics = {
                virtual_text = true,
                underline = true
            },
            -- vim options can be configured here
            options = {
                opt = { -- vim.opt.<key>
                    spelllang = {"en", "de"},
                    relativenumber = true, -- sets vim.opt.relativenumber
                    number = true, -- sets vim.opt.number
                    spell = true, -- sets vim.opt.spell
                    signcolumn = "yes", -- sets vim.opt.signcolumn to yes
                    wrap = true, -- sets vim.opt.wrap
                    -- AE: RTL Support
                    termbidi = true,
                    arabicshape = true,
                    -- AE spelling
                    conceallevel = 2
                },
                g = { -- vim.g.<key>
                    -- configure global vim variables (vim.g)
                    -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
                    -- This can be found in the `lua/lazy_setup.lua` file
                    vim_markdown_conceal = 2

                }
            }
        },
        -- Mappings can be configured through AstroCore as well.
        -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
        mappings = {
            -- first key is the mode
            n = {
                -- second key is the lefthand side of the map

                -- navigate buffer tabs
                ["]b"] = {
                    function()
                        require("astrocore.buffer").nav(vim.v.count1)
                    end,
                    desc = "Next buffer"
                },
                ["[b"] = {
                    function()
                        require("astrocore.buffer").nav(-vim.v.count1)
                    end,
                    desc = "Previous buffer"
                },

                -- mappings seen under group name "Buffer"
                ["<Leader>bd"] = {
                    function()
                        require("astroui.status.heirline").buffer_picker(function(bufnr)
                            require("astrocore.buffer").close(bufnr)
                        end)
                    end,
                    desc = "Close buffer from tabline"
                },
                --- python execution mappings
                ["<F5>"] = {
                    "<cmd>w<cr><cmd>split<cr><cmd>term python3 %<cr>",
                    desc = "Run Python file"
                },
                ["<leader>pr"] = {
                    "<cmd>w<cr><cmd>split<cr><cmd>term python3 %<cr>",
                    desc = "Run Python file"
                },

                -- Use Tab to navigate tabs in normal mode!
                ["<S-Tab>"] = {
                    ":bprev<CR>",
                    noremap = true
                },
                ["<Tab>"] = {
                    ":bnext<CR>",
                    noremap = true
                },

                -- from here for spell check and dictionary
                ["<leader>gd"] = {
                    function()
                        vim.opt.spelllang = "de"
                        vim.opt.spell = not vim.opt.spell:get()
                        if vim.opt.spell:get() then
                            vim.notify("German spell checking enabled", "info")
                        else
                            vim.notify("Spell checking disabled", "info")
                        end
                    end,
                    desc = "Toggle German spell checking"
                },
                ["<leader>ge"] = {
                    function()
                        vim.opt.spelllang = "en"
                        vim.opt.spell = not vim.opt.spell:get()
                        if vim.opt.spell:get() then
                            vim.notify("English spell checking enabled", "info")
                        else
                            vim.notify("Spell checking disabled", "info")
                        end
                    end,
                    desc = "Toggle English spell checking"
                },

                -- Dictionary mappings
                ["<leader>dd"] = {
                    "<cmd>TranslateW<CR>",
                    desc = "Translate word under cursor (window)"
                },
                ["<leader>dg"] = {
                    ":Translate de:en<CR>",
                    desc = "Translate German to English"
                },
                ["<leader>de"] = {
                    ":Translate en:de<CR>",
                    desc = "Translate English to German"
                },

                -- Add terminal mode mappings
                t = {
                    ["<Esc>"] = {
                        "<C-\\><C-n>",
                        desc = "Terminal normal mode"
                    }
                },
                -- tables with just a `desc` key will be registered with which-key if it's installed
                -- this is useful for naming menus
                -- ["<Leader>b"] = { desc = "Buffers" },

                -- setting a mapping to false will disable it
                -- ["<C-S>"] = false,
                -- Use Tab to navigate tabs in normal mode!
                vim.api.nvim_set_keymap("n", "<S-Tab>", ":bprev<CR>", {
                    noremap = true
                }),
                vim.api.nvim_set_keymap("n", "<Tab>", ":bnext<CR>", {
                    noremap = true
                })
            }
        }

    }
}
