" vim-plug
call plug#begin('~/.vim/plugged')

" Plugins
" Bundle 'docunext/closetag.vim'
"
" color schemes
Plug 'crusoexia/vim-monokai'
Plug 'tomasr/molokai'
Plug 'joshdick/onedark.vim'
Plug 'NLKNguyen/papercolor-theme'

Plug 'scrooloose/nerdtree'
" Bundle 'matchit.zip'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go'
Plug 'tpope/vim-surround'
Plug 'mattn/emmet-vim'
" Bundle 'Valloric/MatchTagAlways'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'ycm-core/YouCompleteMe'
Plug 'Raimondi/delimitMate'

call plug#end()

syntax on
set expandtab
set cindent
"set softtabstop=4
set shiftwidth=4
set autoindent
set hlsearch
set incsearch
"set smartindent
set nocompatible
set noesckeys
set tabstop=4
set backspace=2
set nu
set relativenumber
" Encodings
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

filetype plugin on

" Map shortcuts
nmap <C-n> :NERDTreeToggle<CR>
nmap <C-g> :GitGutterToggle<CR>
imap <TAB> <C-p>
imap jk <ESC>
map <C-t><C-t> :tabnew<CR>
map <C-t><C-n> :tabnext<CR>
nmap yall Gvgg"+y
nmap <C-t><C-r> :execute "!g++ -Werror -Wall --std=c++2a ".expand("%:t")."&&./a.out&&rm a.out"<CR>
map <Enter> :nohl<CR>

" Emmet config

let g:user_emmet_install_global = 0
let g:user_emmet_leader_key=','

autocmd FileType html,css,vue EmmetInstall
autocmd BufRead,BufNewFile *.ts set filetype=typescript

" MatchTagAlways config

let g:mta_filetypes = {
  \ 'html': 1,
  \ 'xhtml': 1,
  \ 'xml': 1,
  \ 'jinja': 1,
  \}

" Highlight trailing spaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" YouCompleteMe
nmap <C-a> :YcmCompleter GoTo<CR>
let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py'
let g:ycm_collect_identifiers_from_tag_files = 1
set completeopt-=preview
