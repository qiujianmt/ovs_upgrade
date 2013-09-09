#!/bin/bash

for ver in $@
do
    echo $ver
    ./upgrade.sh $ver
    if [[ "$?" != "0" ]]; then
        echo "Failed on $ver"
        exit -2
    fi
done
