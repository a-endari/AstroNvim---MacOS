-- for it to work: you have to add the "german_words.txt" from my dropbox important files to /Library/Spelling/german_words.txt
return {
    "uga-rosa/cmp-dictionary",
    config = function()
        local dict_path = os.getenv("HOME") .. "/Library/Spelling/german_words.txt"
        
        -- Set up cmp-dictionary
        require("cmp_dictionary").setup({
            paths = { dict_path },
            exact_length = 2,
            first_case_insensitive = true,
            async = false
        })

        -- Set up nvim-cmp
        local cmp = require("cmp")
        cmp.setup({
            sources = {
                { name = "dictionary", priority = 1000 },
                { name = "buffer" },
            }
        })

        -- Set up markdown-specific configuration
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "markdown",
            callback = function()
                require("cmp_dictionary").update()
                
                cmp.setup.buffer({
                    sources = {
                        { name = "dictionary", priority = 1000 },
                        { name = "buffer" },
                    }
                })
            end
        })
    end
}
