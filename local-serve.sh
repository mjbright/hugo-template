#!/bin/bash

RELEASE=0.116.1

PORT=1312
CONFIG=config.default.toml 

#export PATH=$PATH:/usr/bin
uname=/usr/bin/uname

mkdir -p ~/bin ~/tmp

die() { echo "$0: die - $*" >&2; exit 1; }

LINUX=0
MACOS=0
case $( $uname ) in
    Linux)  LINUX=1; PATH=~/bin/hugo;      os=linux;;
    Darwin) MACOS=1; PATH=~/usr/bin_macos; os=darwin;;

    *)      die "Unknown OS $( $uname )"
esac

CPU=""
case $( $uname -m ) in
    arm64)   CPU=arm64;;
    aarch64) CPU=arm64;;

    *)       die "Unknown CPU $( $uname -m )"
esac

if [ $LINUX -eq 1 ]; then
    PATH=~/bin/hugo
fi

[ -x $PATH ] || {
    URL=https://github.com/gohugoio/hugo/releases/download/v${RELEASE}/hugo_extended_${RELEASE}_${os}-${CPU}.tar.gz
    wget -qO ~/tmp/hugo_extended.tar.gz  $URL
    tar xf ~/tmp/hugo_extended.tar.gz hugo
    mv hugo ~/bin/hugo
    chmod +x ~/bin/hugo
}


while [ ! -z "$1" ]; do
    case "$1" in
        -az*|az*) CONFIG=config.tf-azure.toml;;
        -aw*|aw*) CONFIG=config.tf-aws.toml;;
    esac
    shift
done

[ ! -f $CONFIG ] && die "No such config file '$CONFIG'"

IP=$( ip a | awk '/inet 192.168/ { print $2; }' | sed 's?/24??' )
echo
echo
echo "Serving on ${IP}:${PORT}"
set -x
hugo serve --bind 0.0.0.0 --port $PORT --config $CONFIG
