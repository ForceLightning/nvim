return {
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            {
                "mfussenegger/nvim-dap",
                config = function()
                    local dap = require('dap')
                    local widgets = require('dap.ui.widgets')
                    -- Execution keymaps
                    vim.keymap.set('n', '<F5>', function() dap.continue() end,
                        { desc = "Continue execution" })
                    vim.keymap.set('n', '<F10>', function() dap.step_over() end,
                        { desc = "Step over execution" })
                    vim.keymap.set('n', '<F11>', function() dap.step_into() end,
                        { desc = "Step into execution" })
                    vim.keymap.set('n', '<F12>', function() dap.step_out() end,
                        { desc = "Step out of execution" })

                    -- Breakpoints keymaps
                    vim.keymap.set('n', '<leader>db', function() dap.toggle_breakpoint() end,
                        { desc = "[D]ebug Toggle [B]reakpoint" })
                    vim.keymap.set('n', '<leader>dB', function() dap.set_breakpoint() end,
                        { desc = "[D]ebug Set [B]reakpoint" })
                    vim.keymap.set('n', '<leader>dc',
                        function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
                        { desc = "[D]ebug Breakpoint [C]ondition" })
                    vim.keymap.set('n', '<leader>dlp',
                        function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end,
                        { desc = "Set [D]ebug [L]og [P]oint message" })
                    vim.keymap.set('n', '<leader>dr', function() dap.repl.open() end, { desc = "[D]ebug [R]eplay" })
                    vim.keymap.set('n', '<leader>dl', function() dap.run_last() end, { desc = "[D]ebug run [L]ast" })
                    vim.keymap.set('n', '<leader>du', function() require('dapui').toggle() end,
                        { desc = "Toggle [D]ebug [U]I" })

                    -- UI keymaps
                    vim.keymap.set({ 'n', 'v' }, '<leader>dh', function()
                        widgets.hover()
                    end, { desc = "[D]ebug UI [H]over" })
                    vim.keymap.set({ 'n', 'v' }, '<leader>dp', function()
                        widgets.preview()
                    end, { desc = "[D]ebug UI [P]review" })
                    vim.keymap.set('n', '<leader>df', function()
                        widgets.centered_float(widgets.frames)
                    end, { desc = "[D]ebug UI [F]loat" })
                    vim.keymap.set('n', '<leader>ds', function()
                        widgets.centered_float(widgets.scopes)
                    end, { desc = "[D]ebug UI [S]copes" })

                    -- LLDB
                    dap.adapters.codelldb = {
                        type = "server",
                        host = "127.0.0.1",
                        port = "${port}",
                        executable = {
                            command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb",
                            args = { "--port", "${port}", },
                            detached = false,
                        }
                    }

                    -- Python
                    dap.defaults.python.exception_breakpoints = { 'raised' }
                end,
            },
            "nvim-neotest/nvim-nio",
            {
                "folke/lazydev.nvim",
                ft = { "lua", "python" },
            },
        },
        config = function()
            local dap = require('dap')
            local dapui = require('dapui')
            dapui.setup()

            dap.listeners.after.event_initialized['dapui_config'] = function()
                dapui.open()
            end

            dap.listeners.before.event_terminated['dapui_config'] = function()
                dapui.close()
            end

            dap.listeners.before.event_exited['dapui_config'] = function()
                dapui.close()
            end
        end,
    },

    {
        "mfussenegger/nvim-dap-python",
        ft = { 'python' },
        config = function()
            local dap = require('dap')
            local dapui = require('dapui')
            local dap_python = require('dap-python')

            local function get_python_path()
                local handle = io.popen("pipenv --py")
                local result = "python"
                if handle ~= nil then
                    result = handle:read("*a")
                    handle:close()
                else
                    local test_path = vim.fn.getcwd() .. '/venv/bin/python'
                    handle = io.popen(test_path .. " -V")
                    if handle ~= nil then
                        result = test_path
                        handle:close()
                    end
                end
                return result
            end

            -- Modify default configs.

            local path = get_python_path()

            local configs = dap.configurations.python or {}
            dap.configurations.python = configs
            table.insert(configs,
                -- Launch files
                {
                    type = 'python',
                    request = 'launch',
                    name = 'Launch file',
                    program = '${file}',
                    console =
                    'integratedTerminal',
                    pythonPath = path,
                    justMyCode = false,
                }
            )
            -- Launch file with arguments (modified)
            table.insert(configs,
                {
                    type = 'python',
                    request = 'launch',
                    name = 'Launch file with arguments',
                    program = '${file}',
                    args = function()
                        local args_string = vim.fn.input('Arguments: ')
                        return vim.split(args_string, " +")
                    end,
                    console = 'integratedTerminal',
                    pythonPath = path,
                    justMyCode = false,
                })
            -- Attach remote
            table.insert(configs,
                {
                    type = 'python',
                    request = 'attach',
                    name = 'Attach remote',
                    connect = function()
                        local host = vim.fn.input('Host [127.0.0.1]: ')
                        host = host ~= '' and host or '127.0.0.1'
                        local port = tonumber(vim.fn.input('Port [5678]: ')) or 5678
                        return { host = host, port = port }
                    end
                })
            -- Doctests
            table.insert(configs,
                {
                    type = 'python',
                    request = 'launch',
                    name = 'Run doctests in file',
                    module = 'doctest',
                    args = { "${file}" },
                    noDebug = true,
                    console =
                    'integratedTerminal',
                    pythonPath = path,
                }
            )

            local opts = {
                include_configs = false,
            }

            -- dap_python.setup(path)
            dap_python.setup("python", opts)



            -- Function to resolve path to python to use for program or test execution.
            -- By default the `VIRTUAL_ENV` and `CONDA_PREFIX` environment variables are
            -- used if present.
            dap_python.resolve_python = get_python_path
        end,
        dependencies = {
            "mfussenegger/nvim-dap"
        }
    },
    {
        "ldelossa/nvim-dap-projects"
    }
}
