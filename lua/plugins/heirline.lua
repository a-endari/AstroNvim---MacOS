---@type LazySpec
return {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
        local status = require("astroui.status")

        local ViMode = {
            init = function(self)
                self.mode = vim.fn.mode(1)
            end,
            static = {
                mode_names = {
                    n = "N",
                    no = "N?",
                    nov = "N?",
                    noV = "N?",
                    ["no\22"] = "N?",
                    niI = "Ni",
                    niR = "Nr",
                    niV = "Nv",
                    nt = "Nt",
                    v = "V",
                    vs = "Vs",
                    V = "V_",
                    Vs = "Vs",
                    ["\22"] = "^V",
                    ["\22s"] = "^V",
                    s = "S",
                    S = "S_",
                    ["\19"] = "^S",
                    i = "I",
                    ic = "Ic",
                    ix = "Ix",
                    R = "R",
                    Rc = "Rc",
                    Rx = "Rx",
                    Rv = "Rv",
                    Rvc = "Rv",
                    Rvx = "Rv",
                    c = "C",
                    cv = "Ex",
                    r = "...",
                    rm = "M",
                    ["r?"] = "?",
                    ["!"] = "!",
                    t = "T"
                },
                mode_colors = {
                    n = "red",
                    i = "green",
                    v = "cyan",
                    V = "cyan",
                    ["\22"] = "cyan",
                    c = "orange",
                    s = "purple",
                    S = "purple",
                    ["\19"] = "purple",
                    R = "orange",
                    r = "orange",
                    ["!"] = "red",
                    t = "red"
                }
            },
            provider = function(self)
                return "%2(" .. self.mode_names[self.mode] .. "%)"
            end,
            hl = function(self)
                local mode = self.mode:sub(1, 1)
                return {
                    fg = self.mode_colors[mode],
                    bold = true
                }
            end,
            update = {
                "ModeChanged",
                pattern = "*:*",
                callback = vim.schedule_wrap(function()
                    vim.cmd("redrawstatus")
                end)
            }
        }

        -- ============================================================================
        -- CUSTOM STATUSLINE COMPONENTS
        -- ============================================================================

        -- Vim icon that changes color based on mode
        local AstroIcon = {
            init = function(self)
                self.mode = vim.fn.mode(1)
            end,
            static = {
                mode_colors = {
                    n = "red",
                    i = "green",
                    v = "cyan",
                    V = "cyan",
                    ["\22"] = "cyan",
                    c = "orange",
                    s = "purple",
                    S = "purple",
                    ["\19"] = "purple",
                    R = "orange",
                    r = "orange",
                    ["!"] = "red",
                    t = "red"
                }
            },
            provider = function()
                return "󰇴"
            end,
            hl = function(self)
                local mode = self.mode:sub(1, 1)
                return {
                    fg = self.mode_colors[mode],
                    bold = true
                }
            end,
            update = {
                "ModeChanged",
                pattern = "*:*",
                callback = vim.schedule_wrap(function()
                    vim.cmd("redrawstatus")
                end)
            }
        }

        -- Word count component (useful for writing)
        local WordCount = {
            condition = function()
                -- Only show for text files, markdown, etc.
                local ft = vim.bo.filetype
                return ft == "markdown" or ft == "text" or ft == "tex" or ft == "rst" or ft == "txt"
            end,
            provider = function()
                local wc = vim.fn.wordcount()
                local words = wc.words or 0
                return "󰈭 " .. words .. "w"
            end,
            hl = {
                fg = "cyan"
            },
            update = {"TextChanged", "TextChangedI", "BufEnter"}
        }

        -- Spacer component
        local Spacer = {
            provider = " "
        }

        -- Conditional spacer for word count
        local WordCountSpacer = {
            condition = function()
                -- Same condition as WordCount
                local ft = vim.bo.filetype
                return ft == "markdown" or ft == "text" or ft == "tex" or ft == "rst" or ft == "txt"
            end,
            provider = " "
        }

        -- File icon component
        local FileIcon = {
            init = function(self)
                local filename = vim.api.nvim_buf_get_name(0)
                local extension = vim.fn.fnamemodify(filename, ":e")
                self.icon, self.icon_color = require("mini.icons").get("file", filename)
                -- Convert color name to hex if it's a highlight group name
                if self.icon_color and type(self.icon_color) == "string" and self.icon_color:match("^Mini") then
                    local hl = vim.api.nvim_get_hl(0, {
                        name = self.icon_color
                    })
                    self.icon_color = hl.fg and string.format("#%06x", hl.fg) or "gray"
                end
            end,
            provider = function(self)
                return self.icon and (self.icon .. " ")
            end,
            hl = function(self)
                return {
                    fg = self.icon_color or "gray"
                }
            end
        }

        -- File name component
        local FileName = {
            provider = function()
                local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
                return filename == "" and "[No Name]" or filename
            end,
            hl = {
                fg = "gray"
            }
        }

        -- File size component
        local FileSize = {
            provider = function()
                local suffix = {'B', 'K', 'M', 'G', 'T', 'P', 'E'}
                local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
                fsize = (fsize < 0 and 0) or fsize
                if fsize < 1024 then
                    return " " .. fsize .. suffix[1] .. " "
                end
                local i = math.floor((math.log(fsize) / math.log(1024)))
                return " " .. string.format("%.1f%s", fsize / math.pow(1024, i), suffix[i + 1]) .. " "
            end,
            hl = {
                fg = "orange"
            }
        }

        -- File encoding (only show if not UTF-8)
        local FileEncoding = {
            provider = function()
                local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc
                return enc ~= 'utf-8' and enc:upper() or nil
            end,
            hl = {
                fg = "yellow"
            }
        }

        -- File format (only show if not unix)
        local FileFormat = {
            provider = function()
                local fmt = vim.bo.fileformat
                return fmt ~= 'unix' and fmt:upper() or nil
            end,
            hl = {
                fg = "yellow"
            }
        }

        -- Macro recording indicator
        local MacroRec = {
            condition = function()
                return vim.fn.reg_recording() ~= ""
            end,
            provider = function()
                return "󰑋 @" .. vim.fn.reg_recording()
            end,
            hl = {
                fg = "red",
                bold = true
            },
            update = {"RecordingEnter", "RecordingLeave"}
        }

        -- Working directory component
        local WorkDir = {
            provider = function()
                local cwd = vim.fn.getcwd(0)
                cwd = vim.fn.fnamemodify(cwd, ":~")
                if #cwd > 30 then
                    cwd = vim.fn.pathshorten(cwd)
                end
                return "󰉋 " .. cwd
            end,
            hl = {
                fg = "blue"
            }
        }

        -- ============================================================================
        -- COMPONENT GROUPS (for easy organization)
        -- ============================================================================

        -- Left side components
        local LeftComponents = {
            AstroIcon, 
            ViMode,
            Spacer, -- Space between mode and git branch
            status.component.git_branch(), -- Git branch second from left
            status.component.git_diff(),   -- Git status
            status.component.file_info(), 
            MacroRec -- Shows when recording macro
        }

        -- Middle components (diagnostics)
        local MiddleComponents = {
            status.component.diagnostics()
        }

        -- Right side components
        local RightComponents = {
            FileEncoding,   -- File encoding (if not UTF-8)
            FileFormat,     -- File format (if not unix)
            status.component.lsp(),
            status.component.treesitter(),
            WordCountSpacer, -- Space between treesitter and word count (conditional)
            WordCount,      -- Word count third from right
            status.component.nav(), -- Line position second from right
        }

        -- ============================================================================
        -- STATUSLINE ASSEMBLY
        -- ============================================================================
        -- To customize: comment/uncomment components or reorder them

        opts.statusline = {
            hl = {
                fg = "fg",
                bg = "bg"
            },

            -- Left side
            LeftComponents,

            -- Flexible space
            status.component.fill(),

            -- Middle (optional - comment out if you want more space)
            MiddleComponents,

            -- Flexible space
            status.component.fill(),

            -- Command info (shows when typing commands)
            status.component.cmd_info(),

            -- Right side
            RightComponents,

            -- Mode indicator (right-aligned)
            status.component.mode {
                surround = {
                    separator = "right"
                }
            }
        }

        -- ============================================================================
        -- CUSTOMIZATION NOTES:
        -- ============================================================================
        -- 1. To add/remove components: modify the component groups above
        -- 2. To change colors: modify the 'hl' tables in each component
        -- 3. To change conditions: modify the 'condition' functions
        -- 4. Word count shows only for markdown/text files
        -- 5. File encoding/format only show when different from defaults
        -- 6. Scroll bar updates on cursor movement
        -- 7. Search count shows when searching with cmdheight=0
        -- 8. Macro recording shows when recording macros
        -- ============================================================================

        return opts
    end
}
