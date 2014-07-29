#!/bin/bash

DIRS="$1"
GDRIVE_DIR_ID="$2"

if [ -z $DIRS ] || [ -z $GDRIVE_DIR_ID ] ; then
    echo "Usage: "$0"dir1,dir2,...,dirN gdrive_dir_id"
    exit 1
fi

dirarray=$(echo $DIRS | tr "," "\n")
for dir in $dirarray
do
    if [ ! -d $dir ]; then
        echo "ERROR: folder does not exist"
    else
        dirbackupfile=$(basename $dir)_`date +%Y-%m-%d-%H-%M-%S`.tgz
	tar -cvzf $dirbackupfile --directory="$dir" .
        php google_drive_uploader.php $dirbackupfile  $GDRIVE_DIR_ID
	rm $dirbackupfile
    fi
done
