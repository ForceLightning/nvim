return {
    "terryma/vim-multiple-cursors",
    -- {
    --     "airblade/vim-gitgutter",
    --     config = function ()
    --         vim.keymap.set("
    --     end
    -- },

    "tpope/vim-sleuth",

    { "numToStr/Comment.nvim", opts = {} },

    {
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
        },
    },

    {
        'folke/which-key.nvim',
        event = 'VimEnter',
        config = function()
            require('which-key').setup()
            -- Document existing key chains
            require('which-key').add {
                { "<leader>c", group = "[C]ode" },
                { "<leader>d", group = "[D]ebug" },
                { "<leader>r", group = "[R]ename" },
                { "<leader>s", group = "[S]earch" },
                { "<leader>w", group = "[W]orkspace" },
                { "<leader>t", group = "[T]oggle" },
                { "<leader>x", group = "[X] Trouble" },
                { "<leader>u", group = "[U]ndo Tree" },
                { "<leader>g", group = "[G]it" },
            }
            -- Visual mode
            -- require('which-key').register({
            --     ['<leader>h'] = { 'Git [H]unk' },
            -- }, { mode = 'v' })
        end,
    },

    {
        'folke/tokyonight.nvim',
        priority = 1000,
        init = function()
            vim.cmd.colorscheme 'tokyonight-night'

            -- You can configure highlights by doing something like:
            vim.cmd.hi 'Comment gui=none'
        end,
    },

    {
        'folke/todo-comments.nvim',
        event = 'VimEnter',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {
            -- signs = false
            highlight = {
                before = "",
                keyword = "wide",
                after = "fg",
                pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]],
                comments_only = true,
                max_line_len = 400,
                exclude = {}
            },
            keywords = {
                GUARD = { icon = "", color = "warning" },
            },
            merge_keywords = true,
            search = {
                command = "rg",
                args = {
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                },
                pattern = [[\b(KEYWORDS):]]
            }
        },
        config = function(_, opts)
            require('todo-comments').setup(opts)

            -- Open TODOs in trouble
            vim.keymap.set("n", "<leader>xt", ":Trouble todo<CR>",
                { noremap = true, silent = true, desc = "[X]Trouble [T]ODO" })

            -- Open TODOs in Telescope
            vim.keymap.set("n", "<leader>st", ":TodoTelescope<CR>",
                { noremap = true, silent = true, desc = "[S]earch [T]ODO" })

            -- Jump to next/previous todo comment
            vim.keymap.set("n", "]t", function()
                require('todo-comments').jump_next()
            end, { desc = "Next [T]odo comment " })

            vim.keymap.set("n", "[t", function()
                require('todo-comments').jump_prev()
            end, { desc = "Previous [T]odo comment " })
        end
    },

    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup(
                require('lualine').get_config()
            )
        end,
    },

    {
        'andymass/vim-matchup',
        config = function()
            vim.g.matchup_matchparen_offscreen = { method = "popup" }
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
        }
    },

    {
        'Yggdroot/indentLine',
        config = function()
            vim.cmd [[
                let g:indentLine_setColors = 0
                let g:indentLine_defaultGroup = 'SpecialKey'
                let g:indentLine_char_list = ['|', '¦', '┆', '┊']
            ]]
        end
    },

    {
        "Bekaboo/deadcolumn.nvim",
        config = function(opts)
            require('deadcolumn').setup(opts)
        end
    },
}
