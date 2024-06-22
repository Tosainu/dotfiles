if exists("b:did_indent")
  finish
endif

let b:did_indent = 1

setlocal indentexpr=GetEarthfileIndent()
setlocal indentkeys=!^F,o,O,<:>
setlocal nosmartindent autoindent

let b:undo_indent = "setl inde< indk< si<"

if exists("*GetEarthfileIndent")
  finish
endif

function GetEarthfileIndent() abort
  let nonblank = prevnonblank(v:lnum)
  if nonblank == 0
    return 0
  endif

  let line = getline(v:lnum)
  if line =~ '^\s*[a-z0-9\-.]\+\:'
    return 0
  endif

  let line = getline(nonblank)
  if line =~ '^\s*[a-z0-9\-.]\+\:'
    return shiftwidth()
  else
    return indent(nonblank)
  endif
endfunction
