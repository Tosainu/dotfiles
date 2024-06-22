if exists("b:did_ftplugin")
    finish
endif

let b:did_ftplugin = 1

let s:cpoptions_save = &cpoptions
set cpoptions&vim

setlocal commentstring=#%s

let &cpoptions = s:cpoptions_save
unlet s:cpoptions_save
