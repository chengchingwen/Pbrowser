#!/bin/sh

##########     shell box       ###############
### do the shell command: input <cmd>

result=$*
result=${result#!*}
mktemp "${tempdir}/${time}.tmp" 
tmpfile="${tempdir}/${time}.tmp"
eval $result 2>${tmpfile} >${tmpfile}
$textdialog --textbox "${tmpfile}" 25 100  
return 101

