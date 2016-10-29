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
" show title
set title
" hide startup messages
set shortmess& shortmess+=I
" show tabs
set list listchars=tab:>-,trail:-,eol:¬,nbsp:%
" separator
set fillchars& fillchars+=vert:\ 
" add <> to matchpairs
set matchpairs& matchpairs+=<:>
" use english-help first
set helplang=en,ja

" backspace
set backspace=indent,eol,start
" increment/decrement bin/hex numbers
set nrformats=bin,hex
" open file in tab
set switchbuf=useopen,usetab,newtab
" indent
set smartindent autoindent breakindent
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
" folding
set foldmethod=syntax
set foldlevel=99
set nofoldenable

" command-line
set wildmenu wildignorecase wildmode=longest,full
" completion
set completeopt=menuone,noinsert,noselect

" timeout
set timeout timeoutlen=500
set ttimeout ttimeoutlen=100
set updatetime=500
" disable bell
set noerrorbells visualbell t_vb=

" clipboard
if has('clipboard')
  set clipboard&
  if has('unnamedplus')
    set clipboard^=unnamedplus
  else
    set clipboard^=unnamed
  endif
endif

" history
set history=1000
" viminfo
set viminfo& viminfo+=n~/.vim/viminfo
" disable backup/swap files
set nobackup noswapfile

" undofile
if !isdirectory(expand('~/.vim/undo'))
  call mkdir(expand('~/.vim/undo'), 'p')
endif
set undofile undodir=~/.vim/undo

" open last position
Autocmd BufRead * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
" }}}

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

" disable EX-mode
nnoremap  Q <Nop>
nnoremap gQ <Nop>

" disable <F1>
noremap <F1> <Nop>
inoremap <F1> <Nop>

" change window size
nnoremap <S-Up>    <C-W>-
nnoremap <S-Down>  <C-W>+
nnoremap <S-Left>  <C-W><
nnoremap <S-Right> <C-W>>

" navigate window
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" tab
nnoremap <silent> <C-n> :<C-u>tabnew<CR>

" sort
vnoremap <silent> ,s :sort<CR>
" }}}

