" Plugins ---------------------------------------------------------------------------------

call plug#begin('~/.local/share/nvim/plugged')

" Deoplete
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif



Plug 'deoplete-plugins/deoplete-jedi'
Plug 'preservim/nerdtree'
Plug 'tomasr/molokai'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/goyo.vim'
Plug 'Yggdroot/indentLine'
Plug 'junegunn/rainbow_parentheses.vim'


call plug#end()

let g:deoplete#enable_at_startup = 1


" Remaps ------------------------------------------------------------------------------------

" Native
inoremap jk <Esc>

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <S-CR> o
nmap <Space> :set number! relativenumber!<CR>


"Plugs
let mapleader=","
map <C-n> :NERDTreeToggle<CR>
nmap <leader>g :Goyo



" Plugins Config ---------------------------------------------------------------------------

" Airline
let g:airline_theme=''

" indentLine
let g:indentLine_char='▏'



" Options ---------------------------------------------------------------------------------

set number
syntax on
colorscheme molokai
highlight LineNr ctermbg=234





" Other
" -----------------------------------------------------------------------------------
filetype plugin indent on





" VimEnter
autocmd VimEnter * RainbowParentheses .














