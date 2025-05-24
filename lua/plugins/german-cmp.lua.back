return {
    "uga-rosa/cmp-dictionary",
    config = function()
        -- Basic setup
        local dict_paths = {
            german = vim.fn.stdpath("config") .. "/files/german_words.txt",
            english = vim.fn.stdpath("config") .. "/files/english_words.txt"
        }
        local is_german = true
        local cmp = require("cmp")

        -- Function to configure dictionary with current language
        local function setup_dictionary(use_german)
            require("cmp_dictionary").setup({
                paths = {use_german and dict_paths.german or dict_paths.english},
                exact_length = 2,
                first_case_insensitive = true,
                async = false
            })
            require("cmp_dictionary").update()
        end

        -- Function to setup completion sources
        local function setup_completion_sources()
            local sources = {{
                name = "dictionary",
                priority = 1000
            }}

            -- Get default sources excluding any existing dictionary source
            local default_sources = cmp.get_config().sources or {}
            for _, source in ipairs(default_sources) do
                if source.name ~= "dictionary" then
                    table.insert(sources, source)
                end
            end

            return sources
        end

        -- Toggle dictionary function
        local function toggle_dictionary()
            if vim.bo.filetype ~= "markdown" then
                vim.notify("Dictionary toggle only works in markdown files", vim.log.levels.WARN)
                return
            end

            is_german = not is_german
            setup_dictionary(is_german)

            cmp.setup.buffer({
                sources = setup_completion_sources()
            })

            vim.notify("Switched to " .. (is_german and "German" or "English") .. " completion", vim.log.levels.INFO)
        end

        -- Initial setup
        setup_dictionary(is_german)

        -- Set up keybinding for dictionary toggle
        vim.keymap.set('n', '<leader>tl', toggle_dictionary, {
            noremap = true,
            silent = true,
            desc = "Toggle between German/English completion"
        })

        -- Set up markdown-specific configuration
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "markdown",
            callback = function()
                vim.opt_local.spell = true
                vim.opt_local.spelllang = "en,de"

                cmp.setup.buffer({
                    sources = setup_completion_sources()
                })
            end
        })
    end
}
