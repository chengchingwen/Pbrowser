#!/bin/sh -x

export LANG=zh_TW.UTF-8
name='P_browser'
terms=`cat ./text/terms.txt`
apology=`cat ./text/apology.txt`
help=`cat ./text/help.txt`
error=`cat ./text/error.txt`
homepage='google.com'
tempdir="./tmp"
time=`date +'%s'`
textdialog="dialog --title ${name} --scrollbar"
pagedialog="dialog  --title ${name} --scrollbar --extra-button --extra-label Last_page --help-button --help-label Next_page"
cache="./history/cache.${time}"
download='./download'
bookmark='./text/bookmark'
if [ ! -d "./history" ]; then
    # Control will enter here if $DIRECTORY doesn't exist.
    mkdir "history"
fi
mkdir "${cache}"
mktemp "${cache}/current.page" >> log
current=$homepage
page=0
nonext=0
#####################      page_functions      #######################
#return code:   1 = exit
#             101 = show current page
#             103 = back to input
### go to a page: input <url> 
go_page (){
    . ./script/page.sh $1
    return $?
}
### get the source: input <url>
source_box () {
    . ./script/source.sh $1
    return $?
}
### list all link: input <url>
link_box () {
    . ./script/link.sh $1
    return $?
}
### list link to download: input <url>
download_box () {
    . ./script/download.sh $1
    return $?
}
### show bookmarks: no-input 
bookmark_box () {
    . ./script/bookmark.sh
    return $?
}
### show help message: no-input
help_box () {
    $textdialog --msgbox "${help}" 15 50
    #input_flow
    return 103
}
error_box () {
    $textdialog --msgbox "${error}" 10 50
    return 103
}
### do the shell command: input <cmd>
shell_box () {
    . ./script/shell.sh $*
    return $?
}
### control the flow: no-input
input_flow () {
    retcode=1
    exec 3>&1
    result=`dialog --title "P browser" --inputbox "$current"  10  50 2>&1 1>&3`
    exitcode=$?
    exec 3>&-
    if [ $exitcode -eq 0 ];then
	curl -s --head "${result}" | head -n1 | grep "HTTP/1\.[01] [23].."
	if [ $? -eq 0 ];then
	    current=${result}
	    retcode=101
	else
	    echo $result
	    case $result in
		"/D" | "/download")
		    download_box $current
		    retcode=$?
		    ;;
		"/L" | "/link")
		    link_box $current
		    retcode=$?
		    ;;
		"/S" | "/source")
		    source_box $current
		    retcode=$?
		    ;;
		"/B" | "/bookmark")
		    bookmark_box
		    retcode=$?
		    ;;
		"/H" | "/help")
		    help_box
		    retcode=$?
		    ;;
		!*)
		    shell_box $result
		    retcode=$?
		    ;;
		"")
		    go_page ${current}
		    retcode=$?
		    ;;
		*)
		    error_box
		    retcode=$?
		    ;;
	    esac
	fi
    fi
    return $retcode
}


######################      get term of use      #######################
dialog --title "terms and conditions of Use"  --yesno "${terms}" 25  100 
ans=$?
status=1
####################       Yes and go down       ######################
if [ $ans -eq 0 ];then
    #go_page ${current}
    status=101
    #dialog --title "P browser" --msgbox "${homepage}" 25 100  --scrollbar #--title "P browser" --inputbox "${current}" 25 100 2> tmp
    #input_flow 
else 
    dialog --title "Apology"  --msgbox "${apology}" 10 50
    status=1
fi

while [ $status -ne 1 ];do
#    go_page ${current}
#    if [ $status -eq 101 ];then
#	input_flow
#	status=$?
    #   fi
    case $status in
	103)
	    input_flow
	    status=$?
	    ;;
	101)
	    go_page ${current}
	    status=$?
	    ;;
    esac		
done
$textdialog --msgbox "goodbye~" 10 50
#rm -r "${cache}"
#########################       end       ###############################


