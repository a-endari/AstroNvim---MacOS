return {
    "L3MON4D3/LuaSnip",
    opts = {
      enable_autosnippets = true,
      store_selection_keys = "<Tab>",
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  }
  