return { -- Dictionary/Translation functionality
{
    "voldikss/vim-translator",
    cmd = {"Translate", "TranslateW"},
    config = function()
        vim.g.translator_target_lang = "en"
        vim.g.translator_source_lang = "de"
        vim.g.translator_default_engines = {"google", "bing"}
        -- Window preferences
        vim.g.translator_window_type = "popup" -- or "preview"
        -- Maximum window width
        vim.g.translator_window_max_width = 0.6
        -- Maximum window height
        vim.g.translator_window_max_height = 0.6
    end,
    keys = {}
}, -- Configure nvim-cmp for completion
{
    "hrsh7th/nvim-cmp",
    optional = true,
    opts = function(_, opts)
        local cmp = require("cmp")
        opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {{
            name = "buffer",
            keyword_length = 2
        }}))
        return opts
    end
}}
