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
colorscheme monokai

" Map shortcuts
nmap lb ^
nmap le $
nmap <C-n> :NERDTreeToggle<CR>
nmap <C-g> :GitGutterToggle<CR>
imap <C-i> <ESC>
map <C-t>t :tabnew<CR>
map <C-t>n :tabnext<CR>

