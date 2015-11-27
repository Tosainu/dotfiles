" skip when vim-tiny or vim-small
if 0 | endif

" vimrc augroup {{{
augroup MyVimrc
  autocmd!
augroup END

command! -nargs=* Autocmd autocmd MyVimrc <args>

Autocmd FileType vim highlight def link myVimAutocmd vimAutoCmd
Autocmd FileType vim match myVimAutocmd /\<\%(Autocmd\)\>/
" }}}

" basic settings {{{
" encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,cp932,euc-jp
set fileformats=unix,dos,mac

scriptencoding utf-8

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
" margin during scrolling
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
" command-line completion
set wildmenu wildignorecase wildmode=longest,full
" separator
set fillchars+=vert:\ 
" open file in tab
set switchbuf+=usetab,newtab

" add <> to matchpairs
set matchpairs+=<:>
" history
set history=1000
" backspace
set backspace=indent,eol,start
" use japanese-help first
set helplang=ja,en

" folding
set foldmethod=marker
set foldlevel=99
set nofoldenable

" indent
set smartindent autoindent
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

" timeout
set timeoutlen=500
set updatetime=200

" clipboard
if has('clipboard')
  set clipboard&
  if has('unnamedplus')
    set clipboard^=unnamedplus
  else
    set clipboard^=unnamed
  endif
endif

" no backup files
set nobackup

" runtimepath for windows
if has('win32') || has('win64')
  set runtimepath^=$HOME/.vim
  set runtimepath+=$HOME/.vim/after
endif

" swapfile
if !isdirectory($HOME.'/.vim/swap')
  call mkdir($HOME.'/.vim/swap', 'p')
endif
set directory=~/.vim/swap

" undofile
if !isdirectory($HOME.'/.vim/undo')
  call mkdir($HOME.'/.vim/undo', 'p')
endif
set undodir=~/.vim/undo
set undofile

" viminfo
set viminfo+=n~/.vim/viminfo

" disable auto comment
Autocmd BufEnter * setlocal formatoptions-=ro
" open last position
Autocmd BufRead * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
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

" remap j/k
nnoremap j gj
nnoremap k gk

" change window size
nnoremap <S-Up>    <C-W>-
nnoremap <S-Down>  <C-W>+
nnoremap <S-Left>  <C-W><
nnoremap <S-Right> <C-W>>
" }}}

