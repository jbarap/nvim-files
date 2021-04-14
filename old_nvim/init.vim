if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

"Plugins ----------------------------------------------------------------------
set nocompatible
filetype off

call plug#begin('~/.local/share/nvim/plugged')

Plug 'preservim/nerdtree'
Plug 'tomasr/molokai'
Plug 'phanviet/vim-monokai-pro'
Plug 'gruvbox-community/gruvbox'
Plug 'ryanoasis/vim-devicons'
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'chrisbra/Colorizer'
Plug 'powerline/fonts'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'Valloric/ListToggle'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'kalekundert/vim-coiled-snake'
Plug 'Konfekt/FastFold'
Plug 'tpope/vim-commentary'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'jeetsukumaran/vim-pythonsense'
Plug 'liuchengxu/vista.vim'
Plug 'tpope/vim-fugitive'
Plug 'ntpeters/vim-better-whitespace'
Plug 'christoomey/vim-tmux-navigator'
Plug 'RyanMillerC/better-vim-tmux-resizer'
Plug 'sheerun/vim-polyglot'
Plug 'alvan/vim-closetag'
Plug 'heavenshell/vim-pydocstring', { 'do': 'make install' }
Plug 'tpope/vim-repeat'
Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'svermeulen/vim-subversive'
Plug 'mhinz/vim-startify'
Plug 'unblevable/quick-scope'
Plug 'goerz/jupytext.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
" Plug 'jupyter-vim/jupyter-vim'
Plug 'bfredl/nvim-ipy'
Plug 'mvanderkamp/vim-pudb-and-jam'
Plug 'svermeulen/vim-macrobatics'
Plug 'michaeljsmith/vim-indent-object'
Plug 'python-rope/ropevim'
Plug 'eugen0329/vim-esearch'
Plug 'wellle/targets.vim'

call plug#end()

"Remaps -----------------------------------------------------------------------

let mapleader=" "

inoremap jk <Esc>l
inoremap JK <Esc>l

nnoremap <silent><C-M-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><C-M-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>

nnoremap <silent><M-.> :bnext<CR>
nnoremap <silent><M-,> :bprevious<CR>

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap ( f)i
nnoremap ) $i
nnoremap <silent> x :<c-u>call NoDotX(v:count1)<CR>

tnoremap <Esc> <C-\><C-n>
tnoremap <silent>jk <C-\><C-n>

