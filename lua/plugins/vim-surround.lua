return {
  {
    "kylechui/nvim-surround",
    version = "*", -- Use latest stable version
    event = "VeryLazy", -- Lazy load for performance
    config = function() require("nvim-surround").setup {} end,
  },
}
