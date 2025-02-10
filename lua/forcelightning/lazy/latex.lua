return {
    {
        "lervag/vimtex",
        lazy = false,
        -- tag = "v2.15", uncomment to pin to a specific release.
        init = function()
            if vim.loop.os_uname().sysname == "Windows_NT" then
                vim.cmd [[
                    let g:vimtex_view_general_viewer = "SumatraPDF"
                ]]
            else
                vim.cmd [[
                    let g:vimtex_view_method = "skim"
                ]]
            end
            -- VimTex configuration goes here, e.g.
            vim.cmd [[
                let g:tex_flavor = 'latex'
                let g:vimtex_quickfix_mode = 0
                let g:tex_conceal='abdmg'
                let g:vimtex_compiler_method='latexmk'
                let g:vimtex_env_toggle_math_map= {
                \   '$' : '\(',
                \   '$$': '\[',
                \   '\[': 'equation',
                \   '\(': '\[',
                \   'equation': '\(',
                \}
            ]]
        end
    },

    -- {
    --     'KeitaNakamura/tex-conceal.vim',
    --     init = function()
    --         vim.cmd [[
    --             set conceallevel=1
    --             let g:tex_conceal='abdmg'
    --             hi Conceal ctermbg=none
    --         ]]
    --     end
    -- }
}
