" skip when vim-tiny or vim-small
if 0 | endif

" basic settings {{{
" encoding
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,iso-2022-jp,euc-jp,cp932,latin1
set fileformats=unix,dos,mac

scriptencoding utf-8

" vimrc augroup
augroup MyVimrc
  autocmd!
augroup END

" create directory if not exists
function! s:mkdir(dir) abort
  if !isdirectory(a:dir)
    call mkdir(a:dir, 'p')
  endif
endfunction

set breakindent
set colorcolumn=100
set cursorline
set list listchars=tab:>-,trail:-,eol:¬,nbsp:%
set ruler
set title
set laststatus=2
set showtabline=2
set scrolloff=5
set background=dark
set fillchars-=vert:\|
set foldlevel=99 foldmethod=syntax nofoldenable
set matchpairs& matchpairs+=<:>
set noerrorbells visualbell t_vb=
set shortmess& shortmess+=I
set equalalways
set lazyredraw
set switchbuf=useopen,usetab,newtab
set showcmd

set backspace=2
set completeopt=menuone,noinsert,noselect
set nrformats=bin,hex

set expandtab smarttab
set smartindent
set shiftwidth=2 softtabstop=2 tabstop=2
set shiftround

set ignorecase smartcase
set incsearch
set hlsearch
set wrapscan
autocmd MyVimrc CmdlineEnter [/\?] :set hlsearch
autocmd MyVimrc CmdlineLeave [/\?] :set nohlsearch

set cedit=<C-c>
set wildmenu wildmode=longest,full
set wildignorecase

set timeout timeoutlen=500
set ttimeout ttimeoutlen=100
set updatetime=500

if has('unnamedplus')
  set clipboard& clipboard^=unnamedplus
endif

set history=1000
set viminfo& viminfo+=n~/.vim/viminfo
call s:mkdir(expand('~/.vim'))

set nobackup

set swapfile directory&
let s:swapdir = isdirectory($XDG_RUNTIME_DIR) ?
      \ $XDG_RUNTIME_DIR . '/vim/swap' : expand('~/.vim/swap')
let &directory = s:swapdir . ',' . &directory
call s:mkdir(s:swapdir)

