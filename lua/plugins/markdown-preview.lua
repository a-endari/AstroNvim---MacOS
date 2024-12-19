return {
    "iamcco/markdown-preview.nvim",
    event = "BufRead",
    keys = {{
        "<leader>mp",
        function()
            -- Toggle our custom state variable
            vim.b.markdown_preview_on = not vim.b.markdown_preview_on
            vim.cmd("MarkdownPreviewToggle")

            if vim.b.markdown_preview_on then
                vim.notify("Markdown Preview: ON", vim.log.levels.INFO, {
                    title = "Markdown Preview",
                    icon = "📖"
                })
            else
                vim.notify("Markdown Preview: OFF", vim.log.levels.INFO, {
                    title = "Markdown Preview",
                    icon = "📚"
                })
            end
        end,
        desc = "Markdown Preview Toggle"
    }},
    build = function(plugin)
        if vim.fn.executable "npx" then
            vim.cmd("!cd " .. plugin.dir .. " && cd app && npx --yes yarn install")
        else
            vim.cmd [[Lazy load markdown-preview.nvim]]
            vim.fn["mkdp#util#install"]()
        end
    end,
    init = function()
        if vim.fn.executable "npx" then
            vim.g.mkdp_filetypes = {"markdown"}
        end
        -- Initialize our custom state variable
        vim.b.markdown_preview_on = false
    end,
    config = function()
        vim.g.mkdp_auto_start = 0
        vim.g.mkdp_auto_close = 1
        vim.g.mkdp_refresh_slow = 0
        vim.g.mkdp_browser = "" -- Use default browser
    end,
    ft = {"markdown"}
}