#!/bin/sh

###########     bookmark_box      ############# 
### show bookmarks: no-input 

list=`cat ${bookmark}`
exec 3>&1
result=`$textdialog --menu "Bookmarks:"  25 100 100 ${list} 2>&1 1>&3`
exitcode=$?
exec 3>&-
if [ $exitcode -eq 0 ];then
    if [ $result -eq 1 ];then
	#add bookmark
	local i=`cat ${bookmark} | wc -l`
	i=$(($i + 1))
	echo "${i} ${current}" >> ${bookmark}
    elif [ $result -eq 2 ];then
	#delete bokmark
	dlist=`echo $list | xargs -n2 echo | awk 'NR>2 {print $1 " " $2}'`
	exec 3>&1
	result=`$textdialog --menu "Delete_Bookmarks:"  25 100 100 ${dlist} 2>&1 1>&3`
	exitcode=$?
	exec 3>&-
	if [ $exitcode -eq 0 ];then
	    echo $list | xargs -n2 echo | awk -v re="${result}" '$1==re {bit=1} $1!=re {print $1-bit " " $2}' > ${bookmark}
	fi
	bookmark_box
    else
	link=`cat ${bookmark} | grep "^${result} " | cut -d ' ' -f 2`
	current=${link}
	return 101 #go
    fi
fi
return 103 #
