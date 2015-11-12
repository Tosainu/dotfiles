" basic settings {{{
" skip when vim-tiny or vim-small
if 0 | endif

" vimrc augroup
augroup MyVimrc
  autocmd!
augroup END

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
set clipboard&
if has('mac')
  set clipboard^=unnamed
else
  set clipboard^=unnamedplus
endif

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

" viminfo
set viminfo+=n~/.vim/viminfo

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
autocmd MyVimrc FileType cpp call s:cpp_config()
function! s:cpp_config()
  setlocal cindent
  setlocal cinoptions& cinoptions+=g0,m1,j1,(0,ws,Ws,N-s
  " // indent sample
  "
  " class foo {
  " public:
  "   void hello() const {
  "     std::cout << "Hello!" << std::endl;
  "   }
  " };
  "
  " auto main() -> int {
  "   std::array<foo, 5> a{};
  "   std::for_each(a.begin(), a.end(), [](const auto& i) {
  "     i.hello();
  "   });
  " }

  " include path
  let s:incpath = [
        \   '/usr/include/boost',
        \   '/usr/include/c++/v1',
        \   expand('~/.ghq/github.com/bolero-MURAKAMI/Sprout'),
        \ ]

  execute 'setlocal path+=' . join(s:incpath, ',')

  " expand namespace
  " http://rhysd.hatenablog.com/entry/2013/12/10/233201#namespace
  inoremap <buffer><expr>; <SID>expand_namespace()
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

  nnoremap <silent> <Space>p :<C-u>PrevimOpen<CR>

endfunction

" binary files
autocmd MyVimrc BufReadPost * if &binary | call s:binary_config() | endif
function! s:binary_config()
  silent %!xxd -g 1
  setlocal ft=xxd

  autocmd MyVimrc BufWritePre * %!xxd -r
  autocmd MyVimrc BufWritePost * silent %!xxd -g 1
  autocmd MyVimrc BufWritePost * setlocal nomodified
endfunction

" quickfix
autocmd MyVimrc FileType qf   nnoremap <buffer><silent> q :<C-u>cclose<CR>
" help
autocmd MyVimrc FileType help nnoremap <buffer><silent> q :<C-u>q<CR>
" }}}

" neobundle {{{
if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
endif

call neobundle#begin()

if neobundle#load_cache()
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
  NeoBundle 'osyo-manga/vim-watchdogs',         {'depends': ['thinca/vim-quickrun', 'osyo-manga/shabadou.vim']}

  NeoBundle 'Yggdroot/indentLine'
  NeoBundle 'haya14busa/incsearch.vim'
  NeoBundle 'jceb/vim-hier'
  NeoBundle 'rhysd/clever-f.vim'
  NeoBundle 't9md/vim-textmanip'
  NeoBundle 'tomtom/tcomment_vim'
  NeoBundle 'tpope/vim-surround'
  NeoBundle 'vim-jp/vimdoc-ja'

  NeoBundleLazy 'AndrewRadev/switch.vim'
  NeoBundleLazy 'Shougo/vimfiler.vim',          {'depends': 'Shougo/unite.vim'}
  NeoBundleLazy 'kannokanno/previm',            {'depends': 'tyru/open-browser.vim'}
  NeoBundleLazy 'mattn/emmet-vim'
  NeoBundleLazy 'osyo-manga/vim-over'

  NeoBundleLazy 'Shougo/neocomplete.vim',       {'depends': ['Shougo/neoinclude.vim', 'Shougo/neosnippet.vim']}
  NeoBundleLazy 'Shougo/neosnippet.vim'
  NeoBundleLazy 'eagletmt/neco-ghc'
  NeoBundleLazy 'osyo-manga/vim-marching'

  " operator
  NeoBundleLazy 'kana/vim-operator-replace',    {'depends': 'kana/vim-operator-user'}
  NeoBundleLazy 'rhysd/vim-clang-format',       {'depends': 'kana/vim-operator-user'}

  " colorscheme
  NeoBundle 'Tosainu/last256'

  " unite
  NeoBundleLazy 'Shougo/unite.vim'
  NeoBundleLazy 'Shougo/neomru.vim',            {'depends': 'Shougo/unite.vim'}
  NeoBundleLazy 'lambdalisue/vim-gista',        {'depends': ['Shougo/unite.vim', 'tyru/open-browser.vim']}
  NeoBundleLazy 'rhysd/unite-codic.vim',        {'depends': ['Shougo/unite.vim', 'koron/codic-vim']}
  NeoBundleLazy 'ujihisa/unite-colorscheme',    {'depends': 'Shougo/unite.vim'}
  NeoBundleLazy 'ujihisa/unite-haskellimport',  {'depends': 'Shougo/unite.vim'}

  " languages
  NeoBundle 'ap/vim-css-color'
  NeoBundle 'dag/vim2hs'
  NeoBundle 'hail2u/vim-css3-syntax'
  NeoBundle 'othree/html5.vim'
  NeoBundle 'rust-lang/rust.vim'
  NeoBundle 'slim-template/vim-slim'
  NeoBundle 'vim-jp/vim-cpp'

  NeoBundleSaveCache
endif

" vim-gitgutter {{{
if neobundle#tap('vim-gitgutter')
  let g:gitgutter_max_signs = 1000
  let g:gitgutter_sign_added = '✚'
  let g:gitgutter_sign_modified = '➜'
  let g:gitgutter_sign_modified_removed = '➜'
  let g:gitgutter_sign_removed = '✘'

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
        \       ['fugitive', 'readonly', 'filename', 'modified'],
        \     ],
        \     'right': [
        \       ['lineinfo'],
        \       ['percent'],
        \       ['fileformat', 'fileencoding', 'filetype'],
        \       ['gitgutter'],
        \     ]
        \   },
        \   'component_function': {
        \     'filename':   'LightlineFilename',
        \     'fugitive':   'LightlineFugitive',
        \     'gitgutter':  'LightlineGitGutter',
        \     'modified':   'LightlineModified',
        \     'readonly':   'LightlineReadonly',
        \   },
        \   'separator':    {'left': "\ue0b0", 'right': "\ue0b2"},
        \   'subseparator': {'left': "\ue0b1", 'right': "\ue0b3"},
        \   'tabline':      {'left': [['tabs']], 'right': []},
        \ }

  function! LightlineReadonly()
    return &ft !~? 'help' && &ro ? "\ue0a2" : ''
  endfunction

  function! LightlineFilename()
    return  &ft == 'unite'    ? unite#get_status_string() :
          \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
          \ expand('%:t') != '' ? expand('%:t') : '[No Name]'
  endfunction

  function! LightlineModified()
    return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
  endfunction

  function! LightlineFugitive()
    return strlen(fugitive#head()) ? "\ue0a0 " . fugitive#head() : ''
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
        \   'cmdopt':     '-Wall -Wextra -std=c++14 -lboost_system -pthread',
        \ }

  let g:quickrun_config.markdown = {
        \   'outputter':  'null',
        \ }

  nnoremap <silent> <Space>r :<C-u>QuickRun<CR>
  nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "<C-c>"

  call neobundle#untap()
