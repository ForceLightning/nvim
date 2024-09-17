return {
    {
        'nvimtools/none-ls.nvim',
        config = function()
            local nls = require('null-ls')
            nls.setup({
                debounce = 150,
                save_after_format = false,
                sources = { nls.builtins.diagnostics.pylint, },
                debug = true,
            })
        end
    },
    'jay-babu/mason-null-ls.nvim',
}