if has('persistent_undo')
  set undofile undodir=~/.vim/undo
  call s:mkdir(&undodir)

  autocmd MyVimrc BufNewFile,BufRead /tmp/*,/var/tmp/* setlocal noundofile
endif

" jump to the last known cursor position
autocmd MyVimrc BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit' |
      \   exe "normal! g`\"" |
      \ endif

" ibus
if $GTK_IM_MODULE ==# 'ibus' && executable('ibus')
  function! s:switch_ibus_engine(engine) abort
    silent let l:engine_name = system('ibus engine')
    if l:engine_name !~# a:engine
      silent execute '!ibus engine ' . a:engine
    endif
  endfunction
  autocmd MyVimrc InsertLeave * call s:switch_ibus_engine('xkb:us::eng')
endif

filetype plugin indent on
" }}}

" keybind {{{
let g:mapleader = ','

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

" clear search highlights
nnoremap <silent> <Esc><Esc> :<C-u>nohlsearch<CR>

" tab
nnoremap <silent> <C-n> :<C-u>tabnew<CR>

" sort
vnoremap <silent> <Leader>s :sort<CR>
vnoremap <silent> <Leader>u :sort u<CR>

" toggle line number
nnoremap <silent> <Leader>n :<C-u>setlocal number!<CR>
" }}}

" commands {{{
" https://sanctum.geek.nz/arabesque/vim-command-typos/
command! -bang -nargs=? -complete=file E e<bang> <args>
command! -bang -nargs=? -complete=file W w<bang> <args>
command! -bang -nargs=? -complete=file WQ wq<bang> <args>
command! -bang -nargs=? -complete=file Wq wq<bang> <args>
command! -bang Q q<bang>
command! -bang QA qa<bang>
command! -bang Qa qa<bang>
command! -bang WA wa<bang>
command! -bang Wa wa<bang>
command! -bang WQa wqa<bang>
command! -bang Wqa wqa<bang>

" open .vimrc
command! Vimrc if !empty($MYVIMRC) | execute('args ' . $MYVIMRC) | endif
" }}}

" C++ {{{
autocmd MyVimrc FileType c,cpp call s:on_cpp_files()
function! s:on_cpp_files() abort
  setlocal cindent
  setlocal cinoptions& cinoptions+=g0,m1,j1,(0,ws,Ws,N-s

  inoremap <buffer><expr> ; <SID>expand_namespace()
endfunction

" http://rhysd.hatenablog.com/entry/2013/12/10/233201#namespace
function! s:expand_namespace() abort
  let l:s = getline('.')[0:col('.') - 2]
  if l:s =~# '\<b;$'
    return "\<BS>oost::"
  elseif l:s =~# '\<s;$'
    return "\<BS>td::"
  elseif l:s =~# '\<d;$'
    return "\<BS>etail::"
  else
    return ';'
  endif
endfunction

autocmd MyVimrc BufReadPost /usr/include/c++/* setlocal filetype=cpp
" }}}

" Haskell {{{
let g:hs_highlight_boolean    = 1
let g:hs_highlight_delimiters = 1
let g:hs_highlight_more_types = 1
let g:hs_highlight_types      = 1

if executable('stylish-haskell')
  autocmd MyVimrc FileType haskell setlocal formatprg=stylish-haskell
endif
" }}}

" Markdown {{{
let g:markdown_fenced_languages = [
      \   'c',
      \   'cpp',
      \   'css',
      \   'haskell',
      \   'html',
      \   'python',
      \   'ruby',
      \   'rust',
      \   'scss',
      \   'sh',
      \   'vim',
      \ ]
" }}}

" Vim {{{
autocmd MyVimrc FileType vim call s:on_vim_files()
function! s:on_vim_files() abort
  " search vim help for word under cursor
  setlocal keywordprg=:help

  setlocal foldmethod=marker
endfunction
" }}}

" binary files {{{
autocmd MyVimrc BufReadPost * if &binary | call s:on_binary_files() | endif
function! s:on_binary_files() abort
  silent %!xxd -g 1
  setlocal filetype=xxd

  autocmd MyVimrc BufWritePre  * %!xxd -r
  autocmd MyVimrc BufWritePost * silent %!xxd -g 1
  autocmd MyVimrc BufWritePost * setlocal nomodified
endfunction
" }}}

" quickfix {{{
autocmd MyVimrc FileType qf   nnoremap <buffer><silent> q :<C-u>cclose<CR>
" }}}

" help {{{
autocmd MyVimrc FileType help nnoremap <buffer><silent> q :<C-u>q<CR>
" }}}

" command-line window {{{
autocmd MyVimrc CmdwinEnter * call s:on_command_line_window()
function! s:on_command_line_window() abort
  nnoremap <buffer><silent> q     :<C-u>q<CR>
  nnoremap <buffer><silent> <Esc> :<C-u>q<CR>
endfunction
" }}}

" colorscheme {{{
syntax on

" https://gist.github.com/XVilka/8346728#detection
let s:supports_truecolor =
      \ has('termguicolors') && $COLORTERM =~# '^\(truecolor\|24bit\)$'
if s:supports_truecolor
  if &t_8f ==# '' || &t_8b ==# ''
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif
  set termguicolors
endif

try
  if s:supports_truecolor || has('gui_running')
    colorscheme colorsbox-stbright
  elseif &t_Co == 256
    colorscheme last256
  endif
catch
  if s:supports_truecolor
    set termguicolors&
  endif
  colorscheme default
endtry
" }}}

" Plugins {{{
" Disable some pre-installed plugins
let g:loaded_getscriptPlugin  = 1
let g:loaded_gzip             = 1
let g:loaded_logiPat          = 1
let g:loaded_netrwPlugin      = 1
let g:loaded_tar              = 1
let g:loaded_tarPlugin        = 1
let g:loaded_vimballPlugin    = 1
let g:loaded_zip              = 1
let g:loaded_zipPlugin        = 1

" minpac {{{
function! s:init_minpac() abort
  silent! packadd minpac
  if !exists('*minpac#init')
    return
  endif

  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})

  call minpac#add('AndrewRadev/switch.vim')
  call minpac#add('airblade/vim-gitgutter')
  call minpac#add('ctrlpvim/ctrlp.vim')
  call minpac#add('itchyny/lightline.vim')
  call minpac#add('itchyny/vim-gitbranch')
  call minpac#add('justinmk/vim-dirvish')
  call minpac#add('prabirshrestha/async.vim')
  call minpac#add('prabirshrestha/vim-lsp')
  call minpac#add('rhysd/clever-f.vim')
  call minpac#add('rhysd/committia.vim')
  call minpac#add('t9md/vim-textmanip')
  call minpac#add('thinca/vim-quickrun')
  call minpac#add('tomtom/tcomment_vim')
  call minpac#add('tpope/vim-surround')

  " operator/textobj
  call minpac#add('kana/vim-operator-replace')
  call minpac#add('kana/vim-operator-user')
  call minpac#add('kana/vim-textobj-user')
  call minpac#add('sgur/vim-textobj-parameter')

  " colorscheme
  call minpac#add('Tosainu/last256', {'type': 'opt'})
  call minpac#add('mkarmona/colorsbox', {'type': 'opt'})

  " code completion
  function! s:build_ycm(hooktype, name) abort
    " setup ycm_core library
    call system('mkdir -p ycm_build && cd $_ &&
          \ cmake -G Ninja . ../third_party/ycmd/cpp
          \   -DCMAKE_C_COMPILER=clang
          \   -DCMAKE_CXX_COMPILER=clang++
          \   -DUSE_PYTHON2=OFF
          \   -DUSE_SYSTEM_BOOST=ON
          \   -DUSE_SYSTEM_LIBCLANG=ON &&
          \ cmake --build . --target ycm_core --config Release')

    " setup rust completer
    if (executable('cargo'))
      call system('cd third_party/ycmd/third_party/racerd &&
            \ cargo build --release')
    endif
  endfunction
  call minpac#add('Valloric/YouCompleteMe', {'do': function('s:build_ycm')})

  " snippets
  call minpac#add('SirVer/ultisnips')
  call minpac#add('honza/vim-snippets')

  " C++
  call minpac#add('rhysd/vim-clang-format')

  " Haskell
  call minpac#add('Twinside/vim-haskellFold')
  call minpac#add('itchyny/vim-haskell-indent')

  " Rust
  call minpac#add('cespare/vim-toml')
  call minpac#add('rust-lang/rust.vim')

  call minpac#add('ap/vim-css-color')
  call minpac#add('mattn/emmet-vim', {'type': 'opt'})
  call minpac#add('slim-template/vim-slim')
endfunction

command! PackInit   call s:init_minpac()
command! PackUpdate call s:init_minpac() | call minpac#update()
command! PackClean  call s:init_minpac() | call minpac#clean()
" }}}

" vim-gitgutter {{{
let g:gitgutter_max_signs     = 1000
let g:gitgutter_sign_added    = '✚'
let g:gitgutter_sign_removed  = '✘'
let g:gitgutter_sign_modified = '➜'
let g:gitgutter_sign_modified_removed = '➜'
" }}}

" ctrlp.vim {{{
let g:ctrlp_extensions      = ['changes', 'line', 'quickfix']
let g:ctrlp_prompt_mappings = {
      \   'AcceptSelection("e")': ['<C-t>'],
      \   'AcceptSelection("t")': ['<CR>'],
      \ }

let g:ctrlp_user_command = {}
let g:ctrlp_user_command.types = {
      \   1: ['.git', 'git --git-dir=%s/.git ls-files -co --exclude-standard'],
      \ }

if executable('ag')
  let g:ctrlp_user_command.fallback = 'ag %s --nocolor --nogroup -g ""'
  let g:ctrlp_use_caching = 0
endif

let g:ctrlp_status_func = {
      \   'main': 'CtrlPStatusFunc_1',
      \   'prog': 'CtrlPStatusFunc_2',
      \ }

function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked) abort
  let g:lightline.ctrlp_regex = a:regex
  let g:lightline.ctrlp_prev = a:prev
  let g:lightline.ctrlp_item = a:item
  let g:lightline.ctrlp_next = a:next
  return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc_2(str) abort
  return lightline#statusline(0)
endfunction

nnoremap [ctrlp] <nop>
nmap     <Leader>c [ctrlp]
nnoremap <silent> [ctrlp]b :<C-u>CtrlPBuffer<CR>
nnoremap <silent> [ctrlp]c :<C-u>CtrlPChangeAll<CR>
nnoremap <silent> [ctrlp]f :<C-u>CtrlP<CR>
nnoremap <silent> [ctrlp]l :<C-u>CtrlPLine<CR>
nnoremap <silent> [ctrlp]r :<C-u>CtrlPMRU<CR>
" }}}

" lightline.vim {{{
let g:lightline = {
      \   'colorscheme': 'wombat',
      \   'active': {
      \     'left': [
      \       ['mode', 'textmanip'],
      \       ['readonly', 'filename', 'modified'],
      \     ],
      \     'right': [
      \       ['lineinfo'],
      \       ['filetype', 'fileformat'],
      \       ['git-branch', 'gitgutter'],
      \     ]
      \   },
      \   'inactive': {
      \     'left':       [ ['filename'] ],
      \     'right':      [ ['lineinfo'], ['filetype', 'fileformat'] ],
      \   },
      \   'component': {
      \     'fileformat': '%{&fenc !=# "" ? &fenc : &enc}[%{&ff}]',
      \     'readonly':   '%{&ro ? "\ue0a2" : ""}',
      \   },
      \   'component_function': {
      \     'filename':   'LightlineFilename',
      \     'git-branch': 'LightlineGitBranch',
      \     'gitgutter':  'LightlineGitGutter',
      \     'mode':       'LightlineMode',
      \     'textmanip':  'LightlineTextmanipMode',
      \   },
      \   'separator':    {'left': "\ue0b0", 'right': "\ue0b2"},
      \   'subseparator': {'left': "\ue0b1", 'right': "\ue0b3"},
      \   'tabline':      {'left': [['tabs']], 'right': []},
      \ }

function! LightlineFilename() abort
  let l:fname = expand('%:t')
  return  l:fname ==# 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? g:lightline.ctrlp_item :
        \ l:fname !=# '' ? l:fname : '[No Name]'
endfunction

function! LightlineMode() abort
  let l:fname = expand('%:t')
  return  l:fname ==# 'ControlP' ? 'CtrlP' :
        \ lightline#mode()
endfunction

function! LightlineTextmanipMode() abort
  return  exists('g:textmanip_current_mode') && (mode() =~? 'v' || mode() ==# "\<C-V>") ?
        \ g:textmanip_current_mode ==# 'insert'  ? 'I' :
        \ g:textmanip_current_mode ==# 'replace' ? 'R' : '' : ''
endfunction

function! LightlineGitBranch() abort
  let l:_ = gitbranch#name()
  return winwidth(0) >= 80 && l:_ !=# '' ? "\ue0a0 " . l:_ : ''
endfunction

" http://qiita.com/yuyuchu3333/items/20a0acfe7e0d0e167ccc
function! LightlineGitGutter() abort
  if winwidth(0) >= 90 && get(g:, 'gitgutter_enabled')
    let l:symbols = [
          \   g:gitgutter_sign_added,
          \   g:gitgutter_sign_modified,
          \   g:gitgutter_sign_removed,
          \ ]
    let l:hunks = GitGutterGetHunkSummary()
    let l:_ = []
    for l:i in [0, 1, 2]
      if l:hunks[l:i] > 0
        call add(l:_, l:symbols[l:i] . ' ' . l:hunks[l:i])
      endif
    endfor
    return join(l:_, ' ')
  else
    return ''
  endif
endfunction
" }}}

" clever-f.vim {{{
let g:clever_f_across_no_line = 1
let g:clever_f_smart_case     = 1
" }}}

" committia.vim {{{
let g:committia_hooks = {}
function! g:committia_hooks.edit_open(info) abort
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
      \   'outputter/quickfix/into':  1,
      \   'runner': 'job',
      \ }

if executable('clang++')
  let g:quickrun_config.cpp = {
        \   'command':    'clang++',
        \   'cmdopt':     '-Wall -Wextra -std=c++14 -lboost_system -pthread',
        \ }
endif

if executable('stack')
  let g:quickrun_config.haskell = {
        \   'command': 'stack',
        \   'exec': '%c %o %s %a',
        \   'cmdopt': 'runghc',
        \ }
endif

nnoremap <silent> <Leader>r :<C-u>QuickRun<CR>
nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "<C-c>"
" }}}

" switch.vim {{{
nnoremap <silent> <Leader>sw :<C-u>Switch<CR>
" }}}

" emmet-vim {{{
let g:user_emmet_settings = {
      \   'indentation' : '  '
      \ }
" }}}

" vim-textmanip {{{
xmap <Leader>d <Plug>(textmanip-duplicate-down)
xmap <Leader>D <Plug>(textmanip-duplicate-up)
xmap <C-j>     <Plug>(textmanip-move-down)
xmap <C-k>     <Plug>(textmanip-move-up)
xmap <C-h>     <Plug>(textmanip-move-left)
xmap <C-l>     <Plug>(textmanip-move-right)

nmap <silent> <F10> <Plug>(textmanip-toggle-mode)
xmap <silent> <F10> <Plug>(textmanip-toggle-mode)
" }}}

" YouCompleteMe {{{
let g:ycm_allow_changing_updatetime = 0
let g:ycm_complete_in_comments      = 1
let g:ycm_confirm_extra_conf        = 0
let g:ycm_show_diagnostics_ui       = 0
let g:ycm_extra_conf_vim_data       = ['&filetype']
let g:ycm_global_ycm_extra_conf     = '~/.vim/ycm_extra_conf.py'
let g:ycm_goto_buffer_command       = 'new-or-existing-tab'
let g:ycm_key_list_stop_completion  = ['<C-y>', '<CR>']
let g:ycm_python_binary_path        = 'python'
let g:ycm_semantic_triggers         = {'haskell': ['re!(import\s+.*|\w\.)']}

nnoremap <silent> <Leader>f  :<C-u>YcmCompleter FixIt<CR>
nnoremap <silent> <Leader>t  :<C-u>YcmCompleter GetType<CR>
nnoremap <silent> <Leader>gd :<C-u>YcmCompleter GoToDeclaration<CR>
nnoremap <silent> <Leader>gD :<C-u>YcmCompleter GoToDefinition<CR>
" }}}

" vim-lsp {{{
if executable('hie')
  autocmd MyVimrc User lsp_setup call lsp#register_server({
        \   'name':      'hie',
        \   'cmd':       {server_info->['hie', '--lsp']},
        \   'whitelist': ['haskell'],
        \ })
  autocmd MyVimrc FileType haskell setlocal omnifunc=lsp#complete
endif
" }}}

" UltiSnips {{{
let g:UltiSnipsExpandTrigger        = '<C-e>'
let g:UltiSnipsJumpBackwardTrigger  = '<C-b>'
let g:UltiSnipsJumpForwardTrigger   = '<C-e>'
" }}}

" vim-operator-replace {{{
nmap R  <Plug>(operator-replace)
" }}}

" vim-clang-format {{{
let g:clang_format#auto_formatexpr = 1
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

autocmd MyVimrc FileType c,cpp xmap <buffer> <Leader>x <Plug>(operator-clang-format)
" }}}
" }}}