" filetypes {{{
" C++
Autocmd FileType c,cpp call s:on_cpp_files()
function! s:on_cpp_files()
  setlocal cindent
  setlocal cinoptions& cinoptions+=g0,m1,j1,(0,ws,Ws,N-s

  " include path
  setlocal path& path+=/usr/include/c++/v1,/usr/local/include,~/.local/include

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

" Haskell
let hs_highlight_boolean    = 1
let hs_highlight_delimiters = 1
let hs_highlight_more_types = 1
let hs_highlight_types      = 1

" markdown
let g:markdown_fenced_languages = ['c', 'cpp', 'css', 'html', 'javascript', 'haskell', 'ruby', 'scss', 'sh', 'vim']

" ruby
let g:rubycomplete_buffer_loading    = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_load_gemfile      = 1

" vim
Autocmd FileType vim call s:on_vim_files()
function! s:on_vim_files()
  " search vim help for word under cursor
  setlocal keywordprg=:help

  setlocal foldmethod=marker
endfunction

" binary files
Autocmd BufReadPost * if &binary | call s:on_binary_files() | endif
function! s:on_binary_files()
  silent %!xxd -g 1
  setlocal ft=xxd

  Autocmd BufWritePre  * %!xxd -r
  Autocmd BufWritePost * silent %!xxd -g 1
  Autocmd BufWritePost * setlocal nomodified
endfunction

" quickfix
Autocmd FileType qf   nnoremap <buffer><silent> q :<C-u>cclose<CR>
" help
Autocmd FileType help nnoremap <buffer><silent> q :<C-u>q<CR>
" command window
Autocmd CmdwinEnter * nnoremap <buffer><silent> q :<C-u>q<CR>
" }}}

" Plugins {{{
" Vundle.vim {{{
if !isdirectory(expand('~/.vim/bundle/Vundle.vim'))
  finish
endif

filetype off
set runtimepath+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'a.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'haya14busa/incsearch.vim'
Plugin 'itchyny/lightline.vim'
Plugin 'itchyny/vim-gitbranch'
Plugin 'kannokanno/previm'
Plugin 'osyo-manga/vim-over'
Plugin 'rhysd/clever-f.vim'
Plugin 'rhysd/committia.vim'
Plugin 'thinca/vim-quickrun'
Plugin 'tyru/open-browser.vim'

Plugin 'AndrewRadev/switch.vim'
Plugin 'mattn/emmet-vim'
Plugin 't9md/vim-textmanip'
Plugin 'tomtom/tcomment_vim'
Plugin 'tpope/vim-surround'

" code completion
Plugin 'Valloric/YouCompleteMe'
Plugin 'eagletmt/neco-ghc'

" operator
Plugin 'kana/vim-operator-user'
Plugin 'kana/vim-operator-replace'
Plugin 'rhysd/vim-clang-format'

" colorscheme
Plugin 'Tosainu/last256'
Plugin 'mkarmona/colorsbox'

" filetypes
Plugin 'Twinside/vim-haskellFold'
Plugin 'ap/vim-css-color'
Plugin 'hail2u/vim-css3-syntax'
Plugin 'itchyny/vim-haskell-indent'
Plugin 'itchyny/vim-haskell-sort-import'
Plugin 'othree/html5.vim'
Plugin 'slim-template/vim-slim'
Plugin 'vim-jp/vim-cpp'
Plugin 'vim-ruby/vim-ruby'

call vundle#end()
filetype plugin indent on
" }}}

" vim-gitgutter {{{
let g:gitgutter_max_signs     = 1000
let g:gitgutter_sign_added    = '✚'
let g:gitgutter_sign_removed  = '✘'
let g:gitgutter_sign_modified = '➜'
let g:gitgutter_sign_modified_removed = '➜'
" }}}

" ctrlp.vim {{{
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = '\v[\/]\.git$'
let g:ctrlp_extensions = ['changes', 'line', 'quickfix']
let g:ctrlp_prompt_mappings = {
      \   'AcceptSelection("e")': ['<C-t>'],
      \   'AcceptSelection("t")': ['<CR>'],
      \ }
let g:ctrlp_status_func = {
      \   'main': 'CtrlPStatusFunc_1',
      \   'prog': 'CtrlPStatusFunc_2',
      \ }

if executable('ag')
  let g:ctrlp_user_command = 'ag %s -i --ignore ".git" --nocolor --nogroup --hidden -g ""'
  let g:ctrlp_use_caching = 0
endif

function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
  let g:lightline.ctrlp_regex = a:regex
  let g:lightline.ctrlp_prev = a:prev
  let g:lightline.ctrlp_item = a:item
  let g:lightline.ctrlp_next = a:next
  return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc_2(str)
  return lightline#statusline(0)
endfunction
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
      \       ['gitgutter', 'fileformat', 'fileencoding', 'filetype'],
      \     ]
      \   },
      \   'component_function': {
      \     'filename':   'LightlineFilename',
      \     'git-branch': 'LightlineGitBranch',
      \     'gitgutter':  'LightlineGitGutter',
      \     'mode':       'LightlineMode',
      \     'modified':   'LightlineModified',
      \     'readonly':   'LightlineReadonly',
      \   },
      \   'separator':    {'left': "\ue0b0", 'right': "\ue0b2"},
      \   'subseparator': {'left': "\ue0b1", 'right': "\ue0b3"},
      \   'tabline':      {'left': [['tabs']], 'right': []},
      \ }

function! LightlineFilename()
  let fname = expand('%:t')
  return  fname == 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? g:lightline.ctrlp_item :
        \ fname != '' ? fname : '[No Name]'
endfunction

function! LightlineMode()
  let fname = expand('%:t')
  return  fname == 'ControlP' ? 'CtrlP' :
        \ lightline#mode()
endfunction

function! LightlineModified()
  return &modifiable && &modified ? '+' : ''
endfunction

function! LightlineReadonly()
  return &ro ? "\ue0a2" : ''
endfunction

function! LightlineGitBranch()
  let _ = gitbranch#name()
  return _ != '' ? "\ue0a0 " . _ : ''
endfunction

