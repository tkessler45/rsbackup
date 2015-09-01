#!/bin/bash

# written by Topher Kessler, email tkessler@ucdavis.edu with any questions

# this script will backup the the User's local profile to the burnsxs
# server using rsync running in the Cygwin bash shell on the local windows
# computer. It will connect to the shared "rsyncbackup" directory on the
# server and create the appropriate files and destination folders. This
# script will also backup the 'All Users' folder, and all documents in that
# folder which are readable by the current user.
#
# This script does not require command line access to the server.
#
# This script will run at logout.

# $HOSTNAME is the local computers name:
# $USERNAME is the current user account name:

DAYDATE=`/usr/bin/date +%Y-%m-%d`
HOURMINSEC=`/usr/bin/date +%H%M%S`

USERBACKUPDIR=//Burnsxs/rsyncbackup/$USERNAME/backups/$HOSTNAME/$DAYDATE/$HOURMINSEC/
/usr/bin/mkdir -p //Burnsxs/rsyncbackup/$USERNAME/backups/$HOSTNAME/$DAYDATE/$HOURMINSEC/

ALLBACKUPDIR=//Burnsxs/rsyncbackup/All\ Users/backups/$DAYDATE/$HOURMINSEC/$HOSTNAME
/usr/bin/mkdir -p //Burnsxs/rsyncbackup/All\ Users/backups/$DAYDATE/$HOURMINSEC/$HOSTNAME

USERRSARGS="-rtglv --delete --delete-after --delete-excluded --progress --backup --backup-dir=$USERBACKUPDIR --exclude-from=//Burnsxs/rsyncbackup/info/rsyncexclude.txt"
ALLRSARGS="-rtglv --delete --delete-after --delete-excluded --progress --backup --backup-dir=$ALLBACKUPDIR --exclude-from=//Burnsxs/rsyncbackup/info/rsyncexclude.txt"
USERDEST=//Burnsxs/rsyncbackup/$USERNAME/current/$HOSTNAME
/usr/bin/mkdir -p //Burnsxs/rsyncbackup/$USERNAME/current/$HOSTNAME

ALLDEST=//Burnsxs/rsyncbackup/All\ Users/current/$HOSTNAME
/usr/bin/mkdir -p //Burnsxs/rsyncbackup/All\ Users/current/$HOSTNAME

USERSRC=/cygdrive/c/Documents\ and\ Settings/$USERNAME/
ALLSRC=/cygdrive/c/Documents\ and\ Settings/"All Users"/

# append backup time to user log file

echo ------------backing up $USERNAME on $HOSTNAME: $(/usr/bin/date +%b%e\ -\ %H:%M) >> //Burnsxs/rsyncbackup/info/logs/$USERNAME.log

# run the rsync command:

echo "Syncing documents and settings for $USERNAME on $HOSTNAME"
/usr/bin/date > //Burnsxs/rsyncbackup/info/logs/$USERNAME-errors.log
/usr/bin/rsync $USERRSARGS "$USERSRC" "$USERDEST" 2>> //Burnsxs/rsyncbackup/info/logs/$USERNAME-errors.log

#REPEAT FOR "ALL USERS" ACCOUNT

# append backup time to "All Users" log file

echo ------------backing up 'All Users' on $HOSTNAME: $(/usr/bin/date +%b%e\ -\ %H:%M) >> //Burnsxs/rsyncbackup/info/logs/All\ Users.log

# run the rsync command:

echo "Syncing documents and settings for 'All Users' on $HOSTNAME"
/usr/bin/date > //Burnsxs/rsyncbackup/info/logs/All\ Users-errors.log
/usr/bin/rsync $ALLRSARGS "$ALLSRC" "$ALLDEST" 2>> //Burnsxs/rsyncbackup/info/logs/All\ Users-errors.log

# cleanup added directories if they're empty...
/usr/bin/rmdir --ignore-fail-on-non-empty //Burnsxs/rsyncbackup/$USERNAME/backups/$HOSTNAME/$DAYDATE/$HOURMINSEC
/usr/bin/rmdir --ignore-fail-on-non-empty //Burnsxs/rsyncbackup/$USERNAME/backups/$HOSTNAME/$DAYDATE
/usr/bin/rmdir --ignore-fail-on-non-empty //Burnsxs/rsyncbackup/$USERNAME/backups/$HOSTNAME
/usr/bin/rmdir --ignore-fail-on-non-empty //Burnsxs/rsyncbackup/All\ Users/backups/$HOSTNAME/$DAYDATE/$HOURMINSEC
/usr/bin/rmdir --ignore-fail-on-non-empty //Burnsxs/rsyncbackup/All\ Users/backups/$HOSTNAME/$DAYDATE
/usr/bin/rmdir --ignore-fail-on-non-empty //Burnsxs/rsyncbackup/All\ Users/backups/$HOSTNAME
