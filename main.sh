#!/bin/bash

WD="$(dirname $(readlink $0 || echo $0))"

function Credits {
    h1="^[[1;32m"
    cdef="^[[0;0m"
    sed 's/^#.*/'`echo -e $h1`'&'`echo -e $cdef`'/' $WD/AUTHORS
    echo
}

function random {
	local RANDOMIZE_UPTO=$1
	let "number = $RANDOM % $RANDOMIZE_UPTO"
	echo $number
}

function Directory {
    MESSAGES_PATH="$WD/$1"
    >&2 echo MESSAGES_PATH = \"$MESSAGES_PATH\"
    MSG_LIST=($MESSAGES_PATH/*.png)
    rand=$(random `echo ${#MSG_LIST[@]}`)
    echo ${MSG_LIST[$rand]}
}

function Usage {
    echo "takes all the arguments of xcowsay"
    echo "when the no argument is given the it will use the fortune to say something"
    echo -e "Usage:  xcowsay-utils [OPTIONS]";
    echo -e "\t-a | --again\tshow again recently show"
    echo -e "\t-d | --dir\tchoose image directory"
    echo -e "\t-r | --random\tto be use with -d for random effect"
    echo -e "\t-c | --credits\tDisplay the Credits"
    echo -e "\t-h | --help\tDisplay this message"
}

TEMP=$(getopt -o aid:rmch\
              -l again,image,dir:,random,memory,credits,help\
              -n "xcowsay-utils"\
              -- "$@")

# TODO: fix this error check to getopt
if [ $? != "0" ]; then exit 1; fi

eval set -- "$TEMP"

mem=0
while true; do
    case $1 in
        -a|--again)      $(cat /tmp/xcowsay-utils); exit;;
        -d|--dir)        shift; img_file=" -d $(Directory $1) "; shift;;
        -m|--memory)     mem=1; shift;;
        -c|--credits)    Credits; exit;;
        -h|--help)       Usage; exit;;
        --)              shift; break;;
    esac
done

# extra argument
for arg do
    extra_args+=" $arg"
done

# listing stuffs
IMG_PATH=$WD/faces
IMG_LIST=($IMG_PATH/*.png)

r=$(random `echo ${#IMG_LIST[@]}`)

# TODO: check the extra argument as the loop
# for ((i=0; i <= ${#args}; i++)); do
#     local a=${args[i]}
#     if [[ ${a:0:1} == '-' && $a != '-c' ]]; then
#         /usr/bin/emacs ${args[*]}
#         return
#     fi
# done

if [[ "$extra_args" == "" && "$img_file" == "" ]]; then
    msg=$(fortune)
fi

if [[ "$mem" == 0 ]]; then
    xcowsay --image=${IMG_LIST[$r]} $extra_args $img_file "$msg"
    exit 0
fi

echo xcowsay --image=${IMG_LIST[$r]} $extra_args $img_file \"$msg\" > /tmp/xcowsay-utils
$(cat /tmp/xcowsay-utils)