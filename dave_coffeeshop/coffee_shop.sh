#!/bin/bash

db_path=/home/alex/davecoffeeshop.db

echo "Welcome to the Dave Coffeeshop!"

if [[ !(-e $db_path) ]] 
then
	echo "$db_path missing => creating new file"
	touch $db_path
fi

echo "To log order, enter LOG"
echo "To end session, enter EOS"
echo "To end business day, enter EOD"

status="RUN"
while [[ $status == "RUN" ]];
do
	read operation
	case $operation in
	"LOG")
		read -p "Barista name : " name
		read -p "Drinking : " drinking
		read price <<< $(echo "foo" | awk -v key=$drinking 'BEGIN {    
		  item["AME"]=100;
		  item["ESP"]=120;
		  item["CAP"]=150;
		  item["LAT"]=170;
		  item["RAF"]=200;

		  if (key in item) {
			  print item[key];
		}
		else {
			print key;
		}
		}
		'
		)
		if [[ $price == $drinking ]];then
			echo "Invalid drink $drinking, ignoring"
		else
			echo "$name;$drinking;$price" >> $db_path
			echo "Order was saved!"
		fi;;
	"EOS")
		status="Shutdown";;
	"EOD")
		echo "End of DAY!"
		cat $db_path | awk -F ';' '{
		OFS=";"; 
		a[$1]+=$3
		}
		END {
			for (i in a) 
				print i,a[i]
		}' | sort -k 2 -t ';' -r;;
	esac
done       

