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

* upgrade.sh

    Utility script to do installation and restarting services

* chain_upgrade.sh

    Utility to do upgrade.sh sequentially

Example
-------

Execute download.sh to download all openvswitch source packages, or download them manually.

    sh download.sh

Upgrade from 1.4.6 to 1.11.0

    ./chain_upgrade.sh 1.4.6 1.7.3 1.9.0 1.10.0 1.11.0


Supported OS
------------

The scripts were tested on CentOS 6.4 and Ubuntu LTS 12.04.
