"Plugins ----------------------------------------------------------------------
set nocompatible
filetype off

call plug#begin('~/.local/share/nvim/plugged')

Plug 'preservim/nerdtree'
Plug 'tomasr/molokai'
Plug 'ryanoasis/vim-devicons'
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'chrisbra/Colorizer'
Plug 'powerline/fonts'
Plug 'ycm-core/YouCompleteMe'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'davidhalter/jedi-vim'
Plug 'nvie/vim-flake8'
Plug 'Valloric/ListToggle'
Plug 'kien/ctrlp.vim'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'kalekundert/vim-coiled-snake'
Plug 'Konfekt/FastFold'
Plug 'tpope/vim-commentary'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'jeetsukumaran/vim-pythonsense'
Plug 'majutsushi/tagbar'

call plug#end()

"Remaps -----------------------------------------------------------------------

" Native
inoremap jk <Esc>

nnoremap <silent><A-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><A-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

tnoremap <Esc> <C-\><C-n>

map ]f <Plug>(PythonsenseStartOfNextPythonFunction)
map ]F <Plug>(PythonsenseEndOfPythonFunction)
map [f <Plug>(PythonsenseStartOfPythonFunction)
map [F <Plug>(PythonsenseEndOfPreviousPythonFunction)

" Leader
let mapleader=" "
map      <leader>n :NERDTreeToggle<CR>
nmap     <leader>go :Goyo<CR>
nnoremap <leader>gtd :YcmCompleter GoTo<CR>
nnoremap <leader>gtr :YcmCompleter GoToReferences<CR>
nnoremap <leader>gt :YcmCompleter GetType<CR>
nnoremap <leader>gd :YcmCompleter GetDoc<CR>
nnoremap <silent><leader>f za
nnoremap <silent><leader><Space> :set number! relativenumber!<CR>
noremap <Leader>y "+yg_
noremap <Leader>p "+p
nnoremap <leader>e :call flake8#Flake8ShowError()<CR>
nnoremap <silent><leader><CR> :noh<CR>
nnoremap <silent><leader>t :TagbarToggle<CR>
nmap <Leader>b1 <Plug>lightline#bufferline#go(1)
nmap <Leader>b2 <Plug>lightline#bufferline#go(2)
nmap <Leader>b3 <Plug>lightline#bufferline#go(3)
nmap <Leader>b4 <Plug>lightline#bufferline#go(4)
nmap <Leader>b5 <Plug>lightline#bufferline#go(5)
nmap <Leader>b6 <Plug>lightline#bufferline#go(6)

" Plugins Config ---------------------------------------------------------------

" Lightline
let g:lightline = {
		\'colorscheme': 'custom_nord',
		\'active': {
		\	'left': [ [ 'mode', 'paste' ], 
		\			  [ 'readonly', 'filename', 'modified' ] ],
		\	'right':[ [ 'lineinfo' ],
		\			  [ 'percent' ],
		\			  [ 'fileencoding', 'filetype' ] ]
		\},
		\'inactive': {
		\	'left': [ ['readonly', 'filename', 'modified'] ],
		\	'right':[ [ 'lineinfo' ],
		\			  [ 'percent' ],
		\			  [ 'fileencoding', 'filetype'] ]
		\},
		\'component_function': {
		\},
		\}

let g:lightline#bufferline#show_number  = 2
let g:lightline#bufferline#shorten_path = 1
let g:lightline#bufferline#unnamed      = '[No Name]'
let g:lightline#bufferline#filename_modifier = ':t'

let g:lightline.tabline          = {'left': [['buffers']], 'right': [[]]}
let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
let g:lightline.component_type   = {'buffers': 'tabsel'}
let g:lightline#bufferline#enable_devicons  = 1
let g:lightline#bufferline#min_buffer_count = 2

" Semshi
let g:semshi#mark_selected_nodes = 0
let g:semshi#error_sign_delay = 4

" Jedi
let g:jedi#auto_vim_configuration   = 0
let g:jedi#use_splits_not_buffers   = "bottom"
let g:jedi#popup_on_dot			    = 0
let g:jedi#popup_select_first       = 0
let g:jedi#goto_command             = ""
let g:jedi#goto_assignments_command = ""
let g:jedi#goto_stubs_command       = ""
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command    = ""
let g:jedi#usages_command           = ""
let g:jedi#completions_command      = ""
let g:jedi#rename_command           = ""

" indentLine
let g:indentLine_char  = '▏'

" NerdTree
let NERDTreeShowHidden = 1

" Supertab
let g:SuperTabDefaultCompletionType = "<c-n>"

" YCM
let g:ycm_auto_trigger = 1

" ListToggle
let g:lt_location_list_toggle_map = '<leader>l'
let g:lt_quickfix_list_toggle_map = '<leader>q'

" Flake8
let g:flake8_show_quickfix  = 0
let g:flake8_show_in_gutter = 1
let g:flake8_show_in_file   = 1
let flake8_error_marker     ='✖'
let flake8_warning_marker   ='!'

" Fast fold
let g:fastfold_savehook = 1
let g:fastfold_fold_command_suffixes =  ['x','X','a','A','o','O','c','C']
let g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']

" Pydocstring


" Options ----------------------------------------------------------------------
let $NVIM_TUI_ENABLE_TRUE_COLOR = 1

set 		number
syntax 		on
colorscheme molokai

set 	  colorcolumn=80
highlight LineNr ctermbg=234
highlight Comment gui=bold
highlight MatchParen cterm=none ctermbg=none ctermfg=202
highlight Flake8_Error ctermbg=124
highlight Flake8_Warning ctermbg=142 ctermfg=233
highlight Pmenu ctermfg=15 ctermbg=234 guifg=#ffffff guibg=#000000

set completeopt-=preview
set incsearch ignorecase smartcase hlsearch
set noshowmode
set nofoldenable
set foldlevel=1
set softtabstop=0 noexpandtab
set splitbelow
set splitright
set tabstop=4
set wrap!
set scrolloff=2
set smartcase
set pumheight=15

"Other ------------------------------------------------------------------------
filetype plugin indent on
let g:python3_host_prog = '/usr/bin/python3'


" cmd/func
autocmd VimEnter  * nnoremap <C-L> <C-W><C-L>
autocmd VimEnter  * nnoremap <silent><leader>bn :bnext<CR>
autocmd VimEnter  * nnoremap <silent><leader>bd :bd<CR>
autocmd BufAdd    * nnoremap <C-L> <C-W><C-L>
autocmd BufCreate * nnoremap <C-L> <C-W><C-L>
autocmd BufNew    * nnoremap <C-L> <C-W><C-L>
autocmd BufEnter  * nnoremap <C-L> <C-W><C-L>
autocmd BufEnter  * set foldlevel=1
autocmd BufWritePost *.py call flake8#Flake8()
autocmd BufRead,BufNewFile *.py let python_highlight_all=1
autocmd VimEnter * call SetColors()
autocmd FileType qf call AdjustWindowHeight(3, 10)
autocmd FileType python nnoremap <leader>y :0,$!yapf<Cr><C-o>
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab 

function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

function! SetColors()
		hi semshiLocal           ctermfg=209
		hi semshiGlobal          ctermfg=172
		hi semshiImported        ctermfg=172
		hi semshiParameter       ctermfg=75
		hi semshiParameterUnused ctermfg=117
		hi semshiFree            ctermfg=84
		hi semshiBuiltin         ctermfg=112
		hi semshiAttribute       ctermfg=49
		hi semshiSelf            ctermfg=249
		hi semshiUnresolved      ctermfg=226
		hi semshiSelected        ctermfg=231

		hi semshiErrorSign       ctermfg=231
		hi semshiErrorChar       ctermfg=231
		sign define semshiError text=E texthl=semshiErrorSign
endfunction

