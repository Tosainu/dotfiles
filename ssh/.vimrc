scriptencoding utf-8

" basic settings {{{
set nocompatible

" vimrc augroup
augroup MyVimrc
  autocmd!
augroup END

" encoding
set encoding=utf-8
set fileencoding=utf=8
set fileencodings=ucs-bom,utf-8,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932
set fileformats=unix,dos,mac
set ambiwidth=double

" show cursorline
set cursorline
" show line number
set number
" show ruler
set ruler
" always show statusline
set laststatus=2
" always show tabline
set showtabline=2
" margin during dcrolling
set scrolloff=5
" disable beep
set vb t_vb=
" use fast terminal connection
set ttyfast
" show title
set title
" hide startup messages
set shortmess& shortmess+=I
" show tabs
set list listchars=tab:>-,trail:-,eol:¬,nbsp:%
" commandline
set wildmenu wildignorecase wildmode=list:full

" add <> to matchpairs
set matchpairs+=<:>
" history
set history=100

" indent
set autoindent cindent
" use <SPACE> instead of <TAB>
set expandtab smarttab
set tabstop=2 shiftwidth=2 softtabstop=2 backspace=2

" smartcase search
set ignorecase smartcase
" incremental search
set incsearch
" highlight results
set hlsearch
" searches wrap around
set wrapscan

" disable auto comment
autocmd MyVimrc BufEnter * setlocal formatoptions-=ro

" timeout
set timeoutlen=500
set updatetime=200

" no backup files
set nobackup

" swapfile
if ! isdirectory($HOME.'/.vim/swap')
  call mkdir($HOME.'/.vim/swap', 'p')
endif
set directory=~/.vim/swap

" undofile
if has('persistent_undo')
  if ! isdirectory($HOME.'/.vim/undo')
    call mkdir($HOME.'/.vim/undo', 'p')
  endif
  set undodir=~/.vim/undo
  set undofile
endif

" open last position
autocmd MyVimrc BufRead * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

" filetypes
autocmd MyVimrc BufNewFile,BufRead *.{md,markdown} set filetype=markdown
autocmd MyVimrc BufRead,BufNewFile /etc/nginx/* set filetype=nginx

" markdown
let g:markdown_fenced_languages = [
      \   'c',
      \   'cpp',
      \   'css',
      \   'html',
      \   'javascript',
      \   'ruby',
      \   'vim',
      \ ]
" }}}

" keybind {{{
let mapleader = ","

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
nnoremap <S-Up>    <C-W>-
nnoremap <S-Down>  <C-W>+
nnoremap <S-Left>  <C-W><
nnoremap <S-Right> <C-W>>

" off highlight <ESC> * 2
nmap <silent> <Esc><Esc> :<C-u>nohlsearch<CR><Esc>
" }}}

" neobundle {{{
" install neobundle (https://github.com/rhysd/dotfiles/blob/master/vimrc#L758-L768)
if ! isdirectory(expand('~/.vim/bundle'))
  echon "Installing neobundle.vim..."
  silent call mkdir(expand('~/.vim/bundle'), 'p')
  silent !git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim
  echo "done."
  if v:shell_error
    echoerr "neobundle.vim installation has failed!"
    finish
  endif
endif

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
endif

call neobundle#rc(expand('~/.vim/bundle/'))

" require
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc', {
      \   'build': {
      \     'unix': 'make -f make_unix.mak',
      \     'mac' : 'make -f make_mac.mak'
      \   }
      \ }

" tools
NeoBundle 't9md/vim-textmanip'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle "osyo-manga/vim-over"

" Completetion
NeoBundleLazy 'mattn/emmet-vim', {
      \   'autoload': {'filetypes': ['html', 'xhtml', 'css']}
      \ }

" unite
NeoBundleLazy "Shougo/unite.vim", {
      \   'autoload': {'commands': ["Unite"]}
      \ }
NeoBundleLazy 'Shougo/vimfiler', {
      \   'depends': 'Shougo/unite.vim',
      \   'autoload': {
      \     'commands': [
      \       {'name': 'VimFiler', 'complete' : 'customlist,vimfiler#complete'},
      \       'VimFilerExplorer',
      \       'Edit', 'Read', 'Source', 'Write'
      \     ],
      \     'mappings': ['<Plug>(vimfiler_'],
      \     'explorer': 1,
      \   }
      \ }
NeoBundleLazy 'Shougo/neomru.vim', {
      \   'depends': 'Shougo/unite.vim',
      \   'autoload': {'unite_sources': ['neomru/directory', 'neomru/file']}
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

" check bundles
NeoBundleCheck
"}}}

" colorscheme {{{
syntax enable
colorscheme evening

" transparent background
highlight Normal ctermbg=none
" }}}

" unite.vim {{{
let g:unite_source_history_yank_enable = 1

" always open new tab
call unite#custom_default_action('file', 'tabopen')
" show dotfiles
call unite#custom#source('file', 'matchers', 'matcher_default')

" http://deris.hatenablog.jp/entry/2013/05/02/192415
nnoremap [unite]    <Nop>
nmap     <Space>u [unite]
nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> [Unite]y :<C-u>Unite history/yank<CR>
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
nnoremap <silent> [unite]h :<C-u>Unite neomru/file<CR>
nnoremap <silent> [unite]t :<C-u>Unite tab<CR>
nnoremap <silent> [unite]b :<C-u>Unite bookmark<CR>
nnoremap <silent> [unite]a :<C-u>UniteBookmarkAdd<CR>
nnoremap <silent> [unite]s :<C-u>Unite source<CR>
nnoremap <silent> [unite]c :<C-u>Unite codic<CR>

autocmd MyVimrc FileType unite call s:unite_myconfig()
function! s:unite_myconfig()
  " close <ESC> * 2
  nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
  inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>

  imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
endfunction
" }}}

" vimfiler {{{
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_safe_mode_by_default = 0
" }}}

" vim-textmanip {{{
xmap <C-j> <Plug>(textmanip-move-down)
xmap <C-k> <Plug>(textmanip-move-up)
xmap <C-h> <Plug>(textmanip-move-left)
xmap <C-l> <Plug>(textmanip-move-right)
"}}}

" emmet-vim {{{
let g:user_emmet_leader_key = '<C-e>'
"}}}
