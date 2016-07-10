#!/bin/bash
THISUSER=$(whoami)
    if [ $THISUSER != 'root' ]
        then
            echo 'You must use sudo to run this script, sorry!'
           exit 1
    fi

exec 1> >(tee -a /var/log/onlineupdate.log) 2>&1
TODAY=$(date)
echo "-----------------------------------------------------"
echo "Date:          $TODAY"
echo "-----------------------------------------------------"

## OpenFLIXR Online Update version 1.0.0
echo ""
echo "OpenFLIXR Wizard Update:"
cd /usr/share/nginx/html/setup
git pull -v
echo ""
echo "OpenFLIXR Online Update:"
cd /opt/update
git pull -v
echo ""
echo "OpenFLIXR installing updates:"
chmod +x /opt/update/scripts/*
run-parts /opt/update/scripts