" http://qiita.com/yuyuchu3333/items/20a0acfe7e0d0e167ccc
function! LightlineGitGutter()
  if !get(g:, 'gitgutter_enabled', 0) | return '' | endif
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

" previm {{{
let g:previm_enable_realtime = 1

Autocmd FileType markdown nnoremap <silent> <Space>p :<C-u>PrevimOpen<CR>
" }}}

" clever-f.vim {{{
let g:clever_f_across_no_line = 1
let g:clever_f_smart_case     = 1
" }}}

" committia.vim {{{
let g:committia_hooks = {}
function! g:committia_hooks.edit_open(info)
  " enable spell checking
  setlocal spell

  " If no commit message, start with insert mode
  if a:info.vcs ==# 'git' && getline(1) ==# ''
    startinsert
  end
endfunction
" }}}

" vim-quickrun {{{
let g:quickrun_no_default_key_mappings = 1

let g:quickrun_config = get(g:, 'quickrun_config', {})
let g:quickrun_config._ = {
      \   'outputter': 'error',
      \   'outputter/buffer/close_on_empty': 1,
      \   'outputter/buffer/into':    1,
      \   'outputter/buffer/split':   'botright',
      \   'outputter/error/error':    'quickfix',
      \   'outputter/error/success':  'buffer',
      \ }

let g:quickrun_config.cpp = {
      \   'command':    'clang++',
      \   'cmdopt':     '-Wall -Wextra -std=c++14 -lboost_system -pthread',
      \ }

nnoremap <silent> <Space>r :<C-u>QuickRun<CR>
nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "<C-c>"
" }}}

" switch.vim {{{
nnoremap <silent> ,sw :<C-u>Switch<CR>
" }}}

" emmet-vim {{{
let g:user_emmet_settings = {
      \   'indentation' : '  '
      \ }
let g:user_emmet_leader_key = '<C-e>'
" }}}

" vim-textmanip {{{
xmap <C-j> <Plug>(textmanip-move-down)
xmap <C-k> <Plug>(textmanip-move-up)
xmap <C-h> <Plug>(textmanip-move-left)
xmap <C-l> <Plug>(textmanip-move-right)
" }}}

" YouCompleteMe {{{
let g:ycm_allow_changing_updatetime = 0
let g:ycm_complete_in_comments      = 1
let g:ycm_confirm_extra_conf        = 0
let g:ycm_show_diagnostics_ui       = 0
let g:ycm_global_ycm_extra_conf     = '~/.vim/ycm_extra_conf.py'
let g:ycm_goto_buffer_command       = 'new-or-existing-tab'
let g:ycm_semantic_triggers         = {'haskell': ['.']}

nnoremap <silent> ,t  :<C-u>YcmCompleter GetType<CR>
nnoremap <silent> ,gd :<C-u>YcmCompleter GoToDeclaration<CR>
nnoremap <silent> ,gD :<C-u>YcmCompleter GoToDefinition<CR>
" }}}

" neco-ghc {{{
let g:necoghc_enable_detailed_browse = 1

Autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
" }}}

" vim-operator-replace {{{
nmap R  <Plug>(operator-replace)
" }}}

" vim-clang-format {{{
let g:clang_format#style_options = {
      \   'AccessModifierOffset':             -2,
      \   'AlignConsecutiveAssignments':      'true',
      \   'AllowShortFunctionsOnASingleLine': 'Empty',
      \   'ColumnLimit':                      96,
      \   'Cpp11BracedListStyle':             'true',
      \   'DerivePointerAlignment':           'false',
      \   'SortIncludes':                     'false',
      \   'SpacesBeforeTrailingComments':     1,
      \   'Standard':                         'Cpp11',
      \ }

Autocmd FileType c,cpp map <buffer>,x <Plug>(operator-clang-format)
" }}}
" }}}

" colorscheme {{{
if &t_Co > 2 || has("gui_running")
  syntax on
endif

if $TERM =~? '^xterm.*'
  if has('termguicolors')
    set termguicolors
  else
    set t_Co=256
  endif
endif

try
  colorscheme colorsbox-stbright
catch
  colorscheme slate
endtry
" }}}
