return {
    "tpope/vim-fugitive",
    config = function()
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = '[G]it [S]tatus' })

        local chris_fugitive = vim.api.nvim_create_augroup("Chris_Fugitive", {})
        local autocmd = vim.api.nvim_create_autocmd
        autocmd("BufWinEnter", {
            group = chris_fugitive,
            pattern = "*",
            callback = function()
                if vim.bo.ft ~= "fugitive" then
                    return
                end

                local bufnr = vim.api.nvim_get_current_buf()

                vim.keymap.set("n", "<leader>gp", function()
                    vim.cmd.Git('push')
                end, { buffer = bufnr, remap = false, desc = "[G]it [p]ush" })

                -- rebase always
                vim.keymap.set("n", "<leader>gP", function()
                    vim.cmd.Git({ 'pull', '--rebase' })
                end, { buffer = bufnr, remap = false, desc = "[G]it [P]ull (rebase)" });

                -- Git blame the current file
                vim.keymap.set("n", "<leader>gb", function()
                    vim.cmd.Git('blame')
                end, { buffer = bufnr, remap = false, desc = "[G]it [B]lame" })
            end,
        })

        vim.api.nvim_command([[
            hi DiffAdd gui=NONE guifg=green guibg=black
            hi DiffChange gui=NONE guifg=yellow guibg=black
            hi DiffDelete gui=NONE guifg=red guibg=black
        ]])
    end
}
