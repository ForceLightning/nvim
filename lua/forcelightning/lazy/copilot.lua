return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        lazy = true,
        config = function()
            require("copilot").setup({
                suggestion = {
                    auto_trigger = true,
                    keymap = {
                        accept = false,
                    }
                },
                filetypes = {
                    ["."] = false,
                    sh = function()
                        if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
                            -- disable for .env files
                            return false
                        else
                            return true
                        end
                    end,
                }
            })

            -- Supertab
            vim.keymap.set("i", "<Tab>", function()
                local cs = require("copilot.suggestion")
                if cs.is_visible() then
                    cs.accept()
                else
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
                end
            end, { desc = "Super Tab" })

            vim.api.nvim_create_user_command("CopilotDisable", function(args)
                if args.bang then
                    -- CopilotDisable! will disable copilot just for this buffer
                    -- NOTE: Actually not sure if this does anything
                    vim.b.disable_copilot = true
                    vim.cmd(":Copilot disable")
                else
                    vim.g.disable_copilot = true
                    vim.cmd(":Copilot disable")
                end
                vim.print("Copilot disabled.")
            end, {
                desc = "Disable copilot",
                bang = true,
            })

            vim.api.nvim_create_user_command("CopilotEnable", function()
                vim.b.disable_copilot = false
                vim.g.disable_copilot = false
                vim.cmd(":Copilot enable")
                vim.print("Copilot enabled.")
            end, {
                desc = "Re-enable copilot",
            })

            vim.keymap.set("n", "<leader>tc", function()
                if vim.b.disable_copilot or vim.g.disable_copilot then
                    vim.cmd("CopilotEnable")
                else
                    vim.cmd("CopilotDisable")
                end
            end, { desc = "[T]oggle [C]opilot completions" })

            -- Disable copilot on load.
            vim.cmd("CopilotDisable")
        end,
    },

    {
        "AndreM222/copilot-lualine",
        dependencies = {
            "zbirenbaum/copilot.lua",
            "nvim-lualine/lualine.nvim"
        },
        lazy = true,
        after = { "zbirenbaum/copilot.lua" },
        event = "BufReadPost",
        config = function()
            local ll = require("lualine")
            ll.setup({
                sections = {
                    lualine_x = {
                        "copilot", "encoding", "fileformat", "filetype"
                    }
                }
            })
        end
    }
}
