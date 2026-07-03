#!/bin/bash

read -p "Please enter a file extension: " EXTENSION
read -p "Please enter a file prefix: (Press  ENTER for 20260703)." PREFIX

for FILE in *.${EXTENSION}
do
    if [ ! -f "$FILE" ]
    then
        echo "No .${EXTENSION} files found"
        exit 0
    fi
    if [ -n "$PREFIX" ]
    then
        mv "$FILE" "${PREFIX}${FILE}"
    else
        mv "$FILE" "$(date +%F)${FILE}"
    fi
done