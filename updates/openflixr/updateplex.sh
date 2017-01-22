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
bash plexupdate.sh -p 2> /dev/null
dpkg -i /tmp/plexmediaserver*.deb 2> /dev/null
rm /tmp/plexmediaserver* 2> /dev/null
