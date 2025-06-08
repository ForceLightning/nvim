return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs and related tools to stdpath for Neovim
            { 'williamboman/mason.nvim', config = true }, -- NOTE: must be loaded before dependants.
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',

            -- Useful status updates for LSP.
            { 'j-hui/fidget.nvim',       opts = {} },

            -- rustaceanvim
            {
                'mrcjkb/rustaceanvim',
                version = '^4', -- Recommended to avoid breaking changes.
                lazy = false,   -- The plugin is already lazy.
                -- config = function()
                --     vim.g.rustaceanvim = {
                --         server = {
                --             cmd = function()
                --                 local mason_registry = require('mason-registry')
                --                 local ra_binary = mason_registry.is_installed('rust-analyzer')
                --                     -- This may need to be tweeked, depending on the operating system.
                --                     and mason_registry.get_package('rust-analyzer'):get_install_path() .. "/rust-analyzer"
                --                     or "rust-analyzer"
                --                 return { ra_binary } -- You can add args to the list, such as `--log-file`.
                --             end,
                --         },
                --     }
                -- end,
            },

            -- lsp_signature
            {
                'ray-x/lsp_signature.nvim',
                event = 'VeryLazy',
                opts = {
                    bind = true,
                    handler_opts = {
                        border = 'rounded'
                    }
                },
                config = function(_, opts)
                    require('lsp_signature').setup(opts)
                    vim.api.nvim_create_autocmd("LspAttach", {
                        callback = function(args)
                            local bufnr = args.buf
                            local client = vim.lsp.get_client_by_id(args.data.client_id)
                            if client ~= nil then
                                if vim.tbl_contains({ 'null-ls' }, client.name) then -- blacklist lsp
                                    return
                                end
                            end
                            require('lsp_signature').on_attach(opts, bufnr)
                        end
                    })
                end
            -- LazyDev
            {
                "folke/lazydev.nvim",
                ft = "lua",
                opts = {
                    library = {
                        -- See configuration section for more details
                        -- Load luvit types when the `vim.uv` word is found
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    }
                }
            }
        },
        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
                callback = function(event)
                    -- Create a function that lets us more easily define mappings specific for LSP
                    -- related items. It sets the mode, buffer, and description for us each time.
                    local map = function(keys, func, desc)
                        vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end

                    -- Jump to the definition of the word under your cursor.
                    --   This is where the variable is first declared, or where a function is defined, etc.
                    --   To jump back, press <C-t>.
                    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

                    map('gsd', function()
                        require('telescope.builtin').lsp_definitions({ jump_type = "vsplit", reuse_win = true })
                    end, '[G]oto [D]efinitions ([S]plit)')

                    -- Find references for the word under your cursor.
                    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

                    -- Jump to the implementation of the word under your cursor.
                    --  Useful when you're not sure what type a variable is and you want to see the
                    --  definition of its *type*, not where it was *defined*.
                    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

                    -- Fuzzy find all the symbols in your current document.
                    --  Symbols are things like variables, functions, types, etc.
                    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

                    -- Fuzzy find all the symbols in your current workspace.
                    --  Simillar to document symbols, except it searches over your entire project.
                    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

                    -- Rename the variable under your cursor.
                    --  Most Language Servers support renaming across files, etc.
                    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

                    -- Execute a code action, usually your cursor needs to be on top of an error or
                    -- suggestion from your LSP for this to activate.
                    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

                    -- Opens a popup that displays documentation about your word under your cursor
                    --  See `:help K` for why this keymap.
                    -- map('K', vim.lsp.buf.hover, 'Hover Documentation')
                    vim.api.nvim_buf_set_keymap(event.buf, 'n', "K", "<cmd>lua vim.lsp.buf.hover()<CR>",
                        { desc = "LSP: Hover" })

                    -- WARN: This is not Goto Definition, this is Goto Declaration.
                    --  For example, in C this would take you to the header.
                    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                    -- The following two autocommands are used to highlight references of the word
                    -- under your cursor when your cursor rests there for a little while.
                    --  See `:help CursorHold` for information about when this is executed.
                    --
                    -- When you move your cursor, the highlights will be cleared (the second
                    -- autocommand).
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.documentHighlightProvider then
                        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight',
                            { clear = false })
                        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        })

                        vim.api.nvim_create_autocmd('LspDetach', {
                            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                            end,
                        })
                    end

                    -- The following autocommand is used to enable inlay hints in your code, if the
                    -- language server you are using supports them.
                    --
                    -- This may be unwanted, since they displace some of your code
                    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                        map('<leader>th', function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {})
                        end, '[T]oggle Inlay [H]ints')
                    end
                end,
            })

            -- LSP servers and clients are able to communicated to each other what features they
            -- support.
            --  By default, Neovim doesn't support everything that is in the LSP specification.
            --  When y ou add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
            --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

            -- Enable the following language servers
            --  Feel free to add/remove any LSPs that you want here. They will automatically be
            --  installed.
            --
            --  Add any additional override configuration in the following tables. Available keys are:
            --      - cmd (table): Override the default command used to start the server.
            --      - filetypes (table): Override the default list of associated filetypes for the
            --          server.
            --      - capabilities (table): Override fields in capabilities. Can be used to disable
            --          certain LSP features.
            --      - settings (table): Override the default settings passed when initalising the
            --          server. For example, to see the options for `lua_ls`, you could go to:
            --          https://luals.github.io/wiki/settings/

            -- local virtualenvs_dir = vim.fn.expand("$HOME/.virtualenvs/")

            local servers = {
                clangd = {},
                -- gopls = {},
                basedpyright = {
                    -- root_dir = require("lspconfig.util").find_git_ancestor,
                    -- settings = {
                    --     analysis = {
                    --         venvPath = virtualenvs_dir,
                    --     },
                    -- },
                },
                -- rust_analyzer = {},
                lua_ls = {
                    -- cmd = {...},
                    -- filetypes = {...},
                    -- capabilities = {},
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = 'Replace',
                            },
                            -- You can toggle below to ignore Lua_LS's noisy `missing_fields` warnings
                            -- diagnostics = { disable = { 'missing_fields' } },
                        },
                    },
                },
                ruff = {
                    init_options = {
                        settings = {
                            organizeImports = false,
                            showSyntaxErrors = true,
                            lint = {
                                enable = true,
                            },
                            logLevel = 'debug',
                        }
                    },
                    trace = 'messasges',
                }
            }

            -- Ensure the servers and tools above are installed
            --  To check the current status of installed tools and/or manually install other tools, you
            --  can run
            --      :Mason
            --
            --  You can press `g?` for help in this menu.
            require('mason').setup()

            -- You can add other tools here that you want Mason to install for you, so that they are
            -- available from within Neovim.
            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                'stylua', -- Used to format Lua code
            })
            require('mason-tool-installer').setup { ensure_installed = ensure_installed }

            require('mason-lspconfig').setup {
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        -- This handles overriding only values explicitly passed by the server
                        -- configuration above. Useful when disabling certain features of an LSP (for
                        -- example, turning off formatting for tsserver)
                        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                        require('lspconfig')[server_name].setup(server)
                    end,
                },
            }

            -- Use Ruff alongside Pyright
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client == nil then
                        return
                    end
                    if client.name == "ruff" then
                        -- Disable hover in favour of Pyright
                        client.server_capabilities.hoverProvider = false
                    end
                end,
                desc = "LSP: Disable hover capability from Ruff."
            })
        end,
    },
    {
        "chrisgrieser/nvim-lsp-endhints",
        event = "LspAttach",
        opts = {
            autoEnableHints = false
        },
    }
}
