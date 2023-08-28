#!/bin/bash

#set -e -x

#NUM_STUDENTS=20
NUM_STUDENTS=20

die() { echo "$0: die - $*" >&2; exit 1; }

die "NOT WORKING: problems launching (some containers) ..."

#echo HERE1; read

DELETE_DOCKER_NUM() {
    NUM=$1; shift

    bridge=docker${NUM}
    base=/home/ubuntu/docker-daemons/${NUM}
    sudo mkdir -p $base

    PID=$( ps -fade | grep -v grep | grep home/ubuntu/docker-daemons/${NUM}.socket | awk '{ print $2; }' )
    #ps -fade | grep -v grep | grep -v awk | grep home/ubuntu/docker-daemons/${NUM}.socket | awk '{ print $2; }' 
    #echo "PID=<$PID>"
    [ ! -z "$PID" ] && sudo kill -9 $PID

    ip link show $bridge >/dev/null 2>&1 && {
        echo "Removing bridge $bridge"
        sudo ip link delete $bridge
    }
    [ -d "${base}" ] && sudo rm -rf ${base}.data
}

#echo HERE1; read
START_DOCKER_NUM() {
    NUM=$1; shift

    echo "---- START_DOCKER_NUM $NUM -------------------"
    bridge=docker${NUM}
    base=/home/ubuntu/docker-daemons/${NUM}
    bridge_net="10.20.${NUM}.1/24"
    sudo mkdir -p $base
    echo bridge=$bridge bridge_net=$bridge_net base=$base

    # Set up bridge network:
    if ! ip link show $bridge > /dev/null 2>&1; then
       sudo ip link add name $bridge type bridge
       #sudo ip addr add ${net:-"10.20.30.1/24"} dev $bridge
       sudo ip addr add ${bridge_net} dev $bridge
       sudo ip link set dev $bridge up
    fi

    export DOCKER_HOST=unix://${base}.socket
    #ps -fade | grep $DOCKER_HOST && return
    ps -fade | grep -v grep | grep -q $DOCKER_HOST || {
        set -x
        sudo dockerd \
            --bridge=$bridge \
            --data-root=$base.data \
            --exec-root=$base.exec \
            --host=${DOCKER_HOST} \
            --pidfile=$base.pid 2>&1 | sudo tee ${base}.log &
        set +x
    }

    #IMAGE=hello-world
    IMAGE=mjbright/k8s-demo:1
    echo "Press <enter> to launch image"
    read DUMMY
    docker run $IMAGE
    sleep 1; docker ps -a
    #exit 0
}

#echo HERE1; read
DELETE_ALL() {
    for STUDENT in $(seq $NUM_STUDENTS); do
        DELETE_DOCKER_NUM $STUDENT
    done

    echo; echo "Bridges present:"
    ip a  | grep docker
}

#echo HERE1; read
START_ALL() {
    for STUDENT in $(seq $NUM_STUDENTS); do
        START_DOCKER_NUM $STUDENT
    done

    echo; echo "Daemons running:"
    ps -fade | grep dockerd | grep -v grep
}

## -- Main -----------------------------------------------------------

#echo "MAIN"; read

[ "$1" = "-x" ] && { shift; set -x; }

#read

export LS_ALL=0
[ "$1" = "-lsv" ] && { export LS_ALL=1; set -- "-ls"; }

if [ "$1" = "-ls" ]; then
#echo HERE; #read
    for STUDENT in $(seq $NUM_STUDENTS); do
        NUM=$STUDENT
        base=/home/ubuntu/docker-daemons/${NUM}
        export DOCKER_HOST=unix://${base}.socket
        [ $LS_ALL -ne 0 ] && {
            echo "docker[$STUDENT]: $( docker ps -a  )"
	}
	echo "docker[$STUDENT] Running: $( docker ps | wc -l ) / total $( docker ps -a | wc -l ) "
    done
    exit 0
fi
#echo HERE; #read

if [ "$1" = "-rm" ]; then
    DELETE_ALL
    exit 0
fi

START_ALL


die "OK"

SUDO_C=/etc/sudoers.d/multiple-docker
[ -f $SUDO_C ] && sudo rm $SUDO_C 

#grep -v "^$U " /etc/sudoers

for STUDENT in $(seq $NUM_STUDENTS); do
    U=student$STUDENT

    echo "$U ALL=(root) NOPASSWD: /usr/bin/docker -H unix\:///var/run/docker-$U.sock *, ! /usr/bin/docker *--priviledged*, ! /usr/bin/docker *host*" | sudo tee -a $SUDO_C
done

