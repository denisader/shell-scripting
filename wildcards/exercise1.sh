#!/bin/bash

for FILE in *.jpg
do
    if [ ! -f "$FILE" ]
    then
        echo "No .jpg files found"
        exit 0
    fi
    mv "$FILE" "$(date +%F)${FILE}"
done