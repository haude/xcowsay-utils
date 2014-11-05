#!/bin/bash

WD="$(dirname $0)"

function Usage {
    echo -e "Usage:  xcowsay-utils [OPTIONS]";
    echo -e "\t-i | --image\tShow All [force]"
    echo -e "\t-d | --directory\tGroup number 1-7"
    echo -e "\t-r | --random\tShow today's schedule [uses with group no]"
    echo -e "\t-w | --week\tShow week's schedule"
    echo -e "\t-u | --update\tCheck for update [ignores extra options]"
    echo -e "\t-c | --credits\tDisplay the Credits"
    echo -e "\t-h | --help\tDisplay this message"
}

TEMP=$(getopt -o g:awtuxch\
              -l all,group:,week,today,update,xml,credits,help\
              -n "xcowsay-utils"\
              -- "$@")

if [ $? != "0" ]; then exit 1; fi

eval set -- "$TEMP"

dis=0
while true; do
    case $1 in
        -a|--all)        dis=1; shift;;
        -g|--group)      grp=$2; shift 2;;
        -w|--week)       dis=0; shift;;
        -t|--today)      dis=3; shift;;
        -u|--update)     update; exit;;
        -x|--xml)        xml_dump; exit;;
        -c|--credits)    Credits; exit;;
        -h|--help)       Usage; exit;;
        --)              shift; break;;
    esac
done

# listing stuffs
IMG_SRC=$WD/faces
IMG_LIST=($IMG_SRC/*.png)

function random {
	local RANDOMIZE_UPTO=$1
	let "number = $RANDOM % $RANDOMIZE_UPTO"
	echo $number
}

r=$(random `echo ${#IMG_LIST[@]}`)
msg=$(fortune)

xcowsay -t 10 --image=${IMG_LIST[$r]} "$msg"
