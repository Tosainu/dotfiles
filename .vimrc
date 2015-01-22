scriptencoding utf-8

" basic settings {{{
" skip when vim-tiny or vim-small
if !1 | finish | endif

" vimrc augroup
augroup MyVimrc
  autocmd!
augroup END

" encoding
set encoding=utf-8
set fileencoding=utf=8
set fileencodings=utf-8,cp932,euc-jp
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
" commandline
set wildmenu wildignorecase wildmode=list:full
" separator style
set fillchars+=vert:\ 
" launch file in tab
set switchbuf+=usetab,newtab

" add <> to matchpairs
set matchpairs+=<:>
" history
set history=100
" backspace
set backspace=indent,eol,start
" use japanese-help first
set helplang=ja,en

" folding
set foldmethod=marker
set foldlevel=99
set nofoldenable

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

" timeout
set timeoutlen=500
set updatetime=200

" no backup files
set nobackup

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

" disable auto comment
autocmd MyVimrc BufEnter * setlocal formatoptions-=ro
" open last position
autocmd MyVimrc BufRead * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
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

" remap j/k
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
xnoremap <expr> j (v:count == 0 && mode() !=# 'V') ? 'gj' : 'j'
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
xnoremap <expr> k (v:count == 0 && mode() !=# 'V') ? 'gk' : 'k'

" keep the middle of the screen when searching
nnoremap n nzvzz
nnoremap N Nzvzz
nnoremap * *zvzz
nnoremap # #zvzz

" change window size
nnoremap <S-Up>    <C-W>-
nnoremap <S-Down>  <C-W>+
nnoremap <S-Left>  <C-W><
nnoremap <S-Right> <C-W>>

" redraw screen and remove highlighting
nnoremap <silent> <C-L> :<C-u>nohlsearch<CR><C-L>

" fcitx
if executable('fcitx-remote')
  autocmd MyVimrc InsertLeave * call vimproc#system('fcitx-remote -c')
endif
" }}}

" filetypes {{{
" C++
autocmd MyVimrc FileType cpp call s:cpp_config()
function! s:cpp_config()
  setlocal cinoptions& cinoptions+=g0,m1

  " include path
  let s:incpath = [
        \   '/usr/include/boost',
        \   '/usr/include/c++/v1',
        \   '/usr/include/qt/QtCore',
        \   '/usr/include/qt/QtWidgets',
        \   expand('~/.ghq/github.com/bolero-MURAKAMI/Sprout'),
        \ ]

  let s:tmp = ''
  for p in s:incpath
    if isdirectory(p)
      let s:tmp .= ',' .  p
    endif
  endfor

  execute 'setlocal path+=' . s:tmp

  " expand namespace
  inoremap <buffer><expr>; <SID>expand_namespace()
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

  " clangformat
  map <buffer><Leader>cf <Plug>(operator-clang-format)
endfunction

" markdown
autocmd MyVimrc FileType markdown call s:markdown_config()
function! s:markdown_config()
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
endfunction

" quickfix
autocmd MyVimrc FileType qf   nnoremap <buffer><silent> q :<C-u>cclose<CR>
" help
autocmd MyVimrc FileType help nnoremap <buffer><silent> q :<C-u>q<CR>
" }}}

" neobundle {{{
" install neobundle
if !isdirectory(expand('~/.vim/bundle'))
  echon "Installing neobundle.vim..."
  silent call mkdir(expand('~/.vim/bundle'), 'p')
  silent !git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim
  if v:shell_error
    echoerr "neobundle.vim installation has failed!"
    finish
  elseif
    echo "done."
  endif
endif

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
endif

call neobundle#begin(expand('~/.vim/bundle/'))

" require
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc.vim', {
      \   'build': {
      \     'unix': 'make -f make_unix.mak',
      \     'mac' : 'make -f make_mac.mak'
      \   }
      \ }

NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'itchyny/lightline.vim'

NeoBundle 'thinca/vim-quickrun'
NeoBundle 'osyo-manga/vim-watchdogs', {'depends': ['thinca/vim-quickrun', 'osyo-manga/shabadou.vim']}

NeoBundle 'jceb/vim-hier'
NeoBundle 'rhysd/clever-f.vim'
NeoBundle 't9md/vim-textmanip'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'tpope/vim-surround'
NeoBundle 'vim-jp/vimdoc-ja'

NeoBundleLazy 'AndrewRadev/switch.vim'
NeoBundleLazy 'Shougo/vimfiler'
NeoBundleLazy 'Shougo/vinarise.vim'
NeoBundleLazy 'kannokanno/previm', {'depends': 'tyru/open-browser.vim'}
NeoBundleLazy 'koron/nyancat-vim'
NeoBundleLazy 'mattn/emmet-vim'
NeoBundleLazy 'osyo-manga/vim-over'

NeoBundleLazy 'Shougo/neocomplete.vim'
NeoBundleLazy "Shougo/neosnippet.vim",    {'depends': 'Shougo/neocomplete.vim'}
NeoBundleLazy 'osyo-manga/vim-marching'
NeoBundleLazy 'rhysd/vim-clang-format'

" operator
NeoBundle 'kana/vim-operator-user'

" colorscheme
NeoBundle 'Tosainu/last256'
NeoBundle 'chriskempson/vim-tomorrow-theme'
NeoBundle 'w0ng/vim-hybrid'

" unite
NeoBundleLazy 'Shougo/unite.vim'
NeoBundleLazy 'Shougo/neomru.vim',        {'depends': 'Shougo/unite.vim'}
NeoBundleLazy 'rhysd/unite-codic.vim',    {'depends': ['Shougo/unite.vim', 'koron/codic-vim']}
NeoBundleLazy 'ujihisa/unite-colorscheme',{'depends': 'Shougo/unite.vim'}

" languages
NeoBundleLazy 'sudar/vim-arduino-syntax', {'autoload': {'filetypes': 'arduino'}}
NeoBundleLazy 'vim-jp/cpp-vim',           {'autoload': {'filetypes': 'cpp'}}
NeoBundleLazy 'dag/vim2hs',               {'autoload': {'filetypes': 'haskell'}}
NeoBundleLazy 'JavaScript-syntax',        {'autoload': {'filetypes': 'javascript'}}
NeoBundleLazy 'pangloss/vim-javascript',  {'autoload': {'filetypes': 'javascript'}}
NeoBundleLazy 'slim-template/vim-slim',   {'autoload': {'filetypes': 'slim'}}
NeoBundleLazy 'nginx.vim',                {'autoload': {'filetypes': 'nginx'}}
NeoBundleLazy 'ap/vim-css-color',         {'autoload': {'filetypes': ['css', 'scss']}}
NeoBundleLazy 'hail2u/vim-css3-syntax',   {'autoload': {'filetypes': ['css', 'scss']}}
NeoBundleLazy 'othree/html5.vim',         {'autoload': {'filetypes': ['html', 'eruby', 'slim']}}
NeoBundleLazy 'vim-ruby/vim-ruby',        {'autoload': {'filetypes': ['ruby', 'eruby', 'slim']}}

" vim-gitgutter {{{
if neobundle#tap('vim-gitgutter')
  let g:gitgutter_max_signs = 1000

  call neobundle#untap()
endif
" }}}

" lightline.vim {{{
if neobundle#tap('lightline.vim')
  let g:lightline = {
        \   'colorscheme': 'wombat',
        \   'active': {
        \     'left': [
        \       ['mode'],
        \       ['readonly', 'filename', 'modified'],
        \     ],
        \     'right': [
        \       ['lineinfo'],
        \       ['percent'],
        \       ['fileformat', 'fileencoding', 'filetype'],
        \       ['gitgutter', 'fugitive'],
        \     ]
        \   },
        \   'component_function': {
        \     'readonly':   'LightlineReadonly',
        \     'modified':   'LightlineModified',
        \     'fugitive':   'LightlineFugitive',
        \     'gitgutter':  'LightlineGitGutter',
        \   }
        \ }

  function! LightlineModified()
    return &ft =~ 'help\|vimfiler' ? '' : &modified ? '+' : &modifiable ? '' : '-'
  endfunction

  function! LightlineReadonly()
    return &ft !~? 'help\|vimfiler' && &ro ? 'RO' : ''
  endfunction

  function! LightlineFugitive()
    return exists('*fugitive#head') ? fugitive#head() : ''
  endfunction

  function! LightlineGitGutter()
    if !exists('*GitGutterGetHunkSummary')
          \ || !get(g:, 'gitgutter_enabled', 0)
          \ || winwidth('.') <= 90
      return ''
    endif
    let symbols = [
          \ g:gitgutter_sign_added . ' ',
          \ g:gitgutter_sign_modified . ' ',
          \ g:gitgutter_sign_removed . ' '
          \ ]
    let hunks = GitGutterGetHunkSummary()
    let ret = []
    for i in [0, 1, 2]
      if hunks[i] > 0
        call add(ret, symbols[i] . hunks[i])
      endif
    endfor
    return join(ret, ' ')
  endfunction

  call neobundle#untap()
endif
" }}}

" vim-quickrun {{{
if neobundle#tap('vim-quickrun')
  let g:quickrun_no_default_key_mappings = 1

  let g:quickrun_config = get(g:, 'quickrun_config', {})
  let g:quickrun_config._ = {
        \   'outputter/buffer/split': ':botright',
        \   'outputter/buffer/into':  1,
        \   'outputter/buffer/close_on_empty': 1,
        \   'outputter/error': 'quickfix',
        \   'outputter/error/success': 'buffer',
        \   'outputter': 'error',
        \   'runner': 'vimproc',
        \ }

  let g:quickrun_config.cpp = {
        \   'command':    'clang++',
        \   'cmdopt':     '-std=c++1y -Wall -Wextra -lboost_system -pthread -I' . expand('~/.ghq/github.com/bolero-MURAKAMI/Sprout'),
        \ }

  let g:quickrun_config.make = {
        \   'command':    'make',
        \   'exec':       '%c %o %a',
        \   'cmdopt':     '-j',
        \   'outputter':  'quickfix',
        \ }

  let g:quickrun_config.markdown = {
        \   'outputter':  'null',
        \ }

  " vim-watchdogs
  let g:quickrun_config['watchdogs_checker/clang++'] = {
        \   'command':    'clang++',
        \   'exec':       '%c %o -std=c++1y -fsyntax-only %s:p',
        \ }
  let g:quickrun_config['cpp/watchdogs_checker'] = {
        \   'type':       'watchdogs_checker/clang++',
        \ }

  if executable('sass')
    let g:quickrun_config['watchdogs_checker/sass'] = {
          \   'command':      'sass',
          \   'exec':         '%c %o --check --compass --trace --no-cache %s:p',
          \   'errorformat':  '%f:%l:%m\ (Sass::SyntaxError),%-G%.%#',
          \ }
    let g:quickrun_config['sass/watchdogs_checker'] = {
          \   'type':         'watchdogs_checker/sass',
          \ }

    let g:quickrun_config['watchdogs_checker/scss'] = {
          \   'command':      'sass',
          \   'exec':         '%c %o --check --compass --trace --no-cache %s:p',
          \   'errorformat':  '%f:%l:%m\ (Sass::SyntaxError),%-G%.%#',
          \ }
    let g:quickrun_config['scss/watchdogs_checker'] = {
          \   'type':         'watchdogs_checker/scss',
          \ }
  endif

  nnoremap <silent> <Space>r :<C-u>QuickRun<CR>
  nnoremap <silent> <Space>mb :<C-u>QuickRun -type make<CR>
  nnoremap <silent> <Space>mc :<C-u>QuickRun -type make -args clean<CR>
  nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"

  call neobundle#untap()
endif
" }}}

" vim-watchdogs {{{
if neobundle#tap('vim-watchdogs')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:watchdogs_check_BufWritePost_enables = {
          \   'c':          1,
          \   'javascript': 1,
          \   'lua':        1,
          \   'ruby':       1,
          \   'sass':       1,
          \   'scss':       1,
          \ }

    call watchdogs#setup(g:quickrun_config)
  endfunction
