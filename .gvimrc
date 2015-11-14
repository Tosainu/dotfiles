colorscheme last256

" disable mouse
set mouse=

" window size
set columns=140
set lines=38

" hide menu bar & tool bar
set guioptions-=m
set guioptions-=M
set guioptions-=T

" disable visualbell
set t_vb=

" directx
if has('directx')
  set renderoptions=type:directx
endif

" font
if has('win32') || has('win64')
  set guifont=Source_Code_Pro_Medium:h11:cANSI
else
  set guifont=Source\ Code\ Pro\ Medium\ 11
endif

" ime
if has('multi_byte_ime')
  set iminsert=0 imsearch=0
  inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
endif
