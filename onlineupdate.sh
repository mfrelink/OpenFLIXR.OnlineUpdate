#!/bin/bash
exec 1> >(tee -a /var/log/onlineupdate.log) 2>&1
TODAY=$(date)
echo "-----------------------------------------------------"
echo "Date:          $TODAY"
echo "-----------------------------------------------------"

THISUSER=$(whoami)
    if [ $THISUSER != 'root' ]
        then
            echo 'You must use sudo to run this script, sorry!'
           exit 1
    fi

## Openflixr Online Update version 1.0
echo "OpenFLIXR Online Update:"
