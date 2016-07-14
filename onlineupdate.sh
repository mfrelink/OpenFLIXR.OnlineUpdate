#!/bin/bash
THISUSER=$(whoami)
    if [ $THISUSER != 'root' ]
        then
            echo 'You must use sudo to run this script, sorry!'
           exit 1
    fi

mkdir /var/log/openflixrupdate
exec 1> >(tee -a /var/log/openflixrupdate/onlineupdate.log) 2>&1
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
chmod -x /opt/update/scripts/*
chmod -x /opt/update/dev/*
git pull -v
echo ""
echo "OpenFLIXR installing updates:"
chmod +x /opt/update/scripts/*
chmod +x /opt/update/dev/*

if [ "$1" == 'force' ]
then
rm -rf /opt/update/doneupdate/*
fi

cd /opt/update/doneupdate/
FILES=*

for f in $FILES
  do
    if [ "$f" != '*' ]
        then
          rm /opt/update/scripts/$f
    fi
  done
run-parts /opt/update/scripts
