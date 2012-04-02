#!/bin/bash
# Read email from stdin, write SL job URL to stdout.
while read line; do
	echo "$line" | grep -q 'URL: http://'
	if [ $? -eq 0 ];then
		ugly=$(echo "$line" | sed 's/URL: //') 
		php -n /home/caldari/sl.php $ugly
		exit 0
	fi
done	
exit 1
