return {
    "uga-rosa/cmp-dictionary",
    config = function()
        local dict_path = vim.fn.stdpath("config") .. "/files/german_words.txt"

        -- Track current dictionary state
        local is_german = true

        -- Set up cmp-dictionary
        require("cmp_dictionary").setup({
            paths = {dict_path},
            exact_length = 2,
            first_case_insensitive = true,
            async = false
        })

        -- Get the current sources from cmp
        local cmp = require("cmp")
        local default_sources = cmp.get_config().sources

        -- Function to toggle dictionary
        local function toggle_dictionary()
            if vim.bo.filetype ~= "markdown" then
                vim.notify("Dictionary toggle only works in markdown files", vim.log.levels.WARN)
                return
            end

            is_german = not is_german

            if is_german then
                -- Switch to German dictionary
                require("cmp_dictionary").setup({
                    paths = {dict_path},
                    exact_length = 2,
                    first_case_insensitive = true,
                    async = false
                })
                require("cmp_dictionary").update()

                -- Set up sources with German dictionary
                local german_sources = {{
                    name = "dictionary",
                    priority = 1000
                }}
                for _, source in ipairs(default_sources) do
                    table.insert(german_sources, source)
                end
                cmp.setup.buffer({
                    sources = german_sources
                })
            else
                -- Switch to English spell checking
                local english_sources = {{
                    name = "spell",
                    priority = 1000
                }}
                for _, source in ipairs(default_sources) do
                    table.insert(english_sources, source)
                end
                cmp.setup.buffer({
                    sources = english_sources
                })
            end

            -- Notify user
            vim.notify("Switched to " .. (is_german and "German" or "English") .. " completion", vim.log.levels.INFO)
        end

        -- Set up keybinding for dictionary toggle using leader key
        vim.keymap.set('n', '<leader>tl', toggle_dictionary, {
            noremap = true,
            silent = true,
            desc = "Toggle between German/English completion"
        })

        -- Set up markdown-specific configuration
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "markdown",
            callback = function()
                -- Enable spell checking
                vim.opt_local.spell = true
                vim.opt_local.spelllang = "en,de"

                require("cmp_dictionary").update()

                -- Add dictionary to existing sources for markdown files
                local markdown_sources = {{
                    name = "dictionary",
                    priority = 1000
                }}
                -- Append existing sources
                for _, source in ipairs(default_sources) do
                    table.insert(markdown_sources, source)
                end

                cmp.setup.buffer({
                    sources = markdown_sources
                })
            end
        })
    end
}
