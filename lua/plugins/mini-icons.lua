return {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
        require("mini.icons").setup({
            -- Optional custom configuration
            preset = "default"
        })
    end
}