" filetypes {{{
" C++
Autocmd FileType cpp call s:on_cpp_files()
function! s:on_cpp_files()
  setlocal cindent
  setlocal cinoptions& cinoptions+=g0,m1,j1,(0,ws,Ws,N-s

  " include path
  setlocal path+=/usr/include/c++/v1,/usr/local/include,~/.local/include

  inoremap <buffer><expr>; <SID>expand_namespace()
endfunction

" http://rhysd.hatenablog.com/entry/2013/12/10/233201#namespace
function! s:expand_namespace()
  let s = getline('.')[0:col('.') - 2]
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

" markdown
Autocmd FileType markdown call s:on_markdown_files()
function! s:on_markdown_files()
  let g:markdown_fenced_languages = [
        \   'c',
        \   'cpp',
        \   'css',
        \   'html',
        \   'javascript',
        \   'ruby',
        \   'scss',
        \   'vim',
        \ ]

  nnoremap <silent> <Space>p :<C-u>PrevimOpen<CR>
endfunction

" ruby
Autocmd FileType ruby call s:on_ruby_files()
function! s:on_ruby_files()
  let g:rubycomplete_buffer_loading = 1
  let g:rubycomplete_classes_in_global = 1
endfunction

" binary files
Autocmd BufReadPost * if &binary | call s:on_binary_files() | endif
function! s:on_binary_files()
  silent %!xxd -g 1
  setlocal ft=xxd

  Autocmd BufWritePre * %!xxd -r
  Autocmd BufWritePost * silent %!xxd -g 1
  Autocmd BufWritePost * setlocal nomodified
endfunction

" quickfix
Autocmd FileType qf   nnoremap <buffer><silent> q :<C-u>cclose<CR>
" help
Autocmd FileType help nnoremap <buffer><silent> q :<C-u>q<CR>

" search vim help for word under cursor
Autocmd FileType vim  setlocal keywordprg=:help
" }}}

" Plugins {{{
if isdirectory('~/.vim/bundle/Vundle.vim')
  finish
endif

filetype off
set runtimepath+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'itchyny/lightline.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'

Plugin 'thinca/vim-quickrun'

Plugin 'Yggdroot/indentLine'
Plugin 'haya14busa/incsearch.vim'
Plugin 'rhysd/clever-f.vim'
Plugin 't9md/vim-textmanip'
Plugin 'tomtom/tcomment_vim'
Plugin 'tpope/vim-surround'
Plugin 'vim-jp/vimdoc-ja'

Plugin 'AndrewRadev/switch.vim'
Plugin 'Shougo/vimfiler.vim'
Plugin 'kannokanno/previm'
Plugin 'mattn/emmet-vim'
Plugin 'osyo-manga/vim-over'
Plugin 'tyru/open-browser.vim'

Plugin 'Shougo/neocomplete.vim'
Plugin 'Shougo/neoinclude.vim'
Plugin 'Shougo/neosnippet.vim'
Plugin 'eagletmt/neco-ghc'
Plugin 'osyo-manga/vim-marching'

" operator
Plugin 'kana/vim-operator-user'
Plugin 'kana/vim-operator-replace'
Plugin 'rhysd/vim-clang-format'

" colorscheme
Plugin 'Tosainu/last256'

" unite
Plugin 'Shougo/unite.vim'
Plugin 'lambdalisue/vim-gista'
Plugin 'koron/codic-vim'
Plugin 'rhysd/unite-codic.vim'
Plugin 'ujihisa/unite-haskellimport'

" languages
Plugin 'ap/vim-css-color'
Plugin 'dag/vim2hs'
Plugin 'hail2u/vim-css3-syntax'
Plugin 'othree/html5.vim'
Plugin 'rust-lang/rust.vim'
Plugin 'slim-template/vim-slim'
Plugin 'vim-jp/vim-cpp'

call vundle#end()
filetype plugin indent on

" lightline.vim {{{
let g:lightline = {
      \   'colorscheme': 'wombat',
      \   'active': {
      \     'left': [
      \       ['mode'],
      \       ['git-branch', 'readonly', 'filename', 'modified'],
      \     ],
      \     'right': [
      \       ['lineinfo'],
      \       ['percent'],
      \       ['fileformat', 'fileencoding', 'filetype'],
      \       ['gitgutter'],
      \     ]
      \   },
      \   'component_function': {
      \     'readonly':   'LightlineReadonly',
      \     'filename':   'LightlineFilename',
      \     'modified':   'LightlineModified',
      \     'git-branch': 'LightLineGitBranch',
      \     'gitgutter':  'LightlineGitGutter',
      \   },
      \   'separator':    {'left': "\ue0b0", 'right': "\ue0b2"},
      \   'subseparator': {'left': "\ue0b1", 'right': "\ue0b3"},
      \   'tabline':      {'left': [['tabs']], 'right': []},
      \ }

function! LightlineReadonly()
  return &ro ? "\ue0a2" : ''
endfunction

function! LightlineFilename()
  return  &ft == 'unite'    ? unite#get_status_string() :
        \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
        \ expand('%:t') != '' ? expand('%:t') : '[No Name]'
endfunction

function! LightlineModified()
  return &modifiable && &modified ? '+' : ''
endfunction

function! LightLineGitBranch()
  if &ft == 'help' || !exists('*fugitive#head')
    return ''
  endif
  let _ = fugitive#head()
  return _ != '' ? "\ue0a0 " . _ : ''
endfunction

function! LightlineGitGutter()
  if !exists('*GitGutterGetHunkSummary') || !get(g:, 'gitgutter_enabled', 0)
    return ''
  endif
  let symbols = [
        \   g:gitgutter_sign_added,
        \   g:gitgutter_sign_modified,
        \   g:gitgutter_sign_removed,
        \ ]
  let hunks = GitGutterGetHunkSummary()
  let _ = []
  for i in [0, 1, 2]
    if hunks[i] > 0
      call add(_, symbols[i] . ' ' . hunks[i])
    endif
  endfor
  return join(_, ' ')
endfunction
" }}}

" vim-gitgutter {{{
let g:gitgutter_max_signs = 1000
let g:gitgutter_sign_added = '✚'
let g:gitgutter_sign_modified = '➜'
let g:gitgutter_sign_modified_removed = '➜'
let g:gitgutter_sign_removed = '✘'
" }}}

" vim-quickrun {{{
let g:quickrun_no_default_key_mappings = 1

let g:quickrun_config = get(g:, 'quickrun_config', {})
let g:quickrun_config._ = {
      \   'outputter/buffer/split': ':botright',
      \   'outputter/buffer/into':  1,
      \   'outputter/buffer/close_on_empty': 1,
      \   'outputter/error': 'quickfix',
      \   'outputter/error/success': 'buffer',
      \   'outputter': 'error',
      \ }

let g:quickrun_config.cpp = {
      \   'command':    'clang++',
      \   'cmdopt':     '-Wall -Wextra -std=c++14 -lboost_system -pthread',
      \ }

nnoremap <silent> <Space>r :<C-u>QuickRun<CR>
nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "<C-c>"
" }}}

" incsearch.vim {{{
let g:incsearch#auto_nohlsearch = 1

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)

map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)
" }}}

