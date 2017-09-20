#!/bin/bash
THISUSER=$(whoami)
    if [ $THISUSER != 'root' ]
        then
            echo 'You must use sudo to run this script, sorry!'
            exit 1
    fi

exec 1> >(tee -a /var/log/updatewkly.log) 2>&1
TODAY=$(date)
echo "-----------------------------------------------------"
echo "Date:          $TODAY"
echo "-----------------------------------------------------"

## System
echo ""
echo "OS update:"
apt-get clean -y
apt-get autoremove --purge -y
apt-get update -y
apt-get install -f -y --assume-no
apt-get update -y --assume-no
apt-get upgrade -y --assume-no
sed -i s/Prompt=lts/Prompt=normal/g /etc/update-manager/release-upgrades
apt-get dist-upgrade -y --assume-no
cp /etc/apt/apt.conf.d/50unattended-upgrades.ucftmp /etc/apt/apt.conf.d/50unattended-upgrades
rm /etc/apt/apt.conf.d/50unattended-upgrades.ucftmp
dpkg --configure -a

## Spotweb
echo ""
echo "Spotweb:"
cd /tmp/
wget https://github.com/spotweb/spotweb/tarball/master
tar -xvzf master
sudo cp -r -u spotweb-spotweb*/* /var/www/spotweb/
rm master
rm -rf spotweb-spotweb*/
cd /var/www/spotweb/bin/
php upgrade-db.php

## Jackett
echo ""
echo "Jackett:"
service jackett stop
cd /tmp/
rm Jackett.Binaries.Mono.tar.gz* 2> /dev/null
jackettver=$(wget -q https://github.com/Jackett/Jackett/releases/latest -O - | grep -E \/tag\/ | awk -F "[><]" '{print $3}' | sed -n '2p')
wget -q https://github.com/Jackett/Jackett/releases/download/$jackettver/Jackett.Binaries.Mono.tar.gz
tar -xvf Jackett*
sudo cp -r -u Jackett*/* /opt/jackett/
rm -rf Jackett*/
rm Jackett.Binaries.Mono.tar.gz*
service jackett start

## PlexRequests
echo ""
echo "Plexrequests.net:"
service plexrequestsnet stop
cd /tmp/
plexrequestsver=$(wget -q https://github.com/tidusjar/Ombi/releases/latest -O - | grep -E \/tag\/ | awk -F "[<>]" '{print $3}' | cut -c 6- | sed -n '2p')
wget -q https://github.com/tidusjar/Ombi/releases/download/$plexrequestsver/Ombi.zip
unzip Ombi.zip
rm Ombi.zip
sudo cp -r -u Release/* /opt/plexrequest.net/
rm -rf Release/
service plexrequestsnet start

## Plex Media Server
echo ""
echo "Plex Media Server:"
cd /opt/plexupdate
bash plexupdate.sh -p
dpkg -i /tmp/plexmediaserver*.deb 2> /dev/null
rm /tmp/plexmediaserver*

## Netdata
echo ""
echo "Netdata:"
service netdata stop
killall netdata
cd /opt/netdata.git/
sudo git pull
sudo bash netdata-installer.sh --dont-wait --install /opt

## Ntopng - needs testing
#cd /tmp
#wget http://apt.ntop.org/16.04/all/apt-ntop.deb
#dpkg -i apt-ntop.deb
#rm apt-ntop.deb
#apt-get clean all
#apt-get update
#apt-get install pfring nprobe ntopng ntopng-data n2disk cento nbox

## Wetty
echo ""
echo "Wetty:"
cd /opt/wetty
git pull
npm install wetty -g

## Update everything else
echo ""
echo "updateof:"
cd /opt/openflixr
bash updateof
echo ""
echo "Misc:"
cd /usr/lib/node_modules
npm install npm@latest -g
cd /usr/lib/node_modules/rtail
npm update
cd /usr/lib/node_modules/npm
npm update
pip install --upgrade pip
pip2 install --upgrade pip
pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs pip install -U
pip2 freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs pip2 install -U

## Weekly maintenance task
echo ""
echo "Cleanup:"
cd /opt/openflixr
bash cleanup.sh
echo ""
echo "Nginx fix"
mkdir /var/log/nginx

# new_entry
