"     ________          _________  
"   /          \      /          \
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
"   init.vim (Neovim)

"" PLUGINS
"  all plugins are installed in ~/.local/share/nvim/vim-plug
call plug#begin('~/.local/share/nvim/vim-plug')
" Tools
    " Plug 'junegunn/goyo.vim'
    " Plug 'vifm/vifm.vim'
    " Plug 'mcchrish/nnn.vim'
" Code completion, syntax highlighting
    " Plug 'neoclide/coc.nvim', { 'branch': 'release' }
    Plug 'tpope/vim-markdown'
    Plug 'luochen1990/rainbow'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'vim-scripts/AutoComplPop'
" Themes
    Plug 'morhetz/gruvbox'
    " Plug 'tomasiser/vim-code-dark'
call plug#end()

" Load my status line
source ~/.config/nvim/statusline.vim

"" BASIC SETTINGS
" Set encoding
filetype plugin indent on
syntax on
set encoding=utf-8
set clipboard+=unnamedplus
set mouse=a
set path+=**
set complete+=kspell
set completeopt+=menuone
" set wildmode=longest,list,full
set wildmode=full
set wildmenu
set wildignore+=/usr/include/** " Default path that loads neovim
set wildignore+=**/target/** " Typical dirs to discard binary files for projectts
set wildignore+=**/bin/** " If a file in these dirs has to be edited, use edit
set splitbelow splitright
set noerrorbells visualbell
set nobackup nowritebackup

set softtabstop=4 shiftwidth=4 expandtab

" set current color scheme
colorscheme gruvbox
set background=dark cursorline termguicolors
let g:rainbow_active = 0

"" VARIABLES
let $CONFIG_DIR = "~/.config/nvim/"
let $CONFIG = "~/.config/nvim/init.vim"

"" CUSTOM COMMANDS
command VisitConfig call VisitConfig()
command MakeTags !ctags -R .

" AUTO COMMANDS
" open PNG files in hex mode
autocmd BufReadPost *.png :%!xxd
" Rainbow parentheses in lisp files
autocmd BufEnter *.scm :RainbowToggleOn
autocmd BufLeave *.scm :RainbowToggleOff

"" KEY BINDINGS
let mapleader=","
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Go to config
nnoremap <C-c>e :VisitConfig<CR>
nnoremap <C-g> <Esc>
nnoremap <C-h> :h 
nnoremap <C-x>b :b 
nnoremap <C-x>k :bd<CR>
nnoremap <C-p> :find 

"" FUNCTIONS
function VisitConfig()
    :e $CONFIG
    :echo "Jump to" $CONFIG
endfunction

