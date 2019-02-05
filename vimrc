syntax on
set expandtab
set cindent
set autoindent
set smartindent
set nocompatible
set tabstop=4
set softtabstop=4
set shiftwidth=4
set backspace=2
set nu

filetype plugin on

" Include Vundle
source ~/.vim/vundlerc

" Use molokai color scheme
colorscheme molokai
let g:molokai_original = 1

" Map shortcuts
map <C-n> :NERDTreeToggle<CR>

