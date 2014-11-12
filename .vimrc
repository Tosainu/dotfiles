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

" add <> to matchpairs
set matchpairs+=<:>
" history
set history=100
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

" disable auto comment
autocmd MyVimrc BufEnter * setlocal formatoptions-=ro

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
if has('persistent_undo')
  if !isdirectory($HOME.'/.vim/undo')
    call mkdir($HOME.'/.vim/undo', 'p')
  endif
  set undodir=~/.vim/undo
  set undofile
endif

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

" swap j/k gj/gk
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" change window size
nnoremap <S-Up>    <C-W>-
nnoremap <S-Down>  <C-W>+
nnoremap <S-Left>  <C-W><
nnoremap <S-Right> <C-W>>

" off highlight <ESC> * 2
nmap <silent> <Esc><Esc> :<C-u>nohlsearch<CR><Esc>

" fcitx
if executable('fcitx-remote')
  autocmd MyVimrc InsertLeave * call vimproc#system('fcitx-remote -c')
endif
" }}}

" filetypes {{{
" C++
autocmd MyVimrc FileType cpp call s:cpp_myconfig()
function! s:cpp_myconfig()
  set cinoptions& cinoptions+=g0,m1

  " include path
  setlocal path+=/usr/include/c++/v1,/usr/include/boost,/usr/include/qt

  " expand namespace
  inoremap <buffer><expr>; <SID>expand_namespace()

  " clangformat
  map <buffer><Leader>cf <Plug>(operator-clang-format)
endfunction

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

" markdown
autocmd MyVimrc BufNewFile,BufRead *.{md,mkd,markdown} call s:markdown_myconfig()
function! s:markdown_myconfig()
  set filetype=markdown

  let g:markdown_fenced_languages = [
        \   'c',
        \   'cpp',
        \   'css',
        \   'html',
        \   'javascript',
        \   'ruby',
        \   'vim',
        \ ]
endfunction

" slim
autocmd MyVimrc BufNewFile,BufRead *.{slim} set filetype=slim

