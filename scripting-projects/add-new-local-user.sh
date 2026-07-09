#!/bin/bash

if [[ ${UID} -ne 0 ]]
then
    echo "Please run with sudo or as root."
    exit 1
fi

if [[ ${#} -lt 1 ]] # sudo ./add.sh USERNAME [COMMENT]
then
    echo "Usage: sudo ./add-new-local-user.sh USER_NAME [COMMENT]"
    echo "Create an account on the local system with the name of USER_NAME and a comments field of COMMENT."
    exit 1
fi

USERNAME=${1}
shift
COMMENT=${@}

useradd -c "${COMMENT}" -m $USERNAME

if [[ ${?} -ne 0 ]]
then
    echo "Useradd command did not succeed."
    exit 1
fi

START=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c48)
SPECIAL=$(echo '!@#$%^&*()_-+=' | fold -w1 | shuf | head -c1)
PASSWORD="${START}${SPECIAL}"

echo ${PASSWORD} | passwd --stdin ${USERNAME}

if [[ ${?} -ne 0 ]]
then 
    echo "Passwd command did not succeed."
    exit 1
fi

passwd -e ${USERNAME}

echo "username:"
echo "$USERNAME"

echo "password:"
echo "$PASSWORD"

echo "host:"
echo "${HOSTNAME}"
