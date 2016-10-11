#!/bin/sh
###################       go page       #################
### go to a page: input <url> 

current=$1
url=`cat ${cache}/${page}.page | head -n1`
if [ $current = $url ];then
    $pagedialog --textbox "${cache}/current.page" 25 125
    next=$?
    nonext=0
elif [ $next -ne 0 ];then
    cat "${cache}/${page}.page" | tail -n +2 > "${cache}/current.page"
    $pagedialog --textbox "${cache}/current.page" 25 125
    next=$?
    current=$url
    nonext=0
else
    page=$(($page + 1))    
    w3m $current -dump > "${cache}/current.page"
    url=$current
    echo $url > "${cache}/${page}.page"
    cat "${cache}/current.page" >> "${cache}/${page}.page"
    $pagedialog --textbox "${cache}/current.page" 25 125
    next=$?
    nonext=1
fi
case $next in
    2) #Next
	if [ -e "${cache}/$(($page + 1)).page"  ] && [  $nonext -eq 0 ]  ;then
	    page=$(($page + 1))
	    go_page ${current}
	else
	    go_page ${current}
	fi
	;;
    3) #Last
	if [ $(($page -1)) -eq 0 ];then
	    go_page ${current}
	else
	    page=$(($page -1))
	    go_page ${current}
	fi
	;;
esac
#input_flow
next=0
return 103 #back

