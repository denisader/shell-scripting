#!/bin/bash

if [[ "${UID}" -ne 0 ]]
then
    echo "Please run with sudo or as root."
    exit 1
fi

read -p "Enter the username to create: " USERNAME
read -p "Enter the name of the person or application that will be using the account: " NAME
read -p "Enter the password to use for this account: " PASSWORD

useradd -c "${NAME}" -m ${USERNAME}

if [[ ${?} -ne 0 ]]
then
    echo "Adding the user did not succeed."
    exit 1
fi

# echo "Changing password for user ${USERNAME}."
echo ${PASSWORD} | passwd --stdin ${USERNAME}

if [[ ${?} -ne 0 ]]
then
    echo "Passwd command did not succeed."
    exit 1
fi

passwd -e ${USERNAME} # forces a password change on first login

echo "username:"
echo "$USERNAME"

echo "password:"
echo "$PASSWORD"

echo "host:"
echo "${HOSTNAME}"