" vim-plug
call plug#begin('~/.vim/plugged')

" Plugins
" Bundle 'docunext/closetag.vim'
"
" color schemes
Plug 'crusoexia/vim-monokai'
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
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'LunarWatcher/auto-pairs'
" Plug 'github/copilot.vim'

call plug#end()

syntax on

set ml mls=5

set cindent

" Whether or not to use spaces in replace of tabs
set expandtab

" Note:
" Keep the following two consistent!!!

" The width of \t characters shown on the screen
set tabstop=8

" The width to shift on each >> or << commands
set shiftwidth=8

" Mix tabs and spaces to reach the visible width on each tab key pressed
set softtabstop=-1

" textwidth, wrapping lines to 80 in length
set tw=80

" colorcolumn, show a colored ruler there
set colorcolumn=80,100

set autoindent
set hlsearch
set incsearch
"set smartindent
set nocompatible
set noesckeys
set backspace=indent,eol,start
set nu
set relativenumber
" Encodings
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

" Highlight tab space and etc.
set list listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·

colorscheme PaperColor
set background=light

let mapleader = ' '

filetype plugin on

" Define functions
function! GreatbridfRun(filename)
    if a:filename =~ "\\.rs$"
        execute("!rustc -o ./.__gbtmp " . a:filename . "&&./.__gbtmp&&rm ./.__gbtmp")
        return
    endif

    if a:filename =~ "\\.c$"
        execute("!gcc -Werror -Wall -o ./.__gbtmp " . a:filename . "&&./.__gbtmp&&rm ./.__gbtmp")
        return
    endif

    if a:filename =~ "\\.cpp$" || a:filename =~ "\\.cc$"
        execute("!g++ -Werror -Wall -std=c++2a -o ./.__gbtmp " . a:filename . "&&./.__gbtmp&&rm ./.__gbtmp")
        return
    endif

    if a:filename =~ "\\.py$"
        execute("!python3 " . a:filename)
        return
    endif

    if a:filename =~ "\\.js$"
        execute("!node " . a:filename)
        return
    endif

    echo "No action available for file " . a:filename
endfunction

" Swap 0 and ^
nnoremap 0 ^
nnoremap ^ 0

" Map shortcuts
nmap <silent><leader>tr :NERDTreeToggle<CR>
" nmap <C-g> :GitGutterToggle<CR>
" imap <TAB> <C-p>
imap jk <ESC>
nmap <silent><leader>tt :tabnew<CR>
nmap <silent><leader>tn :tabnext<CR>
nmap yall Gvgg"+y
nmap <silent><leader>run :call GreatbridfRun(expand("%:t"))<CR>
nmap <silent><leader><CR> :nohl<CR>
nmap <silent><leader>s :<C-u>CocList -I symbols<CR>
nmap <leader>cpp :set filetype=cpp<CR> :set syntax=cpp<CR>

" Emmet config

let g:user_emmet_install_global = 0
let g:user_emmet_leader_key=','

autocmd FileType html,css,vue EmmetInstall
autocmd BufRead,BufNewFile *.ts set filetype=typescript

function s:GreatbridfPopupFilter(winid, key)
        if a:key == "\<c-j>"
                call win_execute(a:winid, "normal! \<c-e>")
        elseif a:key == "\<c-k>"
                call win_execute(a:winid, "normal! \<c-y>")
        elseif a:key == "\<c-d>"
                call win_execute(a:winid, "normal! \<c-d>")
        elseif a:key == "\<c-u>"
                call win_execute(a:winid, "normal! \<c-u>")
        elseif a:key == "\<c-c>" || a:key == "q"
                call popup_close(a:winid)
        else
                return v:false
        endif

        return v:true
endfunction

function GreatbridfGitShow(commit)
        call system("git describe --always " . a:commit)

        if v:shell_error != 0
                echohl WarningMsg
                        \ | echo a:commit . " is not a valid git commit"
                        \ | echohl None
                return 1
        endif

        let l:winid = popup_create(systemlist("git show " . a:commit), #{
                                \ pos: 'topleft', moved: 'WORD',
                                \ line: 'cursor+1', col: 'cursor',
                                \ border: [],
                                \ minwidth: &columns / 2,
                                \ maxwidth: &columns - 6,
                                \ filter: 's:GreatbridfPopupFilter',
                                \ filtermode: 'n',
                                \ })
        call setbufvar(winbufnr(l:winid), '&ft', 'git')
