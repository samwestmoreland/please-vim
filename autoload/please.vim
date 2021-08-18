
""
" @public
" Execute a please command
" Meant to be invoked by the |:Please| command
""
function! please#Run(arguments, ...) abort
"	echo 'Invoking please with arguments "%s"', string(a:arguments))
	call s:Autowrite()
	call l:syscall.CallForeground(1, 0)
endfunction

" Write files before calling Please
function! s:Autowrite() abort
  if &autowrite || &autowriteall
    wall
  endif
endfunction
