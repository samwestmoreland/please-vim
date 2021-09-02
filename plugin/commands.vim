" This plugin allows you to execute please commands from vim

let [s:plugin, s:enter] = maktaba#plugin#Enter(expand('<sfile>:p'))
if !s:enter
	finish
endif

command -nargs=* Please call please#Run([<f-args>])
command -nargs=* PleaseClean call please#Clean([<f-args>])
command -nargs=0 PleaseBuildThis call please#BuildThis()
