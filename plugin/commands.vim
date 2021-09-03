" This plugin allows you to execute please commands from vim

let [s:plugin, s:enter] = maktaba#plugin#Enter(expand('<sfile>:p'))
if !s:enter
	finish
endif

" Invoke please with a command, e.g. |:Please test|
command -nargs=* Please call please#Run([<f-args>])

" Do 'please clean -f'
command -nargs=* PleaseClean call please#Clean([<f-args>])

" Build the target under the cursor
command -nargs=0 PleaseBuildThis call please#BuildThis()
