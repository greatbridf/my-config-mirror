syntax on
set expandtab
"set cindent
"set softtabstop=4
set shiftwidth=2
set autoindent
set smartindent
set nocompatible
set tabstop=2
set backspace=2
set nu

" Encodings
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

filetype plugin on

" Include Vundle
source ~/.vim/vundlerc

" Use molokai color scheme
colorscheme monokai

" Map shortcuts
nmap <C-n> :NERDTreeToggle<CR>
nmap <C-g> :GitGutterToggle<CR>
vmap <TAB> <ESC>
imap <TAB> <ESC>
map <C-t><C-t> :tabnew<CR>
map <C-t><C-n> :tabnext<CR>