endif
" }}}

" clever-f.vim {{{
if neobundle#tap('clever-f.vim')
  let g:clever_f_across_no_line = 1
  let g:clever_f_smart_case = 1
  let g:clever_f_use_migemo = 1

  call neobundle#untap()
endif
" }}}

" vim-textmanip {{{
if neobundle#tap('vim-textmanip')
  xmap <C-j> <Plug>(textmanip-move-down)
  xmap <C-k> <Plug>(textmanip-move-up)
  xmap <C-h> <Plug>(textmanip-move-left)
  xmap <C-l> <Plug>(textmanip-move-right)

  call neobundle#untap()
endif
" }}}

" switch.vim {{{
if neobundle#tap('switch.vim')
  call neobundle#config({
        \   'autoload': {'commands': ['Switch']}
        \ })

  nnoremap <silent> <Leader>sw :<C-u>Switch<CR>

  call neobundle#untap()
endif
" }}}

" vimfiler {{{
if neobundle#tap('vimfiler')
  call neobundle#config({
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
        \ })

  function! neobundle#tapped.hooks.on_source(bundle)
    let g:vimfiler_as_default_explorer = 1
    let g:vimfiler_safe_mode_by_default = 0
    " open in new tab
    let g:vimfiler_edit_action = 'tabopen'
    " ignore patern
    let g:vimfiler_ignore_pattern = '\(^\.git\|\.[ao]\|\.out\|\.bin\)$'
  endfunction

  " open Vimfiler
  nmap <silent> <Leader>vf :<C-u>VimFilerExplorer -winwidth=25<CR>

  call neobundle#untap()