" clever-f.vim {{{
let g:clever_f_across_no_line = 1
let g:clever_f_smart_case = 1
let g:clever_f_use_migemo = 1
" }}}

" vim-textmanip {{{
xmap <C-j> <Plug>(textmanip-move-down)
xmap <C-k> <Plug>(textmanip-move-up)
xmap <C-h> <Plug>(textmanip-move-left)
xmap <C-l> <Plug>(textmanip-move-right)
" }}}

" switch.vim {{{
nnoremap <silent> <Leader>sw :<C-u>Switch<CR>
" }}}

" vimfiler {{{
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_ignore_pattern = ['^\.git$']

call vimfiler#custom#profile('default', 'context', {
      \   'safe':         0,
      \   'edit_action':  'tabopen',
      \ })

" open Vimfiler
nmap <silent> <Leader>vf :<C-u>VimFilerExplorer -winwidth=25<CR>
" }}}

" previm {{{
let g:previm_enable_realtime = 1
" }}}

" emmet-vim {{{
let g:user_emmet_settings = {
      \   'indentation' : '  '
      \ }

imap <buffer><silent> <C-e> <Plug>(emmet-expand-abbr)
" }}}

" neocomplete.vim {{{
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_auto_delimiter = 1
let g:neocomplete#sources#syntax#min_keyword_length = 2
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" enable heavy omni completion
let g:neocomplete#force_overwrite_completefunc = 1
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.cpp =
      \ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
let g:neocomplete#force_omni_input_patterns.ruby =
      \ '[^. *\t]\.\w*\|\h\w*::'

" neocomplete and neosnippet keybinds
imap <expr> <CR> !pumvisible() ? "\<CR>" :
      \ neosnippet#expandable() ? "\<Plug>(neosnippet_expand)" :
      \ neocomplete#close_popup()
imap <expr> <TAB> pumvisible() ? "\<C-n>" :
      \ neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)" :
      \ "\<Tab>"
smap <expr> <TAB> neosnippet#jumpable() ?
      \ "\<Plug>(neosnippet_jump)"
      \ : "\<TAB>"

inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
inoremap <expr> <C-h>   neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr> <BS>    neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr> <C-e>   neocomplete#cancel_popup()
" }}}

" neosnippet.vim {{{
let g:neosnippet#disable_runtime_snippets = {
      \   '_': 1,
      \ }
let g:neosnippet#snippets_directory = '~/.vim/snippets'

" for snippet_complete marker
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif
" }}}

" vim-marching {{{
let g:marching_backend = 'sync_clang_command'
let g:marching#clang_command#options = {
      \   'cpp':  '-std=c++14',
      \ }

let g:marching_enable_neocomplete = 1
" }}}

" vim-operator-replace
nmap R  <Plug>(operator-replace)

" vim-clang-format {{{
let g:clang_format#style_options = {
      \   'AccessModifierOffset': -2,
      \   'AllowShortFunctionsOnASingleLine': 'Empty',
      \   'ColumnLimit':          128,
      \   'SpacesBeforeTrailingComments': 1,
      \   'Standard':             'Cpp11',
      \ }

map <buffer><Leader>cf <Plug>(operator-clang-format)
" }}}

" unite.vim {{{
let g:unite_force_overwrite_statusline = 0

" always open new tab
call unite#custom_default_action('file', 'tabopen')
call unite#custom#source('file,file_rec/git', 'matchers', 'matcher_default')

Autocmd FileType unite call s:unite_myconfig()
function! s:unite_myconfig()
  imap <silent><buffer> <C-w> <Plug>(unite_delete_backward_path)
endfunction

" keybinds
nnoremap [unite]  <Nop>
nmap     <Space>u [unite]
nnoremap <silent> [unite]R :<C-u>UniteResume<CR>
nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir file<CR>
nnoremap <silent> [unite]n :<C-u>Unite file/new -start-insert<CR>
nnoremap <silent> [unite]r :<C-u>Unite register<CR>
nnoremap <silent> [unite]s :<C-u>Unite line -start-insert<CR>
nnoremap <silent> [unite]t :<C-u>Unite tab buffer<CR>
" }}}

" vim-gista {{{
let g:gista#github_user = 'Tosainu'

nnoremap <silent> [unite]g :<C-u>Unite gista<CR>
" }}}

" unite-codic.vim {{{
nnoremap <silent> [unite]c :<C-u>Unite codic -start-insert -buffer-name=codic<CR>
" }}}

" unite-haskellimport {{{
let g:necoghc_enable_detailed_browse = 1
" }}}

" }}}

" colorscheme {{{
syntax enable

if $TERM =~# '^xterm.*'
  set t_Co=256
endif

if !has('gui_running')
  if &t_Co < 256
    colorscheme slate
  else
    try
      colorscheme last256
    catch
      colorscheme slate
    endtry
  endif
endif
" }}}
