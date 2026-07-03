#!/bin/bash
read -p "How many lines of /etc/passwd would you like to see? " COUNT
while read LINE
do
    if [ $COUNT -eq 0 ]
    then
        break
    fi
    echo "$LINE"
    ((COUNT--))
done < /etc/passwd