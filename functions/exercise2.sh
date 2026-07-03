#!/bin/bash
function file_count()
{
    DIR=$1
    echo "${DIR}:"
    local COUNT=$(ls $DIR | wc -l)
    echo $COUNT
}

echo $(file_count "/etc")
echo $(file_count "/var")
echo $(file_count "/usr/bin")