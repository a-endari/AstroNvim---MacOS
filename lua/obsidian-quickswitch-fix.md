# Fixing Obsidian QuickSwitch Functionality on macOS

To fix the QuickSwitch functionality in obsidian.nvim on macOS, you need to make the following changes to your configuration:

1. Place this configuration in `plugins/obsidian-nvim.lua`:

```lua
return {
  "epwalsh/obsidian.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  cmd = {
    "ObsidianQuickSwitch",
    "ObsidianWorkspace",
  },
  keys = {
    {
      "<leader>os",
      "<cmd>ObsidianQuickSwitch<cr>",
      desc = "Quick Switch",
    },
  },
  opts = {
    dir = vim.fn.expand("~/Dropbox/Obsidian-Vaults"),
    finder = "telescope.nvim",
  },
}
```

## Key Changes Made

1. **Path Handling**: Using `vim.fn.expand()` for proper home directory expansion on macOS
2. **Dependencies**: Ensuring telescope.nvim is properly listed as a dependency
3. **Command Registration**: Explicitly registering the QuickSwitch command
4. **Lazy Loading**: Using command-based lazy loading instead of events
5. **Finder Configuration**: Explicitly setting telescope.nvim as the finder

## Additional Troubleshooting Steps

If QuickSwitch is still not working after applying this configuration:

1. Ensure telescope.nvim is properly installed and working
2. Verify the path in `dir` option points to your actual Obsidian vault location
3. Try running `:checkhealth obsidian` to verify the plugin's health
4. Make sure all dependencies are installed and up to date

## Common Issues on macOS

1. Path expansion issues with `~` or relative paths
2. Permission issues accessing Dropbox folders
3. Telescope.nvim not properly configured
4. Plugin loading order conflicts

The configuration above addresses these common issues by:
- Using proper path expansion
- Ensuring explicit dependency management
- Setting up correct lazy loading
- Providing minimal configuration to reduce potential conflicts