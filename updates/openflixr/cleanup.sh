#!/bin/bash
THISUSER=$(whoami)
    if [ $THISUSER != 'root' ]
        then
            echo 'You must use sudo to run this script, sorry!'
            exit 1
    fi

apt-get clean -y
apt-get autoremove --purge -y
bash /opt/openflixr/purgeoldkernels
rm -rf /var/lib/apt/lists
mkdir /var/lib/apt/lists
mkdir /var/lib/apt/lists/partial
dpkg --clear-avail
dpkg --configure -a
apt-get update -y

TMP_DIRS="/tmp /var/tmp /var/log"
DEFAULT_FILE_AGE=+2
DEFAULT_LINK_AGE=+2
DEFAULT_SOCK_AGE=+2

/usr/bin/logger "cleantmp.sh[$$] - Begin cleaning tmp directories"

echo ""
echo "delete any tmp files that are more than 2 days old"
/usr/bin/find $TMP_DIRS                           		\
     -depth                                                     \
     -type f -a -ctime $DEFAULT_FILE_AGE                        \
     -print -delete
echo ""

echo "delete any old tmp symlinks"
/usr/bin/find $TMP_DIRS                               		\
     -depth                                                     \
     -type l -a -ctime $DEFAULT_LINK_AGE                        \
     -print -delete
echo ""

echo "Delete any old Unix sockets"
/usr/bin/find $TMP_DIRS                               		\
     -depth                                                     \
     -type s -a -ctime $DEFAULT_SOCK_AGE -a -size 0             \
     -print -delete
echo""

echo "delete any empty directories (other than lost+found)"
/usr/bin/find $TMP_DIRS                               		\
     -depth -mindepth 1                                         \
     -type d -a -empty -a ! -name 'lost+found'                  \
     -print -delete
echo ""

/usr/bin/logger "cleantmp.sh[$$] - Done cleaning tmp directories"

exit 0