nmap ]f <Plug>(PythonsenseStartOfNextPythonFunction)
nmap ]F <Plug>(PythonsenseEndOfPythonFunction)
nmap [f <Plug>(PythonsenseStartOfPythonFunction)
nmap [F <Plug>(PythonsenseEndOfPreviousPythonFunction)
nmap ]c <Plug>(PythonsenseStartOfNextPythonClass)
nmap [c <Plug>(PythonsenseStartOfPythonClass)

" Leader/Plugs
map      <silent><leader>n :NERDTreeToggle<CR>
nnoremap <silent><leader><Space> :set relativenumber!<CR>
noremap <Leader>y "+yg_
noremap <Leader>p "+p
nnoremap <silent><leader><CR> :noh<CR>
nnoremap <silent><leader>tt :Vista!!<CR>

nnoremap <leader>w :StripWhitespace<CR>

nmap s <plug>(SubversiveSubstitute)
vmap s <plug>(SubversiveSubstitute)
nmap ss <plug>(SubversiveSubstituteLine)
nmap S <plug>(SubversiveSubstituteToEndOfLine)

nmap <Leader>b1 <Plug>lightline#bufferline#go(1)
nmap <Leader>b2 <Plug>lightline#bufferline#go(2)
nmap <Leader>b3 <Plug>lightline#bufferline#go(3)
nmap <Leader>b4 <Plug>lightline#bufferline#go(4)
nmap <Leader>b5 <Plug>lightline#bufferline#go(5)
nmap <Leader>b6 <Plug>lightline#bufferline#go(6)

nmap <silent> <Tab> :Semshi goto name next<CR>
nmap <silent> <S-Tab> :Semshi goto name prev<CR>

nmap <silent> <leader>pd <Plug>(pydocstring)

nmap <leader>gh :diffget //2<CR>
nmap <leader>gl :diffget //3<CR>
nmap <leader>gs :G <CR>

nmap <leader>rf <Plug>(coc-codeaction-selected)

nnoremap <leader>md :MarkdownPreview<CR>

" nmap <leader>jpc :JupyterConnect<CR>
" vmap <leader>jps :JupyterSendRange<CR>
" nmap <leader>jpd :JupyterDisconnect<CR>

nnoremap <C-p> :GFiles<CR>
nnoremap <C-f> :Files<CR>
nnoremap <leader>rg :Rg<space>

nnoremap <leader>dbc :<C-U>PudbClearAll<CR>
nnoremap <leader>dbl :<C-U>PudbList<CR>
nnoremap <leader>dbb :<C-U>PudbToggle<CR>
nnoremap <leader>dbs oimport pudb; pu.db<Esc>

nmap <nowait> q <plug>(Mac_Play)
nmap <nowait> gq <plug>(Mac_RecordNew)
nmap <leader>mh :DisplayMacroHistory<cr>
nmap [m <plug>(Mac_RotateBack)
nmap ]m <plug>(Mac_RotateForward)
nmap <leader>ma <plug>(Mac_Append)
nmap <leader>mp <plug>(Mac_Prepend)
nmap <leader>mn <plug>(Mac_NameCurrentMacro)
nmap <leader>me <plug>(Mac_SearchForNamedMacroAndPlay)
nmap <leader>ms <plug>(Mac_SearchForNamedMacroAndSelect)

nmap <silent>]q :cnext<CR>
nmap <silent>[q :cprev<CR>
nmap <silent>[Q :clast<CR>
nmap <silent>[Q :cfirst<CR>

" Plugins Config ---------------------------------------------------------------

" Lightline
let g:lightline = {
		\'colorscheme': 'custom_nord',
		\'active': {
		\	'left': [ [ 'mode', 'paste' ],
		\			  [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
		\	'right':[ [ 'lineinfo' ],
		\			  [ 'totalLines' ],
		\			  [ 'fileencoding', 'filetype' ] ]
		\},
		\'inactive': {
		\	'left': [ ['readonly', 'filename', 'modified'] ],
		\	'right':[ [ 'lineinfo' ],
		\			  [ 'totalLines' ],
		\			  [ 'fileencoding', 'filetype'] ]
		\},
                \'component': {
                \   'totalLines': "%3p%% %{printf('(%03d)', line('$'))}"
                \},
		\'component_function': {
                \   'gitbranch': 'LightlineFugitive'
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
let g:semshi#error_sign = v:false
let g:semshi#filetypes = ['python']

" indentLine
let g:indentLine_char  = '▏'
let g:indentLine_fileType = ['c', 'cpp', 'python']

" NerdTree
let NERDTreeShowHidden = 1

" ListToggle
let g:lt_location_list_toggle_map = '<leader>l'
let g:lt_quickfix_list_toggle_map = '<leader>q'

" Fast fold
let g:fastfold_savehook = 1
let g:fastfold_fold_command_suffixes =  ['x','X','a','A','o','O','c','C']
let g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']

" Pydocstring
let g:pydocstring_doq_path = "/home/john/.local/bin/doq"

" ALE
source $HOME/.config/nvim/plug-config/ale.vim

" Coc
source $HOME/.config/nvim/plug-config/coc.vim

" Startify
source $HOME/.config/nvim/plug-config/start-screen.vim

" Quickscope
let g:qs_max_chars=150
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
highlight QuickScopePrimary guifg='#00C7DF' gui=underline ctermfg=155 cterm=underline
highlight QuickScopeSecondary guifg='#afff5f' gui=underline ctermfg=81 cterm=underline

" Markdown Preview
let g:mkdp_auto_close = 0

" Jupyter vim
let g:jupyter_mapkeys = 0

" Pydocstring (google, sphinx, numpy)
let g:pydocstring_formatter = 'google'
let g:python_style = 'google'

" Vista
let g:vista_default_executive = 'coc'
let g:vista_echo_cursor_strategy = 'floating_win'
let g:vista_cursor_delay = 800

" Jupyter
" TODO: close the kernel automatically
" command! -nargs=0 RunQtConsole
"     \ call jobstart("jupyter qtconsole --JupyterWidget.include_other_output=True")

fu! RunQtConsole()
    !jupyter kernelspec list
    let kernel = input("Choose the notebook's kernel: ")
    let jupyter_command = "jupyter qtconsole --JupyterWidget.include_other_output=True --kernel=" .. kernel
    :call jobstart(jupyter_command)
endfunction

let g:ipy_celldef = '^##' " regex for cell start and end
let g:nvim_ipy_perform_mappings = 0

nmap <silent> <leader>jqt :call RunQtConsole()<Enter>
nmap <silent> <leader>jk :IPython<Space>--existing<Space>--no-window<CR>
nmap <silent> <leader>jr <Plug>(IPy-Run)
nmap <silent> <leader>jc <Plug>(IPy-RunCell)
nmap <silent> <leader>ja <Plug>(IPy-RunAll)
nmap <silent> <leader>jt <Plug>(IPy-Terminate)

" Tmux
let g:tmux_resizer_resize_count = 1  " horizontal
let g:tmux_resizer_vertical_resize_count = 1  " vertical


" Options ----------------------------------------------------------------------
let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
set mouse=a

set 		number
syntax 		on
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab

colorscheme gruvbox
set background=dark
let s:molokai_original = 0

set 	  colorcolumn=80
highlight LineNr ctermbg=234
highlight Comment gui=bold
highlight MatchParen cterm=none ctermbg=none ctermfg=202
highlight Flake8_Error ctermbg=124
highlight Flake8_Warning ctermbg=142 ctermfg=233
highlight Pmenu ctermfg=15 ctermbg=234 guifg=#bababa guibg=#1f1f1f
highlight ExtraWhitespace ctermbg=235

set completeopt-=preview
set incsearch ignorecase smartcase hlsearch
set noshowmode
set nofoldenable
set foldlevel=1
set splitbelow
set splitright
set wrap!
set scrolloff=3
set smartcase
set pumheight=15
set nohlsearch
set diffopt+=vertical
set hidden
set formatoptions-=cro

"Other ------------------------------------------------------------------------
filetype plugin indent on
let g:python3_host_prog = '/usr/bin/python3'
let python_highlight_all = 0
let python_highlight_space_errors = 0

" cmd/func
autocmd VimEnter  * nnoremap <silent><leader>bn :bnext<CR>
autocmd VimEnter  * nnoremap <silent><leader>bd :bd<CR>
autocmd VimEnter * nnoremap <C-I> <C-I>
autocmd BufEnter  * set foldlevel=1
" autocmd BufWritePost *.py call flake8#Flake8()
autocmd BufRead,BufNewFile *.py let python_highlight_all=1
autocmd BufRead,BufNewFile *.md let conceallevel=0
autocmd VimEnter * call SetColors()
autocmd FileType qf call AdjustWindowHeight(3, 10)
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
autocmd FileType python setlocal indentkeys-=<:>
autocmd FileType python setlocal indentkeys-=:
autocmd FileType fzf tnoremap <buffer> <Esc> <Esc>
autocmd VimEnter * nmap <silent> <Tab> :Semshi goto name next<CR>


function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

function NoDotX(count)
    normal! mx
    let xcol = col(".")-1
    silent execute ':.s/.\{' . xcol . '}\zs.\{' . a:count . '}//'
    normal! `x
endfunction

function! LightlineFugitive()
    if exists('*FugitiveHead')
        let branch = FugitiveHead()
        return branch !=# '' ? ' '.branch : ''
    endif
    return ''
endfunction

function! SetColors()
    hi semshiLocal           ctermfg=209
    hi semshiGlobal          ctermfg=172    guifg=#CC7E00
    hi semshiImported        ctermfg=172    guifg=#CC7E00
    hi semshiParameter       ctermfg=75     guifg=#83a598
    hi semshiParameterUnused ctermfg=117    guifg=#98c0b1
    hi semshiFree            ctermfg=84     guifg=#3CC687
    hi semshiBuiltin         ctermfg=112    guifg=#33A12F
    hi semshiAttribute       ctermfg=49     guifg=#3BA1C2
    hi semshiSelf            ctermfg=249
    hi semshiUnresolved      ctermfg=226    guifg=#ECDD57
    hi semshiSelected        ctermfg=231

    hi semshiErrorSign       ctermfg=231 gui=underline
    hi semshiErrorChar       ctermfg=231 gui=underline
    sign define semshiError text=E texthl=semshiErrorSign


    if g:colors_name ==# "molokai" || g:colors_name ==# "gruvbox"
        set cursorline
        hi CursorLine           guibg=#101010
        hi Normal               guibg=#090909
        hi MatchParen           gui=none       guibg=none      guifg=#BF4900
        hi LineNr               guibg=#121212  guifg=#5E5E5E
        hi Comment              guibg=none     guifg=#343434
        hi ExtraWhitespace      guibg=#292929
        hi ColorColumn          guibg=#101010
        hi Visual               guibg=#4A4A4A
        hi Error                guibg=#121212  guifg=#FFFFFF gui=underline
        hi Todo                 guibg=#121212
        hi SignColumn           guibg=#121212
        hi CursorLineNr         guibg=#101010

        hi ALEError             guibg=#121212 guifg=#EB4034
        hi ALEStyleError        guibg=#121212
        hi ALEErrorSign         guibg=#121212 guifg=#EB4034
        hi ALEWarning           guibg=#121212
        hi ALEWarningSign       guibg=#121212
        hi ALEStyleWarning      guibg=#121212
        hi ALEInfo              guibg=#121212

        hi CocHighlightText     guibg=#121212 gui=underline
    endif

endfunction

