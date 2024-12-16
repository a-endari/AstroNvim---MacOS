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
    },
    -- Add Python test runner
    {
      "nvim-neotest/neotest",
      dependencies = {
        "nvim-neotest/neotest-python",
      },
      config = function()
        require("neotest").setup({
          adapters = {
            require("neotest-python")({
              dap = { justMyCode = false },
              runner = "pytest",
            })
          }
        })
      end
    },
  }
  