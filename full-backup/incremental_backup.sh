if [ ! -f backup_*_full.tar.gz ]; then
    tar -g tar_snapshot -czpvf backup_$(date +%F)_full.tar.gz $BACKUP_FILES
    exit
fi

read -p "Please type in the backup's id " NUM

if [ ! $BACKUP_FILES ]; then
    read -p "Please enter the files to backup " BACKUP_FILES
fi

cp tar_snapshot tar_snapshot.bak
tar -g tar_snapshot -czpvf backup_$(date +%F)_incremental_$NUM.tar.gz $BACKUP_FILES
