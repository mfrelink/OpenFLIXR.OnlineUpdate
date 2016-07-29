#!/bin/bash
exec 1> >(tee -a /var/log/updateplex.log) 2>&1
TODAY=$(date)
echo "-----------------------------------------------------"
echo "Date:          $TODAY"
echo "-----------------------------------------------------"

THISUSER=$(whoami)
    if [ $THISUSER != 'root' ]
        then
            echo 'You must use sudo to run this script, sorry!'
            exit  1
    fi

cd /opt/plexupdate
bash plexupdate.sh -p
dpkg -i plexmediaserver*.deb
rm plexmediaserver*
