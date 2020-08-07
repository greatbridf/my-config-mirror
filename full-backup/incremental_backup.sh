if [ ! $BACKUP_FILES ]; then
    read -p "Please enter the files to backup " BACKUP_FILES
fi

EXCLUDE_FILE=
if [ -f exclude-file ]; then
    EXCLUDE_FILE="-X exclude-file"
fi

if [ ! -f backup_*_full.tar.gz ]; then
    tar -g tar_snapshot $EXCLUDE_FILE -czpvf backup_$(date +%F)_full.tar.gz -C $BACKUP_FILES .
    exit
fi

read -p "Please type in the backup's id " NUM

cp tar_snapshot tar_snapshot.bak
tar -g tar_snapshot $EXCLUDE_FILE -czpvf backup_$(date +%F)_incremental_$NUM.tar.gz -C $BACKUP_FILES .
