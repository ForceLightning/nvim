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
            require('which-key').register {
                ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
                ['<leader>d'] = { name = '[D]ebug', _ = 'which_key_ignore' },
                ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
                ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
                ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
                ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
                ['<leader>x'] = { name = '[X] Trouble', _ = 'which_key_ignore' },
                ['<leader>u'] = { name = '[U]ndo Tree', _ = 'which_key_ignore' },
                ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
                -- ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
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
                keyword = "bg",
                after = "fg",
                pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]],
                comments_only = true,
                max_line_len = 400,
                exclude = {}
            },
            search = {
                command = "rg",
                args = {
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                },
                pattern = [[\b((KEYWORDS)%(\(.{-1,}\))?):]]
            }
        }
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
