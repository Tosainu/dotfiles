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

" require
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc', {
      \   'build': {
      \     'unix': 'make -f make_unix.mak',
      \     'mac' : 'make -f make_mac.mak'
      \   }
      \ }

" tools
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'scrooloose/syntastic'
NeoBundle 't9md/vim-foldtext'
NeoBundle 't9md/vim-textmanip'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tomtom/tcomment_vim'
NeoBundleLazy 'Shougo/vinarise.vim', {
      \   'autoload': {'commands': ['Vinarise']}
      \ }
NeoBundleLazy 'rhysd/vim-clang-format', {
      \   'autoload': {
      \     'commands': ['ClangFormat', 'ClangFormatEchoFormattedCode'],
      \     'filetypes': ['c', 'cpp']
      \   }
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
NeoBundleLazy 'rhysd/unite-codic.vim', {
      \   'depends': ['Shougo/unite.vim', 'koron/codic-vim'],
      \   'autoload': {'unite_sources': ['codic']}
      \ }

" quickrun
NeoBundleLazy 'thinca/vim-quickrun', {
      \   'autoload': {
      \     'commands': ['QuickRun'],
      \     'mappings': ['<Plug>(quickrun)'],
      \   }
      \ }
NeoBundleLazy 'superbrothers/vim-quickrun-markdown-gfm', {
      \   'depends': ['mattn/webapi-vim', 'thinca/vim-quickrun', 'tyru/open-browser.vim'],
      \   'autoload': {
      \     'commands': ['QuickRun'],
      \     'mappings': ['<Plug>(quickrun'],
      \     'filetypes': ['markdown']
      \   }
      \ }

" Completetion
NeoBundleLazy 'Shougo/neocomplete.vim', {
      \   'autoload': {'insert' : '1'}
      \ }
NeoBundleLazy "Shougo/neosnippet.vim", {
      \   'depends': 'Shougo/neocomplete.vim',
      \   'autoload': {'insert' : '1'}
      \ }
NeoBundleLazy 'osyo-manga/vim-marching', {
      \   'depends': ['Shougo/vimproc', 'osyo-manga/vim-reunions'],
      \   'autoload': {'filetypes': 'cpp'}
      \ }
NeoBundleLazy 'mattn/emmet-vim', {
      \   'autoload': {'filetypes': ['html', 'xhtml', 'css']}
      \ }
NeoBundleLazy 'mattn/jscomplete-vim', {
      \   'autoload': {'filetypes': 'javascript'}
      \ }

" Scheme
NeoBundle 'sk1418/last256', {
      \   'rev':  '48fb3d10c42c7a07cf6683c3e90fe9d9c8bd3131'
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
NeoBundleLazy 'dag/vim2hs', {
      \   'autoload': {'filetypes': 'haskell'}
      \ }
NeoBundleLazy 'othree/html5.vim', {
      \   'autoload': {'filetypes': 'html'}
      \ }
NeoBundleLazy 'hail2u/vim-css3-syntax', {
      \   'autoload': {'filetypes': 'css'}
      \ }
NeoBundleLazy 'ap/vim-css-color', {
      \   'autoload': {'filetypes': ['css', 'html']}
      \ }
NeoBundleLazy 'tpope/vim-markdown', {
      \   'autoload': {'filetypes': 'markdown'}
      \ }
NeoBundleLazy 'sudar/vim-arduino-syntax', {
      \   'autoload': {'filename_patterns': '.*\.ino'}
      \ }
NeoBundleLazy 'nginx.vim', {
      \   'autoload': {'filetypes': 'nginx'}
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
set cursorline number ruler
set matchpairs+=<:>
let loaded_matchparen = 1
set laststatus=2 showtabline=2
set scrolloff=4
set title
set ttyfast
set vb t_vb=
set switchbuf=useopen

" Scheme
syntax enable
if $TERM == 'linux'
  colorscheme slate
  set background=dark
else
  set t_Co=256
  colorscheme last256
endif

" Search
set ignorecase smartcase incsearch hlsearch wrapscan

" Indent
set autoindent cindent
set cinoptions& cinoptions+=g0,m1
set expandtab smarttab
set tabstop=2 shiftwidth=2 backspace=2

" disable auto comment.
autocmd MyVimrc FileType * setlocal formatoptions-=ro

" Commandline
set wildmenu wildignorecase wildmode=list:full

" History
set history=100

" timeout
set timeoutlen=500
set updatetime=200

" show tabs
set list listchars=tab:>-,trail:-,eol:¬,nbsp:%

" tempfiles
set nobackup

if ! isdirectory($HOME.'/.vim/swap')
  call mkdir($HOME.'/.vim/swap', 'p')
endif
set directory=~/.vim/swap

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

let g:markdown_fenced_languages = [
      \   'c',
      \   'cpp',
      \   'css',
      \   'html',
      \   'javascript',
      \   'ruby',
      \   'vim',
      \ ]
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
nnoremap <S-Up>    <C-W>-
nnoremap <S-Down>  <C-W>+
nnoremap <S-Left>  <C-W><
nnoremap <S-Right> <C-W>>

" off highlight <ESC> * 2
nmap <silent> <Esc><Esc> :<C-u>nohlsearch<CR><Esc>

" fcitx
autocmd MyVimrc InsertLeave * call system('fcitx-remote -c')
"}}}

" for C++ (http://rhysd.hatenablog.com/entry/2013/12/10/233201) {{{
autocmd MyVimrc FileType cpp setlocal path+=/usr/include/c++/v1,/usr/include/boost,/usr/include/qt
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

" Unite.vim {{{
call unite#custom_default_action('file', 'tabopen')

" close <ESC> * 2
autocmd MyVimrc FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
autocmd MyVimrc FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>

" http://deris.hatenablog.jp/entry/2013/05/02/192415
nnoremap [unite]    <Nop>
nmap     <Space>u [unite]
nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
nnoremap <silent> [unite]h :<C-u>Unite neomru/file<CR>
nnoremap <silent> [unite]t :<C-u>Unite tab<CR>
nnoremap <silent> [unite]b :<C-u>Unite bookmark<CR>
nnoremap <silent> [unite]a :<C-u>UniteBookmarkAdd<CR>
nnoremap <silent> [unite]c :<C-u>Unite codic<CR>
"}}

" vimfiler {{{
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_safe_mode_by_default = 0
"}}}

" quickrun {{{
let g:quickrun_config = {
      \   '_': {
      \     'outputter/buffer/split': ':botright',
      \     'outputter/buffer/into':  1,
      \     'outputter/buffer/close_on_empty': 1
      \   },
      \   'cpp': {
      \     'command': 'clang++',
      \     'cmdopt': '-std=c++11 -stdlib=libc++ -lc++abi -Wall -Wextra -lboost_system -lpthread'
      \   },
      \   'markdown': {
      \     'type': 'markdown/gfm',
      \     'outputter': 'browser'
      \   }
      \ }

" run <Space>r
nmap <Space>r <Plug>(quickrun)
"}}}

" vim-gitgutter {{{
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
"}}}

" lightline.vim {{{
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
  if ! exists('*GitGutterGetHunkSummary')
        \ || ! get(g:, 'gitgutter_enabled', 0)
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
"}}}

" syntastic {{{
let g:syntastic_mode_map = {
      \   'mode': 'active',
      \   'passive_filetypes': ['cpp', 'tex']
      \ }
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_signs = 0
let g:syntastic_c_compiler    = 'clang'
let g:syntastic_cpp_compiler  = 'clang++'
let g:syntastic_cpp_compiler_options = '-std=c++11 -stdlib=libc++ -lc++abi'
let g:syntastic_javascript_jshint_conf = '~/.jshintrc'
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

" jscomplete-vim {{{
let g:jscomplete_use = ['dom']
"}}}

" marching {{{
let g:marching_clang_command = '/usr/bin/clang'
let g:marching_clang_command_option = '-std=c++11 -stdlib=libc++ -lc++abi'
let g:marching_enable_neocomplete = 1
"}}}

" Neocomplete {{{
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_auto_delimiter = 1
let g:neocomplete#sources#syntax#min_keyword_length = 2
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

inoremap <expr><BS>     neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-g>    neocomplete#undo_completion()
inoremap <expr><TAB>    pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"

" Enable heavy omni completion
let g:neocomplete#force_overwrite_completefunc = 1
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
"}}}

" neosnippet {{{
let g:neosnippet#disable_runtime_snippets = {
      \   "_": 1,
      \ }
let g:neosnippet#snippets_directory='~/.vim/snippets'

imap <expr><CR> !pumvisible() ? "\<CR>" :
      \ neosnippet#expandable() ? "\<Plug>(neosnippet_expand)" :
      \ neocomplete#close_popup()
imap <expr><TAB> !pumvisible() ?
      \ neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)" : "\<Tab>"
      \ : "\<C-n>"
smap <expr><TAB> neosnippet#jumpable() ?
      \ "\<Plug>(neosnippet_jump)"
      \ : "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif
" }}}

" clang-format {{{
let g:clang_format#style_options = {
      \   'AccessModifierOffset' : -2,
      \   'ColumnLimit' : 128,
      \   'Standard' : 'C++11',
      \ }
" }}}