endfunction

command -nargs=1 GreatbridfGitShow call GreatbridfGitShow(<q-args>)

autocmd FileType git,gitrebase set kp=:GreatbridfGitShow

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

" coc.nvim
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> <C-a> <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> fe <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>ff  <Plug>(coc-format-selected)
nmap <leader>ff  <Plug>(coc-format-selected)

xmap <leader>fa  <Plug>(coc-format)
nmap <leader>fa  <Plug>(coc-format)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

nnoremap <silent> <leader>hint :CocCommand document.toggleInlayHint<CR>
nnoremap <silent> <leader>w= <C-w>110\|
nnoremap <silent> <leader>wh <C-w>h<C-w>110\|
nnoremap <silent> <leader>wj <C-w>j<C-w>110\|
nnoremap <silent> <leader>wk <C-w>k<C-w>110\|
nnoremap <silent> <leader>wl <C-w>l<C-w>110\|

vnoremap <silent> <leader>wr( c(<C-r>")<ESC>
vnoremap <silent> <leader>wr" c"<C-r>""<ESC>
vnoremap <silent> <leader>wr' c'<C-r>"'<ESC>
vnoremap <silent> <leader>wr{ c{<C-r>"}<ESC>
vnoremap <silent> <leader>wr[ c[<C-r>"]<ESC>
vnoremap <silent> <leader>wr< c<<C-r>"><ESC>

nnoremap <silent> <leader>un( yi(va(p
nnoremap <silent> <leader>un" yi"va"p
nnoremap <silent> <leader>un' yi'va'p
nnoremap <silent> <leader>un{ yi{va{p
nnoremap <silent> <leader>un[ yi[va[p
nnoremap <silent> <leader>un< yi<va<p

" git mergetool
nnoremap <silent> <leader>dl :diffget LOCAL<CR>
nnoremap <silent> <leader>db :diffget BASE<CR>
nnoremap <silent> <leader>dr :diffget REMOTE<CR>

" git merge
nnoremap <silent> <leader>mn /<<<<<<<<CR>
nnoremap <silent> <leader>mp ?<<<<<<<<CR>

nnoremap <silent> <leader>hn /^@@<CR>t(*N<C-w>ln
nnoremap <silent> <leader>hp ?^@@<CR>t(*N<C-w>ln

nnoremap <silent> <leader>gcp :!git cpick <cword><CR>

function! Merged()
	if getline(1,'$') == [''] || g:merged_sure == 1
		execute("silent !rm %")
		execute("qa")
	else
		echohl WarningMsg
		echo "Current buffer is not empty, are you sure?"
		echohl None
		let g:merged_sure = 1
	endif
endfunction

function! FindUpstream()
	r!git log --oneline --no-patch --grep="Fixes: $(echo <cword> | head -c 12)" refs/tags/v5.4..refs/remotes/upstream/master | tac
endfunction

nnoremap <silent> <leader>mu :call FindUpstream()<CR>

let g:merged_sure = 0
command Mrgd call Merged()
nnoremap <silent> <leader>md :Mrgd<CR>

" Remap <C-f> and <C-b> for scroll float windows/popups.
nnoremap <expr><C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <expr><C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
nnoremap <expr><C-d> coc#float#has_scroll() ? coc#float#scroll(1, 10) : "\<C-d>"
nnoremap <expr><C-u> coc#float#has_scroll() ? coc#float#scroll(0, 10) : "\<C-u>"

inoremap <expr><C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<Right>"
inoremap <expr><C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<Left>"
inoremap <expr><C-d> coc#float#has_scroll() ? coc#float#scroll(1, 10) : "\<Right>"
inoremap <expr><C-u> coc#float#has_scroll() ? coc#float#scroll(0, 10) : "\<Left>"
