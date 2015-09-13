#!/bin/bash

WD="$(dirname $(readlink $0 || echo $0))"

function Credits {
    h1="\033[1;32m"
    cdef="\033[0;0m"
    sed 's/^#.*/'`echo -e $h1`'&'`echo -e $cdef`'/' $WD/AUTHORS
    echo
}

function random {
	local RANDOMIZE_UPTO=$1
	let "number = $RANDOM % $RANDOMIZE_UPTO"
	echo $number
}

function pkg_handle {
    # put dot as separator
    pkg=(${1/./ })
    MESSAGES_PATH="$WD/pkg/${pkg[0]}"
    test -d "$MESSAGES_PATH" || {
        >&2 echo 'Package Error'
        return
    }

    if [[ -e "$MESSAGES_PATH/${pkg[1]}.png" ]]; then
        echo " -d $MESSAGES_PATH/${pkg[1]}.png "
        return
    else
        >&2 echo 'Randomizing...'
    fi

    >&2 echo MESSAGES_PATH = \"$MESSAGES_PATH\"
    MSG_LIST=($MESSAGES_PATH/*.png)
    rand=$(random `echo ${#MSG_LIST[@]}`)
    echo " -d ${MSG_LIST[$rand]} "
}

function inhibit {
    [ -e /tmp/present ] && exit
    >&3 which xfconf-query && {
        state=$(xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/presentation-mode)
    }
    >&3 echo STATE = $state
    [ $state == 'true' ] && exit
}

function Usage {
    echo "Takes all the arguments of xcowsay"
    echo -e "Usage:  xcowsay-utils [OPTIONS]";
    echo -e "\t-a | --again           Show again recently say"
    echo -e "\t-l | --pkglst          List package"
    echo -e "\t-p | --pkg [pkg.file]  use package and specify file"
    echo -e "\t-m | --mem             needed before using again"
    echo -e "\t-i | --inhibit         Disable when buzy (/tmp/present or xfce4)"
    echo -e "\t-c | --credits         Show credits"
    echo -e "\t-v | --verbose         Increase verbosity"
    echo -e "\t-h | --help            Display this message"
}

# TODO: don't use getopt it blocks xcowsay command
GETOPT=$(getopt -o aip:lrmcvh\
              -l again,inhibit,pkg:,pkglstrandom,memory,credits,vebose,help\
              -n "xcowsay-utils"\
              -- "$@")

# TODO: fix this error check to getopt
if [ $? != "0" ]; then exit 1; fi

eval set -- "$GETOPT"

mem=0
VV=2
exec 3> /dev/null
exec 4> /dev/null
while true; do
    case $1 in
        -a|--again)      $(cat /tmp/xcowsay-utils); exit;;
        -p|--pkg)        shift; img_file="$(pkg_handle $1)"; shift;;
        -l|--pkglst)     ls -1 "$WD/pkg"; exit;;
        -m|--memory)     mem=1; shift;;
        -i|--inhibit)    inhibit; shift;;
        -c|--credits)    Credits; exit;;
        -v|--verbose)    let VV++; eval "exec $VV>&2"; shift;;
        -h|--help)       Usage; exit;;
        --)              shift; break;;
    esac
done

>&3 echo $WD
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
