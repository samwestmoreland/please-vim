" Some functions

let s:repo_root = ''

if !exists('s:terminal_disabled')
	let s:terminal_disabled = 0
endif

function! s:Call(arguments, ...) abort
	if !s:terminal_disabled && has('nvim')
		let cmd = 'noautocmd new | terminal '
	elseif !s:terminal_disabled && has('terminal')
		let cmd = 'terminal '
	else
		let cmd = '!'
	endif
	execute cmd . a:arguments
endfunction

" Take a list of strings and concatenate them for execution
function! s:CreateCommand(l) abort
	return join(a:l[:], ' ')
endfunction

""
" @public
" Execute a please command
" Meant to be invoked by the |:Please| command
""
function! please#Run(arguments, ...) abort
	call s:Autowrite()
	let executable = ['please']
	let syscall = s:CreateCommand(executable + a:arguments)
	call s:Call(syscall)
	"call l:syscall.CallForeground(1, 0)
endfunction

function! please#Clean(arguments, ...) abort
	echo 'Doing a please clean with arguments ' string(a:arguments)
	let l:executable = ['please', 'clean']
"	let l:syscall = maktaba#syscall#Create(l:executable + a:arguments)
"	call l:syscall.Call(1, 0)
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
