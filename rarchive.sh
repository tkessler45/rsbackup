1. Mount archive drive

2. Rsync to the archive drive mounted at /Volumes/drivename

3. Unmount archive drive


rsarchive.sh
----------
#!/bin/bash

mkdir /Volumes/test

mount -t afp afp://user:pass@burnsarchive/BurnsXS/ /Volumes/rsmnt

echo ---------- Archiving on `date`

rsync -rgtl --ignore-errors --exclude="backups/" /Volumes/Burns1/rsyncbackup/ /Volumes/rsmnt/ 2>> /Volumes/rsmnt/errors.log

umount /Volumes/rsmnt

rmdir /Volumes/rsmnt
