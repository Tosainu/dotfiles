augroup MyVimrc
  autocmd!
augroup END

set nocompatible

" NeoBundle {{{
filetype off

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
  call neobundle#rc(expand('~/.vim/bundle/'))
endif

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/vimproc', {
      \   'build': {
      \     'unix': 'make -f make_unix.mak',
      \     'mac' : 'make -f make_mac.mak'
      \   }
      \ }
NeoBundle 't9md/vim-textmanip'
NeoBundle 'tomtom/tcomment_vim'

" Completetion
NeoBundleLazy 'mattn/emmet-vim', {
      \   'autoload': {'filetypes': ['html', 'xhtml', 'css']}
      \ }

" Languages
NeoBundleLazy 'vim-jp/cpp-vim', {
      \   'autoload': {'filetypes': 'cpp'}
      \ }
NeoBundleLazy 'JavaScript-syntax', {
      \   'autoload': {'filetypes': 'javascript'}
      \ }
NeoBundleLazy 'pangloss/vim-javascript', {
      \   'autoload': {'filetypes': 'javascript'}
      \ }
NeoBundleLazy 'vim-ruby/vim-ruby', {
      \   'autoload': {'filetypes': 'ruby'}
      \ }
NeoBundleLazy 'othree/html5.vim', {
      \   'autoload': {'filetypes': 'html'}
      \ }
NeoBundleLazy 'hail2u/vim-css3-syntax', {
      \   'autoload': {'filetypes': 'css'}
      \ }
NeoBundleLazy 'tpope/vim-markdown', {
      \   'autoload': {'filetypes': 'markdown'}
      \ }

filetype plugin indent on
"}}}

" BasicSettings {{{
" Encoding
set encoding=utf-8
set fileencoding=utf=8
set fileencodings=ucs-bom,utf-8,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932
set fileformats=unix,dos,mac
set ambiwidth=double

" Display
set cursorline number ruler showmatch
set laststatus=2 showtabline=2
set scrolloff=4
set title
set vb t_vb=

" Scheme
syntax enable
set background=dark
colorscheme darkblue

" Search
set ignorecase smartcase incsearch hlsearch wrapscan

" Indent
set autoindent cindent
set expandtab smarttab
set tabstop=2 shiftwidth=2 backspace=2

" Commandline
set wildmenu wildignorecase wildmode=list:full

" History
set history=100

" show tabs
set list listchars=tab:>-,trail:-,eol:¬,nbsp:%

" filetypes
autocmd MyVimrc BufNewFile,BufRead *.{md,markdown} set filetype=markdown

" No Auto Comment.
autocmd MyVimrc FileType * setlocal formatoptions-=ro
"}}}

" keybind {{{
" disable arrow keys
noremap <Up>    <Nop>
noremap <Down>  <Nop>
noremap <Left>  <Nop>
noremap <Right> <Nop>

inoremap <Up>    <Nop>
inoremap <Down>  <Nop>
inoremap <Left>  <Nop>
inoremap <Right> <Nop>

vnoremap <Up>    <Nop>
vnoremap <Down>  <Nop>
vnoremap <Left>  <Nop>
vnoremap <Right> <Nop>

" change window size
nnoremap <silent> <S-Up> <C-W>-
nnoremap <silent> <S-Down> <C-W>+
nnoremap <silent> <S-Left> <C-W><
nnoremap <silent> <S-Right> <C-W>>

" off highlight <ESC> * 2
nnoremap <silent> <Esc><Esc> :<C-u>nohlsearch<CR>
nnoremap :tn :<C-u>tabnew<Space>
"}}}

" for C++ (http://rhysd.hatenablog.com/entry/2013/12/10/233201) {{{
autocmd MyVimrc FileType cpp setlocal path+=/usr/include/c++/v1,/usr/include/boost
autocmd MyVimrc FileType cpp inoremap <buffer><expr>; <SID>expand_namespace()

function! s:expand_namespace()
  let s = getline('.')[0:col('.')-1]
  if s =~# '\<b;$'
    return "\<BS>oost::"
  elseif s =~# '\<s;$'
    return "\<BS>td::"
  elseif s =~# '\<d;$'
    return "\<BS>etail::"
  else
    return ';'
  endif
endfunction
"}}}

" vim-textmanip {{{
xmap <C-j> <Plug>(textmanip-move-down)
xmap <C-k> <Plug>(textmanip-move-up)
xmap <C-h> <Plug>(textmanip-move-left)
xmap <C-l> <Plug>(textmanip-move-right)
"}}}

" emmet-vim {{{
let g:user_emmet_leader_key = '<C-e>'
"}}}