endif
" }}}

" vinarise.vim {{{
if neobundle#tap('vinarise.vim')
  call neobundle#config({
        \   'autoload': {'commands': ['Vinarise']},
        \   'disabled': !has('python') && !has('python3'),
        \ })

  call neobundle#untap()
endif
" }}}

" previm {{{
if neobundle#tap('previm')
  call neobundle#config({
        \   'autoload': {'filetypes': 'markdown'}
        \ })

  let g:previm_enable_realtime = 1

  nnoremap <silent> <Space>p :<C-u>PrevimOpen<CR>

  call neobundle#untap()
endif
" }}}

" nyancat-vim {{{
if neobundle#tap('nyancat-vim')
  call neobundle#config({
        \   'autoload': {'commands': ['Nyancat', 'Nyancat2']}
        \ })

  call neobundle#untap()
endif
" }}}

" emmet-vim {{{
if neobundle#tap('emmet-vim')
  call neobundle#config({
        \   'autoload': {'filetypes': ['html', 'eruby', 'css', 'scss', 'slim']}
        \ })

  function! neobundle#tapped.hooks.on_source(bundle)
    let g:user_emmet_settings = {
          \   'indentation' : '  '
          \ }

    imap <buffer><silent> <C-e> <Plug>(emmet-expand-abbr)
  endfunction

  call neobundle#untap()
