" Some functions

let s:PLUGIN = maktaba#plugin#Get('Please')

""
" @public
" Execute a please command
" Meant to be invoked by the |:Please| command
""
function! please#Run(arguments, ...) abort
	call s:PLUGIN.logger.info(
				\ 'Invoking please with arguments "%s"',
				\ string(a:arguments))
	call s:Autowrite()
	let l:syscall = maktaba#syscall#Create([l:executable] + a:arguments)
	call l:syscall.CallForeground(1, 0)
endfunction

" Write files before calling Please
function! s:Autowrite() abort
  if &autowrite || &autowriteall
    wall
  endif
endfunction
