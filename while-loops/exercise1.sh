#!/bin/bash
COUNT=1
while read LINE
do
    echo "${COUNT}: $LINE"
    ((COUNT++))
done < /etc/passwd