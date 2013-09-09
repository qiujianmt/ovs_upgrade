#!/bin/bash

VERSION=$1

if [[ -z $VERSION ]]; then
    echo "Usage: upgrade.sh version"
    exit 1
fi

if [[ ! -f openvswitch-$VERSION.tar.gz ]]; then
    echo "openvswitch-$VERSION.tar.gz not found"
    exit 2
fi

function get_ip {
    if [ -z $1 ]; then
        IF=eth0
    else
        IF=$1
    fi
    /sbin/ifconfig $IF > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        return
    fi
    /sbin/ifconfig $IF | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'
}

function get_mask {
    if [ -z $1 ]; then
        IF=eth0
    else
        IF=$1
    fi
    /sbin/ifconfig $IF > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        return
    fi
    /sbin/ifconfig $IF | grep 'Mask:' | cut -d: -f4
}

function default_gw {
    get_ip $1 | awk 'BEGIN{FS="."}{print $1 "." $2 "." $3 ".1"}'
}

if [[ -f /usr/local/bin/ovs-vsctl ]]; then
    echo "OVS installed in /usr/local"
    OVS_VSCTL=/usr/local/bin/ovs-vsctl
    ./ovs_install.sh $VERSION
    sudo ./ovs_control force-reload-kmod
elif [[ -f /usr/bin/ovs-vsctl ]]; then
    echo "OVS installed in /usr"
    OVS_VSCTL=/usr/bin/ovs-vsctl
    rm -fr .recover
    for br in $(sudo $OVS_VSCTL list-br)
    do
        echo $br
        IP=$(get_ip $br)
        if [[ $IP != 169.254.* ]]; then
            MASK=$(get_mask $br)
            GW=$(default_gw $br)
            echo "sudo /sbin/ifconfig $br $IP netmask $MASK" >> .recover
            echo "sudo route add default gw $GW" >> .recover
        fi
    done
    ./ovs_install.sh $VERSION
    sudo ./ovs_control force-reload-kmod
    if [[ -f .recover ]]; then
        sh .recover
        rm .recover
    fi
else
    echo "No ovs installed"
    ./ovs_install.sh $VERSION
    sudo ./ovs_control start
fi
