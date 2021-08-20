" Some functions

let s:PLUGIN = maktaba#plugin#Get('please-vim')

""
" @public
" Execute a please command
" Meant to be invoked by the |:Please| command
""
function! please#Run(arguments) abort
	call s:PLUGIN.logger.Info(
				\ 'Invoking please with arguments "%s"',
				\ string(a:arguments))
	call s:Autowrite()
	let l:executable = ['please']
	call s:PLUGIN.logger.Debug('type of l:executable is "%s"', type(l:executable))
	call s:PLUGIN.logger.Debug('type of a:arguments is "%s"', type(a:arguments))
	let l:syscall = maktaba#syscall#Create(l:executable + a:arguments)
	call l:syscall.CallForeground(1, 0)
endfunction

function! please#Clean(arguments) abort
	call s:PLUGIN.logger.Info(
				\ 'Doing a please clean with arguments "%s"',
				\ string(a:arguments))
	let l:executable = ['please', 'clean']
	let l:syscall = maktaba#syscall#Create(l:executable + a:arguments)
	call l:syscall.Call(1, 0)
endfunction

" Write files before calling Please
function! s:Autowrite() abort
  if &autowrite || &autowriteall
    wall
  endif
endfunction
