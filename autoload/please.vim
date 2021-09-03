" Some functions

let s:PLUGIN = maktaba#plugin#Get('please-vim')
let g:please_vim_logger = maktaba#log#Logger('PLEASEVIMFILE')

let s:repo_root = ''

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
	let executable = ['please']
	call s:PLUGIN.logger.Debug('type of executable is "%s"', type(executable))
	call s:PLUGIN.logger.Debug('type of a:arguments is "%s"', type(a:arguments))
	let l:syscall = maktaba#syscall#Create(executable + a:arguments)
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
	let wordUnderCursor = expand('<cword>')

	" Construct build label
	let repoRootPath = split(please#FindRepoRoot(), '/')
	let currentFilePath = split(expand('%:p:h'), '/')
	let depth = len(currentFilePath) - len(repoRootPath)
	let buildLabel = '//' . join(currentFilePath[-depth:], '/') . ':' . wordUnderCursor

	call please#Run(['build', buildLabel])
endfunction

" The idea here is to walk backwards up the directory tree until
" we find a directory with a .plzconfig
function! please#FindRepoRoot() abort
	if s:repo_root !=# ''
		return s:repo_root
	endif

	let currentDir = expand('%:p:h')
	while 1
		if !isdirectory(currentDir)
			echo currentDir " isn\'t a directory. error!"
			return
		endif

		" Now just take the current dir, whack .plzconfig on the end
		" and ask if it exists
		if filereadable(currentDir . '/.plzconfig')
			let s:repo_root = currentDir
			return s:repo_root
		endif

		" Go up a directory
		" Note this stuff probably only works on unix-like systems
		let dirs = split(currentDir, '/')
		let ndirs = len(dirs) - 2
		let currentDir = '/' . join(dirs[0:ndirs], '/')
	endwhile

endfunction

" Write files before calling Please
function! s:Autowrite() abort
  if &autowrite || &autowriteall
    wall
  endif
endfunction
