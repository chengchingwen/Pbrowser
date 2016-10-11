#!/bin/sh

##############         download_box        ##############
### list link to download: input <url>
list=`lynx -dump $1 -listonly | grep "[0-9]"`
exec 3>&1
result=`$textdialog --menu "Download:"  0 0 100 ${list} 2>&1 1>&3`
exitcode=$?
exec 3>&-
if [ $exitcode -eq 0 ];then
    local link=`echo $list | xargs -n2 echo | grep "^${result} " | cut -d' ' -f 2`
    echo $link
    #curl -s $link > "./download/${time}.download"
    wget -P "${download}"  "${link}"
fi
return 103 #back
