" Plugins ---------------------------------------------------------------------------------
set nocompatible
filetype off

call plug#begin('~/.local/share/nvim/plugged')



" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'deoplete-plugins/deoplete-jedi'
Plug 'preservim/nerdtree'
Plug 'tomasr/molokai'
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/goyo.vim'
Plug 'Yggdroot/indentLine'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
" Plug 'ervandew/supertab'
Plug 'jiangmiao/auto-pairs'
Plug 'chrisbra/Colorizer'
Plug 'heavenshell/vim-pydocstring'
Plug 'powerline/fonts'
Plug 'ycm-core/YouCompleteMe'
Plug 'itchyny/lightline.vim'



call plug#end()

" let g:deoplete#enable_at_startup = 1


" Remaps ------------------------------------------------------------------------------------

" Native
inoremap jk <Esc>

nnoremap <silent><A-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><A-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>
nnoremap <silent><C-B>n :bnext<CR>
nnoremap <silent><C-B>1 :b1<CR>
nnoremap <silent><C-B>2 :b2<CR>
nnoremap <silent><C-B>3 :b3<CR>
nnoremap <silent><CR> :noh<CR><CR>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <silent><C-space> za

nmap <silent><Space> :set number! relativenumber!<CR>

tnoremap <Esc> <C-\><C-n>


"Plugs
let mapleader=","
map <C-n> :NERDTreeToggle<CR>
nmap <leader>go :Goyo<CR>
nnoremap <leader>gtd :YcmCompleter GoTo<CR>
nnoremap <leader>gtr :YcmCompleter GoToReferences<CR>
nnoremap <leader>gt :YcmCompleter GetType<CR>
nnoremap <leader>gd :YcmCompleter GetDoc<CR>


" Plugins Config ---------------------------------------------------------------------------
 
" Lightline selenize_dark, nord, 
let g:lightline = {
		\'colorscheme': 'custom_nord',
		\'active': {
		\	'left': [ [ 'mode', 'paste' ], 
		\			  [ 'readonly', 'filename', 'modified' ] ],
		\	'right':[ [ 'lineinfo' ],
		\			  [ 'percent' ],
		\			  [ 'fileformat', 'fileencoding', 'filetype'] ]
		\},
		\'inactive': {
		\	'left': [ ['readonly', 'filename', 'modified'] ],
		\	'right':[ [ 'lineinfo' ],
		\			  [ 'percent' ],
		\			  [ 'fileformat', 'fileencoding', 'filetype'] ]
		\}
		\}

" indentLine
let g:indentLine_char='▏'

" NerdTree
let NERDTreeShowHidden=1

" Supertab
let g:SuperTabDefaultCompletionType = "<c-n>"



" Options ---------------------------------------------------------------------------------
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
"set t_Co=256
set number
syntax on
colorscheme molokai
highlight LineNr ctermbg=234
highlight Comment gui=bold
hi MatchParen cterm=none ctermbg=none ctermfg=202
set colorcolumn=80

set completeopt-=preview
set incsearch ignorecase smartcase hlsearch
set noshowmode

set tabstop=4
set softtabstop=0 noexpandtab

set splitbelow
set splitright


" Other
" -----------------------------------------------------------------------------------
filetype plugin indent on
let g:python3_host_prog = '/usr/bin/python3'



" VimEnter
autocmd VimEnter * RainbowParentheses .














