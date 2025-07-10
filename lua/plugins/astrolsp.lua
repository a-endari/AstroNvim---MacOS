-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
---@type LazySpec
return {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
        -- Configuration table of features provided by AstroLSP
        features = {
            autoformat = true, -- enable or disable auto formatting on start
            codelens = true, -- enable/disable codelens refresh on start
            inlay_hints = true, -- enable/disable inlay hints on start
            semantic_tokens = true -- enable/disable semantic token highlighting
        },
        -- customize lsp formatting options
        formatting = {
            format_on_save = {
                enabled = true -- enable or disable format on save globally
            },
            timeout_ms = 1000 -- default format timeout
        },
        -- enable servers that you already have installed without mason
        servers = {
            jdtls = {
                mason = false -- JDTLS will be handled by nvim-jdtls plugin
            }
        },
        -- customize language server configuration options passed to `lspconfig`
        config = {
            pylsp = {
                settings = {
                    pylsp = {
                        plugins = {
                            pycodestyle = {
                                enabled = false
                            },
                            mccabe = {
                                enabled = false
                            },
                            pyflakes = {
                                enabled = false
                            },
                            pylint = {
                                enabled = false
                            },
                            jedi_completion = {
                                enabled = true
                            },
                            jedi_hover = {
                                enabled = true
                            },
                            jedi_references = {
                                enabled = true
                            },
                            jedi_signature_help = {
                                enabled = true
                            },
                            jedi_symbols = {
                                enabled = true
                            }
                        }
                    }
                }
            }
        },
        -- customize how language servers are attached
        handlers = {
            basedpyright = false -- disable basedpyright completely
        },
        -- Configure buffer local auto commands to add when attaching a language server
        autocmds = {
            lsp_cleanup = {{
                event = "VimLeave",
                desc = "Stop all LSP clients on exit",
                callback = function()
                    local clients = vim.lsp.get_clients()
                    for _, client in ipairs(clients) do
                        vim.lsp.stop_client(client.id, true)
                    end
                end
            }}
        }
    }
}
