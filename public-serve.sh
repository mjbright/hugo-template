#!/usr/bin/env bash

LABGROUP=azure

PORT=1313
HUGO_CONFIG="config.tf-${LABGROUP}.toml"

mkdir -p ~/tmp/

SERVERUP_DIR=$(dirname $0)

TOUCH_FILE=$SERVERUP_DIR/.public-serve.sh

cd $SERVERUP_DIR
pwd
LOG=~/tmp/hugo.public.python.serve.log

PID=0

## - Func: ------------------------------------

die() { echo "$0: die - $*" >&2; exit 1; }

RELAUNCH_SERVER() {
    cd $SERVERUP_DIR

    CMD="hugo --config $HUGO_CONFIG"
    echo; echo "Rebuilding public/ content"
    echo "-- $CMD"
    $CMD

    #cd ./public/

    echo "Index of $LABGROUP labs:"
    # NO: not the same names in public:
    # grep _Lab public/${LABGROUP}/index.html | sed 's/^ *//g' > public/${LABGROUP}.md
    ls -1d content/${LABGROUP}/[0-9]* | awk -F / '{ print $3;}' > public/${LABGROUP}.md

    ls -al public/${LABGROUP}.md
    sed 's/^/- /' public/${LABGROUP}.md

    CMD="python -m http.server $PORT --bind 0.0.0.0 --directory public/"
    echo; echo "Serving public/ content [in background]"
    echo "Logging to $LOG"
    echo "---- $( date ): -------------------------------" >> $LOG
    echo "-- $CMD &"
    echo "-- $CMD &"       >> $LOG

    SLEEP=5
    while ss -l | grep $PORT; do
        echo "... Waiting [sleep $SLEEP] for port $PORT to be free"
        sleep $SLEEP
    done
    echo "Port $PORT is free"
    $CMD >> $LOG 2>&1 &
    PID=$!
    touch $TOUCH_FILE
}

WRITE_SW_VERSIONS() {
    which terraform >/dev/null 2>&1 &&
        terraform version -json | jq -rc '.terraform_version' > public/.terraform_version
}

WRITE_META() {
    # Write meta information about lab + s/w versions:
    WRITE_SW_VERSIONS
    echo $LABGROUP > public/.labgroup
    case $LABGROUP in
        azure) echo "TFI_Azure" > public/.labgroup_name;;
        *)     die "Unknown labgroup";;
    esac
}

## - Main: ------------------------------------

[ ! -f $HUGO_CONFIG ] && die "No such file as '$HUGO_CONFIG"

[ ! -f $TOUCH_FILE ] && {
    touch $TOUCH_FILE
    sleep 1
}

touch $HUGO_CONFIG

# Detect if server is already running:
SERVER_PID=$( ps aux | grep $PORT | awk '/ http.server / { print $2; }' )
[ ! -z "$SERVER_PID" ] && kill -9 "$SERVER_PID"

WRITE_META
while true; do
    CHANGED=$( find $HUGO_CONFIG content/ themes/ -type f -newer $TOUCH_FILE | wc -l )
    if [ $CHANGED != "0" ]; then
        echo; echo "$CHANGED files changed:"
        find $HUGO_CONFIG content/ themes/ -type f -newer $TOUCH_FILE

        [ $PID -ne 0 ] && kill -9 $PID
        WRITE_META
        RELAUNCH_SERVER
    fi

    #exit
    sleep 1
done


