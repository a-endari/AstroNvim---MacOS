return { -- Dictionary/Translation functionality
{
    "voldikss/vim-translator",
    cmd = {"Translate", "TranslateW"},
    config = function()
        vim.g.translator_target_lang = "en"
        vim.g.translator_source_lang = "de"
        vim.g.translator_default_engines = {"google", "bing"}
    end,
    keys = {{
        "<leader>dd",
        "<cmd>TranslateW<CR>",
        desc = "Translate word under cursor (window)"
    }, {
        "<leader>dg",
        ":Translate de:en<CR>",
        desc = "Translate German to English"
    }, {
        "<leader>de",
        ":Translate en:de<CR>",
        desc = "Translate English to German"
    }}
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
