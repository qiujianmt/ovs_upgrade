ovs_upgrade
===========

Tools upgrade openvswitch without service interruption

Usage
-----

* ovs_install.sh

    Install both kernel and userspace software


* ovs_control

    Uitility script to restart the services and kernel module

* download.sh

    Utility to download ovs source codes


Example
-------

    sh download.sh

    ./ovs_install.sh 1.10.0

    sudo ./ovs_control force-reload-kmod

Supported OS
------------

The scripts were tested on CentOS 6.4 and Ubuntu LTS 12.04.
