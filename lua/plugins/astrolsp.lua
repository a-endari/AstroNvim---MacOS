-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`

---@type LazySpec
return {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
        -- customize language server configuration options passed to `lspconfig`
        config = {
            pylsp = {
                settings = {
                    pylsp = {
                        plugins = {
                            pycodestyle = { enabled = false },
                            mccabe = { enabled = false },
                            pyflakes = { enabled = false },
                            pylint = { enabled = false },
                            jedi_completion = { enabled = true },
                            jedi_hover = { enabled = true },
                            jedi_references = { enabled = true },
                            jedi_signature_help = { enabled = true },
                            jedi_symbols = { enabled = true }
                        }
                    }
                }
            }
        },
        -- customize how language servers are attached
        handlers = {
            basedpyright = false, -- disable basedpyright completely
        }
    }
}