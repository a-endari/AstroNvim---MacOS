return {
    -- Add Python docstring generator
{
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
    opts = {
        languages = {
            python = {
                template = {
                    annotation_convention = "google_docstrings"
                }
            }
        }
    }
}, -- Add Python test runner
{
    "nvim-neotest/neotest",
    dependencies = {"nvim-neotest/neotest-python"},
    config = function()
        require("neotest").setup({
            adapters = {require("neotest-python")({
                dap = {
                    justMyCode = false
                },
                runner = "pytest"
            })}
        })
    end
}, -- Configure Python LSP to only show runtime errors
{
     "neovim/nvim-lspconfig",
    opts = {
        servers = {
            pyright = {
                settings = {
                    python = {
                        pythonPath = vim.fn.exepath("python3") or vim.fn.exepath("python"),
                        venvPath = ".",
                        analysis = {
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            diagnosticMode = "workspace",
                            reportMissingModuleSource = false,
                            reportMissingImports = false,
                            reportImportCycles = false
                        }
                    }
                },
            },
            -- Alternative: python-lsp-server (uncomment to use instead of pyright)
            -- pylsp = {
            --     settings = {
            --         pylsp = {
            --             plugins = {
            --                 pycodestyle = { enabled = false },
            --                 mccabe = { enabled = false },
            --                 pyflakes = { enabled = true },
            --                 pylint = { enabled = false }
            --             }
            --         }
            --     }
            -- }
        },
        handlers = {
            basedpyright = false -- Disable basedpyright completely
        }
    },
    config = function()
        -- Stop basedpyright if it starts
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client and client.name == "basedpyright" then
                    vim.lsp.stop_client(client.id, true)
                end
            end
        })
    end
}, -- Configure null-ls tools to only show runtime errors
{
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
        local null_ls = require("null-ls")
        opts.sources = opts.sources or {}

        -- Add mypy with minimal error checking
        table.insert(opts.sources, null_ls.builtins.diagnostics.mypy.with({
            extra_args = {"--ignore-missing-imports", "--no-strict-optional", "--disable-error-code=import"}
        }))

        -- Add pylint with only error-level issues
        table.insert(opts.sources, null_ls.builtins.diagnostics.pylint.with({
            extra_args = {"--errors-only",
                          "--disable=missing-docstring,invalid-name,too-few-public-methods,import-error"}
        }))

        return opts
    end
}
}