endif
" }}}

" vim-over {{{
if neobundle#tap('vim-over')
  call neobundle#config({
        \   'autoload': {'commands': ['OverCommandLine']}
        \ })

  call neobundle#untap()
endif
" }}}

" neocomplete.vim {{{
if neobundle#tap('neocomplete.vim')
  call neobundle#config({
        \   'autoload': {'insert': '1'},
        \   'disabled': !has('lua'),
        \ })

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
  let g:neocomplete#force_omni_input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'

  " keybinds
  inoremap <expr><BS>     neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><C-g>    neocomplete#undo_completion()
  inoremap <expr><TAB>    pumvisible() ? "\<C-n>" : "\<TAB>"
  inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"

  call neobundle#untap()
endif
" }}}

" neosnippet.vim {{{
if neobundle#tap('neosnippet.vim')
  call neobundle#config({
        \   'autoload': {
        \     'insert' : '1',
        \     'filename_patterns': '.*\.snip'
        \   }
        \ })

  let g:neosnippet#disable_runtime_snippets = {
        \   "_": 1,
        \ }
  let g:neosnippet#snippets_directory='~/.vim/snippets'

  " keybinds
  imap <expr><CR> !pumvisible() ? "\<CR>" :
        \ neosnippet#expandable() ? "\<Plug>(neosnippet_expand)" :
        \ neocomplete#close_popup()
  imap <expr><TAB> !pumvisible() ?
        \ neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)" : "\<Tab>"
        \ : "\<C-n>"
  smap <expr><TAB> neosnippet#jumpable() ?
        \ "\<Plug>(neosnippet_jump)"
        \ : "\<TAB>"

  " for snippet_complete marker
  if has('conceal')
    set conceallevel=2 concealcursor=i
  endif

  call neobundle#untap()
endif
" }}}

