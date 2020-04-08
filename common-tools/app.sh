#!/bin/bash
printf "    _    _   _____ ___  ____  _   _ ___ _____ _____ \n"
printf "   / \  | | |_   _/ _ \/ ___|| | | |_ _|  ___|_   _ \n"
printf "  / _ \ | |   | || | | \___ \| |_| || || |_    | |  \n"
printf " / ___ \| |___| || |_| |___) |  _  || ||  _|   | |  \n"
printf "/_/   \_\_____|_| \___/|____/|_| |_|___|_|     |_|  Tools\n"

CONFIG='_CONFIG_'

reqName="$1"
sortcut=()

function alto(){
	echo "finding $reqName.."
        input="$CONFIG"
        [ ! -f "$input" ] && echo "$input : File not found" && return 1
        RESP=""
        [ -z $reqName ] && echo "no input" && return 1
        while read row; do
                name=$(echo $row | awk 'END {print $1}')
                [ $name == $reqName ] && RESP=$row && break
		sortcut+=("$name")
        done < $input;

	if [ -z "$RESP" ]; then
		echo "Not found"
		echo "Try : "$( IFS=$'\n'; echo "${sortcut[*]}" )
		exit 1
	fi

        tmp=($RESP) && NAME=${tmp[0]}; HOST=${tmp[1]}; USER=${tmp[2]}; KEY=${tmp[3]}

        echo "Login to $HOST" && [ $KEY == "" ] && ssh $USER@$HOST || ssh -i $KEY $USER@$HOST
	echo "bye..."
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	alto "$@"
fi
