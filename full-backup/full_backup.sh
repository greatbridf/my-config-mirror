#!/bin/sh

if [ ! $EUID == 0 ]; then
    echo "please run as root";
    exit 1
fi

echo "full system backup"

read -p "select your backup destination " DEST

echo "DEST = $DEST"

if [ ! -d $DEST ]; then
    echo "backup destination do not exist, abort"
    exit 1
fi

read -p "are you sure to start a backup? (y/N) " FLAG

if [ ! $FLAG ] || [ $FLAG != "y" ]; then
    echo "abort"
    exit 1
fi

EXCLUDED_FILES_TXT=excluded-files.txt
BACKUP_FILES=/mnt/

DISTRO=arch
TYPE=full
DATE=$(date +%F)
DESTFILE=$DISTRO-$TYPE-$DATE.tar.gz

if [ ! -e $EXCLUDED_FILES_TXT ]; then
    echo "excluded-files.txt not found, abort"
    exit 1
fi

read -p "backup $BACKUP_FILES to $DEST/$DESTFILE ? (y/N) " FLAG
if [ ! $FLAG ] || [ $FLAG != "y" ]; then
    echo "abort"
    exit 1
fi

tar --xattrs --exclude-from=$EXCLUDED_FILES_TXT -czpvf - $BACKUP_FILES | pv > $DEST/$DESTFILE
