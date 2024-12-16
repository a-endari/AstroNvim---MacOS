local status_ok, jdtls = pcall(require, "jdtls")
if not status_ok then return end

-- Setup Workspace
local home = os.getenv "HOME"
local workspace_path = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local config_path = home .. "/.local/share/nvim/mason/packages/jdtls/config_"
local os_config = "linux" -- Change to 'mac' or 'win' depending on your OS

if vim.fn.has "mac" == 1 then
  os_config = "mac"
elseif vim.fn.has "win32" == 1 then
  os_config = "win"
end

-- Get the mason installation path
local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
local jdtls_path = mason_path .. "packages/jdtls/"

-- Main config
local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx4g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    vim.fn.glob(jdtls_path .. "plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration",
    config_path .. os_config,
    "-data",
    workspace_path,
  },

  root_dir = require("jdtls.setup").find_root { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" },

  settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      completion = {
        favoriteStaticMembers = {
          "org.junit.Assert.*",
          "org.junit.Assume.*",
          "org.junit.jupiter.api.Assertions.*",
          "org.junit.jupiter.api.Assumptions.*",
          "org.junit.jupiter.api.DynamicContainer.*",
          "org.junit.jupiter.api.DynamicTest.*",
        },
        importOrder = {
          "java",
          "javax",
          "com",
          "org",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        useBlocks = true,
      },
      configuration = {
        runtimes = {
          {
            name = "JavaSE-22", -- Using Java 22
            path = vim.fn.expand "$JAVA_HOME",
            -- Adjust this path to your Java installation
          },
        },
      },
    },
  },

  init_options = {
    bundles = {},
    extendedClientCapabilities = {
      progressReportProvider = true,
      classFileContentsSupport = true,
      generateToStringPromptSupport = true,
      hashCodeEqualsPromptSupport = true,
      advancedExtractRefactoringSupport = true,
      advancedOrganizeImportsSupport = true,
      generateConstructorsPromptSupport = true,
      generateDelegateMethodsPromptSupport = true,
      moveRefactoringSupport = true,
      overrideMethodsPromptSupport = true,
      inferSelectionSupport = { "extractMethod", "extractVariable", "extractConstant" },
    },
  },

  on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- LSP Mappings
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, bufopts)
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)

    -- Java specific
    vim.keymap.set("n", "<leader>ji", jdtls.organize_imports, bufopts)
    vim.keymap.set("n", "<leader>jt", jdtls.test_class, bufopts)
    vim.keymap.set("n", "<leader>jn", jdtls.test_nearest_method, bufopts)
    vim.keymap.set("v", "<leader>je", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", bufopts)
    vim.keymap.set("n", "<leader>je", jdtls.extract_variable, bufopts)
    vim.keymap.set("v", "<leader>jm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", bufopts)
  end,
}

-- Setup debug capabilities
local bundles = {
  vim.fn.glob(mason_path .. "packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true),
}

vim.list_extend(bundles, vim.split(vim.fn.glob(mason_path .. "packages/java-test/extension/server/*.jar", true), "\n"))
config.init_options.bundles = bundles

-- Add this before jdtls.start_or_attach(config)

-- Advanced Build and Run function for Java
local function build_and_run()
  -- Save the current buffer
  vim.cmd('write')
  
  -- Get file paths
  local filename = vim.fn.expand('%:t:r')  -- gets filename without extension
  local file_with_ext = vim.fn.expand('%:t')  -- gets filename with extension
  local directory = vim.fn.expand('%:p:h')  -- gets directory path
  
  -- Create a new terminal in a split window
  vim.cmd('split')
  vim.cmd('terminal')
  
  -- Wait briefly for terminal to initialize
  vim.defer_fn(function()
    -- Check if we're in a package
    local package_line = vim.fn.search('^package .*;$', 'n')
    local command
    
    if package_line > 0 then
      -- Get the package name
      local package = vim.fn.getline(package_line):match('package%s+(.+);')
      -- Go to src directory (assuming standard Maven/Gradle structure)
      local src_dir = directory
      while not vim.fn.fnamemodify(src_dir, ':t'):match('^src$') and src_dir ~= '/' do
        src_dir = vim.fn.fnamemodify(src_dir, ':h')
      end
      -- Compile and run with package
      command = string.format('cd "%s" && javac "%s" && java %s.%s\n', 
        src_dir,
        vim.fn.expand('%:p'):sub(#src_dir + 2),  -- relative path from src
        package,
        filename)
    else
      -- No package, simple compile and run
      command = string.format('cd "%s" && javac "%s" && java %s\n', 
        directory,
        file_with_ext,
        filename)
    end
    
    vim.fn.jobsend(vim.b.terminal_job_id, command)
  end, 100)
end



-- Add the keymapping to the existing on_attach function
local original_on_attach = config.on_attach
config.on_attach = function(client, bufnr)
  original_on_attach(client, bufnr)
  
  -- Add the Java run mapping
  vim.keymap.set('n', '<leader>jr', build_and_run, {
    noremap = true,
    silent = true,
    buffer = bufnr,
    desc = "Build and run Java file"
  })
  
  -- Add command for it too
  vim.api.nvim_buf_create_user_command(bufnr, 'JavaRun', build_and_run, {
    desc = 'Build and run Java file'
  })
end



-- The existing jdtls.start_or_attach(config) should be after this

-- Start the language server
jdtls.start_or_attach(config)
