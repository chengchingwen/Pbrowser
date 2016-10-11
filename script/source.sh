#!/bin/sh

#############      source_box      ############
### get the source: input <url>

mktemp "${tempdir}/${time}.tmp" 
tmpfile="${tempdir}/${time}.tmp"
curl -s $1 > ${tmpfile} 
$textdialog --textbox ${tmpfile} 25 125
return 103 #back
