#!/bin/bash
function file_count()
{
    local COUNT=$(ls | wc -l)
    echo $COUNT
}

echo $(file_count)