" nginx
autocmd MyVimrc BufRead,BufNewFile /etc/nginx/* set filetype=nginx

" quickfix
autocmd MyVimrc FileType qf nnoremap <buffer><silent> q :<C-u>cclose<CR>

" help
autocmd MyVimrc FileType help nnoremap <buffer><silent> q :<C-u>q<CR>
" }}}

" neobundle {{{
" Skip initialization for vim-tiny or vim-small
if !1 | finish | endif

" install neobundle (https://github.com/rhysd/dotfiles/blob/master/vimrc#L758-L768)
if !isdirectory(expand('~/.vim/bundle'))
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

call neobundle#begin(expand('~/.vim/bundle/'))

" require
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc', {
      \   'build': {
      \     'unix': 'make -f make_unix.mak',
      \     'mac' : 'make -f make_mac.mak'
      \   }
      \ }

" tools
NeoBundle 'itchyny/lightline.vim', {'depends': 'airblade/vim-gitgutter'}
NeoBundle 'rhysd/clever-f.vim'
NeoBundle 'scrooloose/syntastic'
NeoBundle 't9md/vim-foldtext'
NeoBundle 't9md/vim-textmanip'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-surround'
NeoBundle 'vim-jp/vimdoc-ja'
NeoBundleLazy 'Shougo/vimfiler'
NeoBundleLazy 'osyo-manga/vim-over'
if executable('clang')
  NeoBundleLazy 'rhysd/vim-clang-format'
endif
if has('python3')
  NeoBundleLazy 'Shougo/vinarise.vim'
endif

" unite
NeoBundleLazy 'Shougo/unite.vim', {'depends': 'Shougo/vimproc'}
NeoBundleLazy 'Shougo/neomru.vim', {'depends': 'Shougo/unite.vim'}
NeoBundleLazy 'rhysd/unite-codic.vim', {'depends': ['Shougo/unite.vim', 'koron/codic-vim']}
NeoBundleLazy 'ujihisa/unite-colorscheme', {'depends': 'Shougo/unite.vim'}

" quickrun
NeoBundleLazy 'thinca/vim-quickrun'
NeoBundleLazy 'superbrothers/vim-quickrun-markdown-gfm', {'depends': ['mattn/webapi-vim', 'thinca/vim-quickrun', 'tyru/open-browser.vim']}

" completetion
NeoBundleLazy 'mattn/emmet-vim'
if has('lua') && (v:version > 703 || (v:version == 703 && has('patch885')))
  NeoBundleLazy 'Shougo/neocomplete.vim'
  NeoBundleLazy "Shougo/neosnippet.vim", {'depends': 'Shougo/neocomplete.vim'}
  NeoBundleLazy 'mattn/jscomplete-vim'
endif
if executable('clang')
  NeoBundleLazy 'osyo-manga/vim-marching', {'depends': ['Shougo/vimproc']}
endif

" Operator
NeoBundle 'kana/vim-operator-user'

" colorscheme
NeoBundle 'Tosainu/last256'
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'chriskempson/vim-tomorrow-theme'

" languages
NeoBundleLazy 'vim-jp/cpp-vim'
NeoBundleLazy 'vim-ruby/vim-ruby'
NeoBundleLazy 'dag/vim2hs'
NeoBundleLazy 'ap/vim-css-color'
NeoBundleLazy 'hail2u/vim-css3-syntax'
NeoBundleLazy 'othree/html5.vim'
NeoBundleLazy 'JavaScript-syntax'
NeoBundleLazy 'pangloss/vim-javascript'
NeoBundleLazy 'slim-template/vim-slim'
NeoBundleLazy 'sudar/vim-arduino-syntax'
NeoBundleLazy 'nginx.vim'

call neobundle#end()

filetype plugin indent on
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

" plugins config {{{

" lightline.vim {{{
if neobundle#tap('lightline.vim')
  let g:lightline = {
        \   'colorscheme': 'wombat',
        \   'active': {
        \     'left': [
        \       ['mode'],
        \       ['readonly', 'filename', 'modified']
        \     ],
        \     'right': [
        \       ['lineinfo', 'syntastic'],
        \       ['percent'],
        \       ['fileformat', 'fileencoding', 'filetype'],
        \       ['gitgutter', 'fugitive']
        \     ]
        \   },
        \   'component_function': {
        \     'readonly': 'MyReadonly',
        \     'modified': 'MyModified',
        \     'fugitive': 'MyFugitive',
        \     'gitgutter': 'MyGitGutter',
        \     'syntastic': 'SyntasticStatuslineFlag'
        \   }
        \ }

  function! MyModified()
    return &ft =~ 'help\|vimfiler' ? '' : &modified ? '+' : &modifiable ? '' : '-'
  endfunction

  function! MyReadonly()
    return &ft !~? 'help\|vimfiler' && &ro ? 'RO' : ''
  endfunction

  function! MyFugitive()
    return exists('*fugitive#head') ? fugitive#head() : ''
  endfunction

  function! MyGitGutter()
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

" vim-gitgutter {{{
if neobundle#tap('vim-gitgutter')
  let g:gitgutter_sign_added = '+'
  let g:gitgutter_sign_modified = '~'
  let g:gitgutter_sign_removed = '-'

  let g:gitgutter_max_signs = 1000

  call neobundle#untap()
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

" syntastic {{{
if neobundle#tap('syntastic')
  let g:syntastic_mode_map = {
        \   'mode': 'active',
        \   'passive_filetypes': ['cpp', 'tex']
        \ }
  let g:syntastic_auto_loc_list = 1
  let g:syntastic_check_on_wq = 0
  let g:syntastic_enable_signs = 0
  let g:syntastic_c_compiler = 'clang'
  let g:syntastic_cpp_compiler = 'clang++'
  let g:syntastic_cpp_compiler_options = '-std=c++11 -stdlib=libc++ -lc++abi'
  let g:syntastic_javascript_jshint_args = '--config ~/.jshintrc'
  let g:syntastic_java_javac_classpath = '/opt/android-sdk/platforms/android-15/android.jar'

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

    autocmd MyVimrc FileType vimfiler call s:vimfiler_myconfig()
    function! s:vimfiler_myconfig()
      " hide <ESC> * 2
      nmap <buffer> <ESC><ESC> <Plug>(vimfiler_hide)
    endfunction
  endfunction

  " open Vimfiler
  nmap <silent> <Leader>vf :<C-u>VimFilerExplorer<CR>

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

" vinarise.vim {{{
if neobundle#tap('vinarise.vim')
  call neobundle#config({
        \   'autoload': {'commands': ['Vinarise']}
        \ })

  call neobundle#untap()
endif
" }}}

" vim-clang-format {{{
if neobundle#tap('vim-clang-format')
  call neobundle#config({
        \   'autoload': {
        \     'commands': ['ClangFormat', 'ClangFormatEchoFormattedCode'],
        \     'filetypes': ['c', 'cpp']
        \   }
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
    let g:unite_source_file_mru_limit=200
    let g:unite_source_history_yank_enable = 1

    " always open new tab
    call unite#custom_default_action('file', 'tabopen')
    " show dotfiles
    call unite#custom#source('file,file_rec/git', 'matchers', 'matcher_default')

    autocmd MyVimrc FileType unite call s:unite_myconfig()
    function! s:unite_myconfig()
      " close <ESC> * 2
      nmap <silent><buffer> <ESC><ESC> <Plug>(unite_exit)
      imap <silent><buffer> <ESC><ESC> <Plug>(unite_exit)

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

" vim-quickrun {{{
if neobundle#tap('vim-quickrun')
  call neobundle#config({
        \   'autoload': {
        \     'commands': ['QuickRun'],
        \     'mappings': ['<Plug>(quickrun)'],
        \   }
        \ })

  function! neobundle#tapped.hooks.on_source(bundle)
    let g:quickrun_no_default_key_mappings = 1

    let g:quickrun_config = get(g:, 'quickrun_config', {})
    let g:quickrun_config._ = {
          \     'outputter/buffer/split': ':botright',
          \     'outputter/buffer/into':  1,
          \     'outputter/buffer/close_on_empty': 1,
          \     'outputter/error': 'quickfix',
          \     'outputter/error/success': 'buffer',
          \     'outputter': 'error',
          \     'runner': 'vimproc',
          \   }
    let g:quickrun_config.cpp = {
          \     'command': 'clang++',
          \     'cmdopt': '-std=c++11 -stdlib=libc++ -lc++abi -Wall -Wextra -lboost_system -lpthread'
          \   }
    let g:quickrun_config.markdown = {
          \     'type': 'markdown/gfm',
          \     'outputter': 'browser'
          \   }
  endfunction

  nnoremap <silent> <Space>r  :<C-u>QuickRun<CR>
  nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"

  call neobundle#untap()
endif
" }}}

" vim-quickrun-markdown-gfm {{{
if neobundle#tap('vim-quickrun-markdown-gfm')
  call neobundle#config({
        \   'autoload': {
        \     'commands': ['QuickRun'],
        \     'mappings': ['<Plug>(quickrun)'],
        \     'filetypes': ['markdown']
        \   }
        \ })

  call neobundle#untap()
endif
" }}}

" neocomplete.vim {{{
if neobundle#tap('neocomplete.vim')
  call neobundle#config({
        \   'autoload': {'insert': '1'}
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

" emmet-vim {{{
if neobundle#tap('emmet-vim')
  call neobundle#config({
        \   'autoload': {'filetypes': ['html', 'xhtml', 'eruby', 'css']}
        \ })

  function! neobundle#tapped.hooks.on_source(bundle)
    let g:user_emmet_leader_key = '<C-e>'
  endfunction

  call neobundle#untap()
endif
" }}}

" jscomplete-vim {{{
if neobundle#tap('jscomplete-vim')
  call neobundle#config({
        \   'autoload': {'filetypes': 'javascript'}
        \ })

  function! neobundle#tapped.hooks.on_source(bundle)
    let g:jscomplete_use = ['dom']
  endfunction

  call neobundle#untap()
endif
" }}}

" vim-marching {{{
if neobundle#tap('vim-marching')
  call neobundle#config({
        \   'autoload': {'filetypes': 'cpp'}
        \ })

  function! neobundle#tapped.hooks.on_source(bundle)
    let g:marching_clang_command = '/usr/bin/clang'
    let g:marching_clang_command_option = '-std=c++11 -stdlib=libc++ -lc++abi'

    if neobundle#is_installed('neocomplete.vim')
      let g:marching_enable_neocomplete = 1
    endif
  endfunction

  call neobundle#untap()
endif
" }}}

" cpp-vim {{{
if neobundle#tap('cpp-vim')
  call neobundle#config({
        \   'autoload': {'filetypes': 'cpp'}
        \ })

  call neobundle#untap()
endif
" }}}

" vim-ruby {{{
if neobundle#tap('vim-ruby')
  call neobundle#config({
        \   'autoload': {'filetypes': ['ruby', 'eruby']}
        \ })

  call neobundle#untap()
endif
" }}}

" vim2hs {{{
if neobundle#tap('vim2hs')
  call neobundle#config({
        \   'autoload': {'filetypes': 'haskell'}
        \ })

  call neobundle#untap()
endif
" }}}

" vim-css-color {{{
if neobundle#tap('vim-css-color')
  call neobundle#config({
        \   'autoload': {'filetypes': ['css', 'eruby', 'html', 'xhtml']}
        \ })

  call neobundle#untap()
endif
" }}}

" vim-css3-syntax {{{
if neobundle#tap('vim-css3-syntax')
  call neobundle#config({
        \   'autoload': {'filetypes': 'css'}
        \ })

  call neobundle#untap()
endif
" }}}

" html5.vim {{{
if neobundle#tap('html5.vim')
  call neobundle#config({
        \   'autoload': {'filetypes': ['eruby', 'html', 'xhtml']}
        \ })

  call neobundle#untap()
endif
" }}}

" JavaScript-syntax {{{
if neobundle#tap('JavaScript-syntax')
  call neobundle#config({
        \   'autoload': {'filetypes': 'javascript'}
        \ })

  call neobundle#untap()
endif
" }}}

" vim-javascript {{{
if neobundle#tap('vim-javascript')
  call neobundle#config({
        \   'autoload': {'filetypes': 'javascript'}
        \ })

  call neobundle#untap()
endif
" }}}

" vim-slim {{{
if neobundle#tap('vim-slim')
  call neobundle#config({
        \   'autoload': {'filetypes': 'slim'}
        \ })

  call neobundle#untap()
endif
" }}}

" vim-arduino-syntax {{{
if neobundle#tap('vim-arduino-syntax')
  call neobundle#config({
        \   'autoload': {'filename_patterns': '.*\.ino'}
        \ })

  call neobundle#untap()
endif
" }}}

" nginx.vim {{{
if neobundle#tap('nginx.vim')
  call neobundle#config({
        \   'autoload': {'filetypes': 'javascript'}
        \ })

  call neobundle#untap()
endif
" }}}

" check plugin installation {{{
NeoBundleCheck
if !has('vim_starting')
  call neobundle#call_hook('on_source')
endif
" }}}

" }}}