endif
" }}}

" vim-watchdogs {{{
if neobundle#tap('vim-watchdogs')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:watchdogs_check_BufWritePost_enables = {
          \   'c':          1,
          \   'haskell':    1,
          \   'javascript': 1,
          \   'lua':        1,
          \   'ruby':       1,
          \   'sass':       1,
          \   'scss':       1,
          \ }

    let g:watchdogs_check_BufWritePost_enable_on_wq = 0

    call watchdogs#setup(g:quickrun_config)
  endfunction

  call neobundle#untap()
endif
" }}}

" incsearch.vim {{{
if neobundle#tap('incsearch.vim')
  let g:incsearch#auto_nohlsearch = 1

  map /  <Plug>(incsearch-forward)
  map ?  <Plug>(incsearch-backward)

  map n  <Plug>(incsearch-nohl-n)
  map N  <Plug>(incsearch-nohl-N)
  map *  <Plug>(incsearch-nohl-*)
  map #  <Plug>(incsearch-nohl-#)
  map g* <Plug>(incsearch-nohl-g*)
  map g# <Plug>(incsearch-nohl-g#)
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
if neobundle#tap('vimfiler.vim')
  call neobundle#config({
        \   'autoload': {
        \     'commands': [
        \       {'name': 'VimFiler', 'complete': 'customlist,vimfiler#complete'},
        \       'VimFilerExplorer', 'Edit', 'Read', 'Source', 'Write'
        \     ],
        \     'mappings': '<Plug>',
        \     'explorer': 1,
        \   }
        \ })

  function! neobundle#tapped.hooks.on_source(bundle)
    let g:vimfiler_as_default_explorer = 1
    let g:vimfiler_safe_mode_by_default = 0
    " open in new tab
    let g:vimfiler_edit_action = 'tabopen'
    let g:vimfiler_ignore_pattern = ['^\.git$']
  endfunction

  " open Vimfiler
  nmap <silent> <Leader>vf :<C-u>VimFilerExplorer -winwidth=25<CR>

  call neobundle#untap()
