#!/bin/sh

if [ ! $EUID == 0 ]; then
    echo "please run as root";
    exit 1
fi

echo "Full system backup"

read -p "Select your backup destination " DEST

echo "DEST = $DEST"

if [ ! -d $DEST ]; then
    echo "Backup destination do not exist, abort"
    exit 1
fi

read -p "Are you sure to start a backup? (y/N) " FLAG

if [ ! $FLAG ] || [ $FLAG != "y" ]; then
    echo "Abort"
    exit 1
fi

EXCLUDED_FILES_TXT=excluded-files.txt
BACKUP_FILES=/mnt/

DISTRO=arch
TYPE=full
DATE=$(date +%F)
DESTFILE=$DISTRO-$TYPE-$DATE.tar.gz

if [ ! -e $EXCLUDED_FILES_TXT ]; then
    echo "Excluded-files.txt not found, abort"
    exit 1
fi

read -p "Backup $BACKUP_FILES to $DEST/$DESTFILE ? (y/N) " FLAG
if [ ! $FLAG ] || [ $FLAG != "y" ]; then
    echo "Abort"
    exit 1
fi

# --preserve-permissions = -p
# --xattrs => extended attributes

tar --xattrs --preserve-permissions --exclude-from=$EXCLUDED_FILES_TXT -czvf - $BACKUP_FILES | pv > $DEST/$DESTFILE