" vim-marching {{{
if neobundle#tap('vim-marching')
  call neobundle#config({
        \   'autoload': {'filetypes': 'cpp'},
        \   'disable':  !executable('clang'),
        \ })

  function! neobundle#tapped.hooks.on_source(bundle)
    let g:marching_clang_command_option = '-std=c++1y'

    if neobundle#is_installed('neocomplete.vim')
      let g:marching_enable_neocomplete = 1
    endif
  endfunction

  call neobundle#untap()
endif
" }}}

" vim-clang-format {{{
if neobundle#tap('vim-clang-format')
  call neobundle#config({
        \   'autoload': {
        \     'commands': ['ClangFormat', 'ClangFormatEchoFormattedCode'],
        \     'filetypes': ['c', 'cpp']
        \   },
        \   'disable':  !executable('clang'),
        \ })

  let g:clang_format#style_options = {
        \   'AccessModifierOffset' : -2,
        \   'ColumnLimit' : 128,
        \   'Standard' : 'C++11',
        \ }

  call neobundle#untap()
endif
" }}}

" unite.vim {{{
if neobundle#tap('unite.vim')
  call neobundle#config({
        \   'autoload': {
        \     'commands': [{
        \       'name': 'Unite',
        \         'complete': 'customlist,unite#complete_source'
        \       },
        \       'UniteWithCursorWord', 'UniteWithInput'
        \     ]
        \   }
        \ })

  function! neobundle#tapped.hooks.on_source(bundle)
    let g:unite_source_file_mru_limit = 200
    let g:unite_force_overwrite_statusline = 0
    let g:unite_source_history_yank_enable = 1

    " always open new tab
    call unite#custom_default_action('file', 'tabopen')
    " show dotfiles
    call unite#custom#source('file,file_rec/git', 'matchers', 'matcher_default')

    autocmd MyVimrc FileType unite call s:unite_myconfig()
    function! s:unite_myconfig()
      imap <silent><buffer> <C-w> <Plug>(unite_delete_backward_path)
    endfunction
  endfunction

  " keybinds
  nnoremap [unite]  <Nop>
  nmap     <Space>u [unite]
  nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir file -buffer-name=files<CR>
  nnoremap <silent> [unite]r :<C-u>Unite file_rec/git -buffer-name=repository<CR>
  nnoremap <silent> [unite]n :<C-u>Unite file/new -start-insert -buffer-name=newfile<CR>
  nnoremap <silent> [unite]s :<C-u>Unite line -start-insert -buffer-name=search<CR>
  nnoremap <silent> [unite]b :<C-u>Unite buffer -buffer-name=buffer<CR>
  nnoremap <silent> [unite]t :<C-u>Unite tab -buffer-name=tab<CR>
  nnoremap <silent> [unite]y :<C-u>Unite history/yank -buffer-name=yank<CR>
  nnoremap <silent> [unite]R :<C-u>UniteResume<CR>

  call neobundle#untap()
endif
" }}}

" neomru.vim {{{
if neobundle#tap('neomru.vim')
  call neobundle#config({
        \   'autoload': {'unite_sources': 'file_mru'}
        \ })

  nnoremap <silent> [unite]h :<C-u>Unite file_mru -buffer-name=history<CR>

  call neobundle#untap()
endif
" }}}

" unite-codic.vim {{{
if neobundle#tap('unite-codic.vim')
  call neobundle#config({
        \   'autoload': {'unite_sources': ['codic']}
        \ })

  nnoremap <silent> [unite]c :<C-u>Unite codic -start-insert -buffer-name=codic<CR>

  call neobundle#untap()
endif
" }}}

" unite-colorscheme {{{
if neobundle#tap('unite-colorscheme')
  call neobundle#config({
        \   'autoload': {'unite_sources': ['colorscheme']}
        \ })

  call neobundle#untap()
endif
" }}}

call neobundle#end()
filetype plugin indent on

NeoBundleCheck

if !has('vim_starting')
  call neobundle#call_hook('on_source')
endif

" }}}

" colorscheme {{{
syntax enable
if !has('gui_running')
  if $TERM =~# '^xterm'
    " color mode
    set t_Co=256

    try
      colorscheme last256
    catch
      colorscheme slate
    endtry

    " transparent background
    highlight Normal ctermbg=none
  else
    colorscheme default
  endif
endif
" }}}
