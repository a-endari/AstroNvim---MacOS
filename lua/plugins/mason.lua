-- if true then
--     return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE Customize Mason plugins
---@type LazySpec
return { -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = {
      ensure_installed = {
        "lua_ls",
        "pyright",        -- Python type checking
        "ruff",       -- Fast Python linter
        "jdtls",  -- Add Java language server
        -- add more arguments for adding more language servers
      },
    },
  }, -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = {
      ensure_installed = {
        "prettier",
        "stylua",
        "ruff",
        -- "black",  -- Disabled in favor of ruff
        -- "isort",  -- Disabled in favor of ruff
        "mypy",         -- Static type checker
        "pylint",       -- Python code analysis
        "marksman", -- add more arguments for adding more null-ls sources
        "google-java-format",  -- Add Java formatter
        "checkstyle",         -- Add Java style checker
      },
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- overrides `require("mason-nvim-dap").setup(...)`
    opts = {
      ensure_installed = {
        "python", -- add more arguments for adding more debuggers
        "java-debug-adapter",  -- Add Java debugger
        "java-test",          -- Add Java test runner
      },
    },
  },
}
