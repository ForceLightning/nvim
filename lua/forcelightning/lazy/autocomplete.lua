return {
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        commit = "7e348da",
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            {
                'L3MON4D3/LuaSnip',
                build = (function()
                    -- Build Step is needed for regex support in snippets.
                    -- This step is not supported in many windows enveironments.
                    -- Remove the below condition to re-enable on windows.
                    if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
                        return
                    end
                    return 'make install_jsregexp'
                end)(),
                dependencies = {
                    -- `friendly-snippets` contains a variety of premade snippets.
                    --  See the README about individual language/framework/plugin snippets:
                    --  https://github.com/rafamadriz/friendly-snippets
                    {
                        'rafamadriz/friendly-snippets',
                        config = function(_, opts)
                            if opts then require('luasnip').config.setup(opts) end
                            vim.tbl_map(
                                function(type)
                                    require('luasnip.loaders.from_' .. type).lazy_load {
                                        exclude = { "tex", "latex" },
                                    }
                                end,
                                { "vscode", "snipmate", "lua" }
                            )
                            -- friendly snippets - enable standarised comments snippets
                            require("luasnip").filetype_extend("typescript", { "tsdoc" })
                            require("luasnip").filetype_extend("javascript", { "jsdoc" })
                            require("luasnip").filetype_extend("lua", { "luadoc" })
                            require("luasnip").filetype_extend("python", { "pydoc" })
                            require("luasnip").filetype_extend("rust", { "rustdoc" })
                            require("luasnip").filetype_extend("cs", { "csharpdoc" })
                            require("luasnip").filetype_extend("java", { "javadoc" })
                            require("luasnip").filetype_extend("c", { "cdoc" })
                            require("luasnip").filetype_extend("cpp", { "cppdoc" })
                            require("luasnip").filetype_extend("php", { "phpdoc" })
                            require("luasnip").filetype_extend("kotlin", { "kdoc" })
                            require("luasnip").filetype_extend("ruby", { "rdoc" })
                            require("luasnip").filetype_extend("sh", { "shelldoc" })
                        end,
                    },
                },
                config = function()
                    local ls = require("luasnip")
                    require("luasnip.loaders.from_snipmate").lazy_load({ paths = { "./snippets" } })
                    require("luasnip.loaders.from_lua").lazy_load({ paths = { "./lua-snippets" } })

                    vim.keymap.set('n', '<leader>sl', function()
                        require('luasnip.loaders').edit_snippet_files()
                    end, { noremap = true, silent = true, desc = "[S]earch [L]uaSnippets" })
                end
            },
            'saadparwaiz1/cmp_luasnip',

            -- Adss other completion capabilities.
            --  nvim-cmp does not ship with all sources by default. They are split into multiple
            --  repos for maintenance purposes.
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
        },
        config = function()
            -- See `:help cmp`
            local cmp = require 'cmp'
            local luasnip = require 'luasnip'
            luasnip.config.setup {}

            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = { completeopt = 'menu,menuone,noinsert' },

                -- For an understanding of why these mappings were chosen, you will need to read
                -- `:help ins-completion`
                --
                -- No, but seriously. Please read `:help ins-completion`, it is really good!
                mapping = cmp.mapping.preset.insert {
                    -- Select the [n]ext item
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    -- Select the [p]revious item
                    ['<C-p>'] = cmp.mapping.select_prev_item(),

                    -- Scroll the documentation window [b]ack / [f]orward
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),

                    -- Accept ([y]es) the completion.
                    --  This will auto-import if your LSP supports it.
                    --  This will expand snippets if the LSP sent a snippet.
                    ['<C-y>'] = cmp.mapping.confirm { select = true },

                    -- If you prefer more traditional completion keymaps,
                    -- you can uncomment the following lines:
                    -- ['<CR>'] = cmp.mapping.confirm { select = true },
                    -- ['<Tab>'] = cmp.mappin.select_next_item(),
                    -- ['<S-Tab>'] = cmp.mapping.select_prev_item(),

                    -- Manually trigger a completion from nvim-cap.
                    --  Generally you wouldn't need this, because nvim-cap will display completions
                    --  whenever it has completion options available.
                    ['<C-Space>'] = cmp.mapping.complete {},

                    -- Think of <c-l> as moving to the right of your snippet expansion.
                    --  So if you have a snippet that's like:
                    --  function $name($args)
                    --      $body
                    --  end
                    --
                    --  <c-l> will move you to the right of each of the expansion locations.
                    --  <c-h> is similar, except moving you backwards.
                    ['<C-l>'] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end, { 'i', 's' }),
                    ['<C-h>'] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { 'i', 's' }),

                    -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion)
                    -- see:
                    --  https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'path' },
                    { name = "lazydev", group_index = 0, }
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered()
                },
            }
            luasnip.config.set_config {
                history = false,
                enable_autosnippets = true,
            }
        end,
    },
}
