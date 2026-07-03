#!/bin/bash

FILEDIR=$1

if [ -f "$FILEDIR" ] 
then
    exit 0
elif [ -d "$FILEDIR" ]
then
    exit 1
else
    exit 2
fi