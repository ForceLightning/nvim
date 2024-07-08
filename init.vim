" so <sfile>:h/plugins.vim

" lua require('config')
lua require('init')

if exists('g:vscode')
    set number relativenumber
else
    " map <C-p> :NERDTreeToggle<CR>
    " map ; :Files<CR>
    " nnoremap <silent> <S-f> :Ag<CR>
endif
" set statusline=2
set number relativenumber
set spelllang=en_gb
set backspace=indent,eol,start
set autoindent
set smartindent
set showcmd
colorscheme tokyonight-night
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab
set timeoutlen=100

set laststatus=2
autocmd FileType json syntax match Comment +\/\/.\+$+

set hidden

set cmdheight=1
set updatetime=300
set shortmess+=c

" Fzf config
let g:fzf_vim = {}
let g:fzf_vim.preview_bash = 'C:\Program Files\Git\bin\bash.exe'

" Pydocstring settings
autocmd FileType python setlocal tabstop=4 shiftwidth=4 smarttab expandtab
let g:pydocstring_enable_mapping = 0
let g:pydocstring_formatter = 'sphinx'
nmap <silent> <M-B> <Plug>(pydocstring)

" Allow saving of files as sudo when forgetting to start vim as sudo
cmap w!! w !sudo tee > /dev/null %

" Automatically correct spellcheck errors in line.
" inoremap <M-L> <C-g>u<Esc>[s1z=`]a<C-g>u
