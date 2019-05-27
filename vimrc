syntax on
set expandtab
"set cindent
"set softtabstop=4
set shiftwidth=2
set autoindent
set hlsearch
set incsearch
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
imap <TAB> <C-p>
map <C-t><C-t> :tabnew<CR>
map <C-t><C-n> :tabnext<CR>
nmap yall Gvgg"+y
nmap <C-t><C-r> :execute "!g++ ".expand("%:t")."&&./a.out&&rm a.out"<CR>

" Emmet config

let g:user_emmet_leader_key=','
