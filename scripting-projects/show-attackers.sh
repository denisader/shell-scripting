#!/bin/bash

cannot() {
    if [[ -n "${1}" ]]
    then
        echo "Cannot open log file: ${1}"
    else
        echo "Cannot open log file."
    fi    
}

if [[ ${#} -gt 0 ]]
then
    LOG_FILE=${1}
    if [[ ! -e "${LOG_FILE}" ]]
    then
        cannot "$LOG_FILE"
        exit 1
    fi
else
    cannot
    exit 1
fi

echo "Count,IP,Location"

grep "Failed password" "${LOG_FILE}" | awk -F 'from ' '{print $2}' | awk '{print $1}' | sort | uniq -c | sort -rn | while read COUNT IP
# we first find the lines which match "Failed password" in the LOG_FILE using grep
# then we pass them (through a pipe) to a command which splits by 'from' and takes second half
# then using the same command from the second half we only keep the first word (corresponds to IP)"
# we sort the IP addresses because uniq command can find duplicates only on consecutive identic lines"
# then we sort such that most failed IP address appears first
# and then we go through each line and extract COUNT and IP
do
    if [[ "${COUNT}" -gt 10 ]]
    then
        LOCATION=$(geoiplookup "${IP}" | awk -F ': ' '{print $2}')
        echo "${COUNT},${IP},${LOCATION}"
    fi
done
