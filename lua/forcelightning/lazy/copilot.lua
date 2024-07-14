return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = {
                    auto_trigger = true,
                    keymap = {
                        accept = false,
                    }
                },
                filetypes = {
                    sh = function()
                        if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
                            -- disable for .env files
                            return false
                        end
                        return true
                    end
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

            -- Toggles copilot
            vim.keymap.set("n", "<leader>tc", ":Copilot toggle<CR>",
                { noremap = true, silent = true, desc = "[T]oggle [C]opilot completions" })
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
