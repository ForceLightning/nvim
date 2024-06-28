return {
    "stevearc/conform.nvim",
    lazy = false,
    keys = {
        {
            '<M-F>',
            function()
                require('conform').format { async = true, lsp_fallback = true }
            end,
            mode = '',
            desc = '[F]ormat buffer',
        },
    },
    opts = {
        notify_on_error = false,
    },
    config = function()
        local slow_format_filetypes = {}
        require("conform").setup({
            formatters_by_ft = {
                python = { "black" },
                rust = { "rustfmt" },
            },

            format_on_save = function(bufnr)
                if slow_format_filetypes[vim.bo[bufnr].filetype] or vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                end
                local function on_format(err)
                    if err and err:match("timeout$") then
                        slow_format_filetypes[vim.bo[bufnr].filetype] = true
                    end
                end

                return { timeout_ms = 500, lsp_fallback = true }, on_format
            end,

            format_after_save = function(bufnr)
                if not slow_format_filetypes[vim.bo[bufnr].filetype] then
                    return
                end
                return { lsp_fallback = true }
            end,
        })

        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*",
            callback = function(args)
                require("conform").format({ bufnr = args.buf })
            end,
        })

        -- Format command
        vim.api.nvim_create_user_command("Format", function(args)
            local range = nil
            if args.count ~= -1 then
                local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                range = {
                    start = { args.line1, 0 },
                    ["end"] = { args.line2, end_line:len() },
                }
            end
            require("conform").format({ async = true, lsp_fallback = true, range = range })
        end, { range = true })

        -- Format disable command
        vim.api.nvim_create_user_command("FormatDisable", function(args)
            if args.bang then
                -- FormatDisable! will disable formatting just for this buffer
                vim.b.disable_autoformat = true
            else
                vim.g.disable_autoformat = true
            end
            vim.print("Formatting disabled.")
        end, {
            desc = "Disable autoformat-on-save",
            bang = true,
        })

        -- Format enable command
        vim.api.nvim_create_user_command("FormatEnable", function()
            vim.b.disable_autoformat = false
            vim.g.disable_autoformat = false
            vim.print("Formatting enabled.")
        end, {
            desc = "Re-enable autoformat-on-save",
        })

        -- Keymaps
        vim.keymap.set("", "<M-F>", function()
            require("conform").format({ async = true, lsp_fallback = true })
        end, { desc = "[F]ormat" })

        vim.keymap.set("n", "<leader>F", function()
            if vim.b.disable_autoformat or vim.g.disable_autoformat then
                vim.cmd("FormatEnable")
            else
                vim.cmd("FormatDisable")
            end
        end, { desc = "Toggle [F]ormat" })
    end
}
