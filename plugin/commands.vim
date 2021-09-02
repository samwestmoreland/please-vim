" This plugin allows you to execute please commands from vim
command -nargs=* Please call please#Run([<f-args>])
command -nargs=* PleaseClean call please#Clean([<f-args>])
command -nargs=0 PleaseBuildThis call please#BuildThis()
