-- if true then
    -- return {}
-- end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Treesitter

---@type LazySpec
return {
    "nvim-treesitter/nvim-treesitter",
    opts = {
        ensure_installed = {"jsonc", "lua", "python", "markdown", "markdown_inline", "toml", "yaml"},
        highlight = {
            enable = true
        }
    }
}
