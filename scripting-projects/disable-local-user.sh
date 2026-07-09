#!/bin/bash

usage() {
    echo "Usage: ./disable-local-user.sh [-dra] USER [USERN]..." >&2
    echo "Disable a local Linux account." >&2
    echo "  -d Deletes accounts instead of disabling them." >&2
    echo "  -r Removes the home directory associated with the account(s)." >&2
    echo "  -a Creates an archive of the home directory associated with the accounts(s)." >&2
    exit 1
}

if [[ ${UID} -ne 0 ]]
then
    echo "Please run with sudo or as root." >&2
    exit 1
fi

DELETE='false'
REMOVE_HOME='false'
ARCHIVE='false'

while getopts dra OPTION
do
    case ${OPTION} in
        d) DELETE='true' ;;
        r) REMOVE_HOME='true' ;;
        a) ARCHIVE='true' ;;
        ?) usage ;;
    esac
done

# OPTIOND is a variable set by getopts
# it holds the index of the next argument to process
# shift removes as many args from the front of ${@} -> only usernames remain
shift "$(( OPTIND - 1 ))"

if [[ ${#} -lt 1 ]]
then
    usage
fi

for USERNAME in "${@}"
do
    echo "Processing user: ${USERNAME}"

    USERID=$(id -u ${USERNAME})
    if [[ ${USERID} -lt 1000 ]]
    then
        echo "Refusing to remove the ${USERNAME} account with UID ${USERID}." >&2
        continue
    fi

    if [[ ${ARCHIVE} = 'true' ]]
    then
        # check if /archive directory exists
        if [[ ! -d "/archive" ]] # it's negated by !
        then
            echo "Creating /archive directory."
            mkdir -p /archive
        fi
        HOME_DIR="/home/${USERNAME}"
        echo "Archiving ${HOME_DIR} to /archive/${USERNAME}.tgz"
        # create compressed archive of user's home directory
        # tar creates an archive file
        # -z compresses with gzip
        # -c creates a new archive
        # -f the next arg is filename of archive
        # 2> /dev/null -> suppresses any error message from tar
        tar -zcf /archive/${USERNAME}.tgz ${HOME_DIR} 2> /dev/null
    fi

    if [[ ${DELETE} = 'true' ]]
    then
        if [[ ${REMOVE_HOME} = 'true' ]]
        then
            userdel -r ${USERNAME} # delete user + home directory
        else
            userdel ${USERNAME} # delete user only, keep home directory
        fi

        if [[ ${?} -ne 0 ]]
        then
            echo "The account ${USERNAME} was NOT deleted." >&2
            continue
        fi
        echo "The account ${USERNAME} was deleted."
    else
        # expire account
        # chage changes account aging/expiry info
        # -E 0 sets expiration day to day 0 (Jan 1, 1970)
        # since it's in the past, immediate
        chage -E 0 ${USERNAME}

        if [[ ${?} -ne 0 ]]
        then
            echo "The account ${USERNAME} was NOT disabled." >&2
            continue
        fi
        echo "The account ${USERNAME} was disabled."
    fi
done
