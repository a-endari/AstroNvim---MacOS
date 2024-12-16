-- Remove this line to activate the file
-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize None-ls sources

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, config)
    local null_ls = require("null-ls")

    -- Check supported formatters and linters
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    config.sources = {
      -- Set formatters
      null_ls.builtins.formatting.google_java_format,
      
      -- Set linters/diagnostics
      null_ls.builtins.diagnostics.checkstyle.with({
        extra_args = {
          "-c",
          vim.fn.stdpath("config") .. "/lua/config/google_checks.xml"
        },
      }),
    }
    return config -- return final config table
  end,
}