endif
" }}}

" previm {{{
if neobundle#tap('previm')
  call neobundle#config({
        \   'autoload': {'filetypes': 'markdown'}
        \ })

  let g:previm_enable_realtime = 1

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

  call neobundle#untap()
endif
" }}}

" neosnippet.vim {{{
if neobundle#tap('neosnippet.vim')
  call neobundle#config({
        \   'autoload': {'filetypes': 'neosnippet'}
        \ })

  let g:neosnippet#disable_runtime_snippets = {
        \   '_': 1,
        \ }
  let g:neosnippet#snippets_directory = '~/.vim/snippets'

  " for snippet_complete marker
  if has('conceal')
    set conceallevel=2 concealcursor=niv
  endif

  call neobundle#untap()
endif
" }}}

" neco-ghc {{{
if neobundle#tap('neco-ghc')
  call neobundle#config({
        \   'autoload': {'filetypes': 'haskell'},
        \   'external_commands': 'ghc-mod',
        \ })

  call neobundle#untap()
endif
" }}}

" vim-marching {{{
if neobundle#tap('vim-marching')
  call neobundle#config({
        \   'autoload': {'filetypes': 'cpp'},
        \   'external_commands': 'clang',
        \ })

  function! neobundle#tapped.hooks.on_source(bundle)
    let g:marching_wait_time = 1.0
    let g:marching#clang_command#options = {
          \   'cpp':  '-std=c++14',
          \ }

    if neobundle#is_installed('neocomplete.vim')
      let g:marching_enable_neocomplete = 1
    endif
  endfunction

  call neobundle#untap()
endif
" }}}

" vim-operator-replace
if neobundle#tap('vim-operator-replace')
  call neobundle#config({
        \   'autoload': {'mappings': '<Plug>(operator-replace)'},
        \ })

  nmap R  <Plug>(operator-replace)
endif

" vim-clang-format {{{
if neobundle#tap('vim-clang-format')
  call neobundle#config({
        \   'autoload': {
        \     'commands': ['ClangFormat', 'ClangFormatEchoFormattedCode'],
        \     'filetypes': ['c', 'cpp'],
        \     'mappings': '<Plug>(operator-clang-format)',
        \   },
        \   'external_commands': 'clang-format',
        \ })

  let g:clang_format#style_options = {
        \   'AccessModifierOffset': -2,
        \   'AllowShortFunctionsOnASingleLine': 'Empty',
        \   'ColumnLimit':          128,
        \   'SpacesBeforeTrailingComments': 1,
        \   'Standard':             'Cpp11',
        \ }

  map <buffer><Leader>cf <Plug>(operator-clang-format)

  call neobundle#untap()
endif
" }}}

" unite.vim {{{
if neobundle#tap('unite.vim')
  call neobundle#config({
        \   'autoload': {
        \     'commands': [
        \       {'name': 'Unite', 'complete': 'customlist,unite#complete_source'},
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

" vim-gista {{{
if neobundle#tap('vim-gista')
  call neobundle#config({
        \   'autoload': {
        \     'commands': ['Gista'],
        \     'mappings': '<Plug>',
        \     'unite_sources': 'gista',
        \   }
        \ })

  let g:gista#github_user = 'Tosainu'

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

" unite-haskellimport {{{
if neobundle#tap('unite-haskellimport')
  call neobundle#config({
        \   'autoload': {'filetypes': ['haskell']},
        \   'external_commands': 'hoogle',
        \ })

  let g:necoghc_enable_detailed_browse = 1

  call neobundle#untap()
endif
" }}}

call neobundle#end()
filetype plugin indent on

if !has('vim_starting')
  call neobundle#call_hook('on_source')
endif
" }}}

" colorscheme {{{
syntax enable
if !has('gui_running')
  " color mode
  set t_Co=256

  try
    colorscheme last256
  catch
    colorscheme default
  endtry
endif
" }}}
