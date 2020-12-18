"     ________          _________  
"   /          \      /          \
"  |            |    |            |
"   \_        _/      \_          |
"     |      |          /        /
"     |      |        /        /
"     |      |      /        /
"     |      |    /        /
"     |      |  /        /
"     |      |/        / _
"     |              / /_ /
"     |            / ___    ___    __   __
"     |          /  /   /  /   \_ |  \_|  \
"     |        /    /  /   /   _     _    /
"     |      /     /  /   /  /  /  /  /  /
"      \__ /      /___/  /___/ /___/ /___/ rc
"      
"    ~/.vimrc

" Set encoding
set enc=utf-8
let mapleader=" "
set clipboard+=unnamedplus
set mouse=a
set wildmode=longest,list,full
set splitbelow splitright

map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

"" PLUGINS SECTION
"  all plugins are installed in ~/.vim/plugged
call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'tomasiser/vim-code-dark'
call plug#end()

"" SOME TWEAKS
" enable 256 color pallete for the terminal
set t_Co=256
set t_ut=
"set termguicolors

" set current color scheme
colorscheme codedark
let g:airline_theme = 'codedark'

" set syntax and disable bells
syntax on
set noerrorbells visualbell

" clear screen when exiting
autocmd VimLeave * :!clear

" open PNG files in hex mode
autocmd BufReadPost *.png :%!xxd

" display row counter
set number relativenumber

"" COC SETUP
"set hidden
"set nobackup
"set nowritebackup
"set cmdheight=2
"set updatetime=300
"set shortmess+=c
"set signcolumn=yes
"
"inoremap <silent><expr> <TAB>
"	\ pumvisible() ? "\<C-n>" :
"	\ <SID>check_back_space() ? "\<TAB>" :
"	\ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
"
"function! s:check_back_space() abort
"	let col = col('.') - 1
"	return !col || getline('.')[col - 1] =~# '\s'
"endfunction
"
"inoremap <silent><expr> <c-space> coc#refresh()
"
"if exists('*complete_info')
"  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
"else
"  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"endif
"
"nnoremap <silent> K :call <SID>show_documentation()<CR>
"
"function! s:show_documentation()
"	if (index(['vim','help'], &filetype) >= 0)
"		execute 'h '.expand('<cword>')
"	else
"		call CocActionAsync('doHover')
"	endif
"endfunction

" highlight current symbol
"autocmd CursorHold * silent call CocActionAsync('highlight')

"set tabstop=4 shiftwidth=4 softtabstop=0 expandtab smarttab

