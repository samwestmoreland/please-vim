" Some functions

let s:PLUGIN = maktaba#plugin#Get('please-vim')
let g:please_vim_logger = maktaba#log#Logger('PLEASEVIMFILE')

""
" @public
" Execute a please command
" Meant to be invoked by the |:Please| command
""
function! please#Run(arguments, ...) abort
	call s:PLUGIN.logger.Info(
				\ 'Invoking please with arguments "%s"',
				\ string(a:arguments))
	call s:Autowrite()
	let l:executable = ['please']
	call s:PLUGIN.logger.Debug('type of l:executable is "%s"', type(l:executable))
	call s:PLUGIN.logger.Debug('type of a:arguments is "%s"', type(a:arguments))
	echo 'type of l:executable is ' type(l:executable)
	echo 'type of a:arguments is ' type(a:arguments)
	echo 'adding the two lists: ' l:executable + split(a:arguments)
	let l:syscall = maktaba#syscall#Create(l:executable + split(a:arguments))
	call l:syscall.CallForeground(1, 0)
endfunction

function! please#Clean(arguments, ...) abort
	call s:PLUGIN.logger.Info(
				\ 'Doing a please clean with arguments "%s"',
				\ string(a:arguments))
	let l:executable = ['please', 'clean']
	let l:syscall = maktaba#syscall#Create(l:executable + a:arguments)
	call l:syscall.Call(1, 0)
endfunction

" please build the target under the cursor
function! please#BuildThis() abort
	let l:wordUnderCursor = expand('<cword>')
	let l:currentFile = expand('<sfile>')
	let l:buildTarget = l:currentFile . l:wordUnderCursor

	echo 'Build target: ' l:buildTarget

	call s:PLUGIN.logger.Info('Got build target "%s"',
				\ string(l:buildTarget))

	call please#Run(l:buildTarget)
endfunction

" Write files before calling Please
function! s:Autowrite() abort
  if &autowrite || &autowriteall
    wall
  endif
endfunction
