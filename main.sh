#!/bin/bash

WD="$(dirname $0)"

function Usage {
    echo "takes all the arguments of xcowsay"
    echo "when the no argument is given the it will use the fortune to say something"
    echo -e "Usage:  xcowsay-utils [OPTIONS]";
    echo -e "\t-i | --image\tchoose image"
    echo -e "\t-d | --dir\tchoose image directory"
    echo -e "\t-r | --random\tto be use with -d for random effect"
    echo -e "\t-c | --credits\tDisplay the Credits"
    echo -e "\t-h | --help\tDisplay this message"
}

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

TEMP=$(getopt -o id:rch\
              -l image,dir:,random,credits,help\
              -n "xcowsay-utils"\
              -- "$@")

# TODO: fix this error check to getopt
if [ $? != "0" ]; then exit 1; fi

eval set -- "$TEMP"

while true; do
    case $1 in
        # -i|--image)      dis=1; shift;;
        -d|--dir)        shift; img_file=" -d $(Directory $1) "; shift;;
        # -w|--week)       dis=0; shift;;
        # -t|--today)      dis=3; shift;;
        # -u|--update)     update; exit;;
        # -x|--xml)        xml_dump; exit;;
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

xcowsay --image=${IMG_LIST[$r]} $extra_args $img_file $msg
