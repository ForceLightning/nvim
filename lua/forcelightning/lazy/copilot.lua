return {
    "github/copilot.vim",
    config = function()
        vim.api.nvim_set_keymap('n', '<leader>tc', ':Copilot<CR>',
            { noremap = true, silent = true, desc = '[T]oggle [C]opilot' })
    end
}
