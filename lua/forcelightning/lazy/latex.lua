return {
    {
        "lervag/vimtex",
        lazy = false,
        -- tag = "v2.15", uncomment to pin to a specific release.
        init = function()
            -- VimTex configuration goes here, e.g.
            vim.cmd [[
                let g:tex_flavor = 'latex'
                let g:vimtex_view_method = 'mupdf'
                let g:vimtex_quickfix_mode = 0
            ]]
        end
    },

    {
        'KeitaNakamura/tex-conceal.vim',
        init = function()
            vim.cmd [[
                set conceallevel=1
                let g:tex_conceal='abdmg'
                hi Conceal ctermbg=none
            ]]
        end
    }
}
