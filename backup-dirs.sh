#!/bin/bash

DIRS="$1"
GDRIVE_DIR_ID="$2"

if [ -z $DIRS ] || [ -z $GDRIVE_DIR_ID ] ; then
    echo "Usage: $0 dir1,dir2,...,dirN gdrive_dir_id"
    exit 1
fi

dirarray=$(echo $DIRS | tr "," "\n")
for dir in $dirarray
do
    if [ ! -d $dir ]; then
        echo "ERROR: folder $folder does not exist"
    else
	echo "Compressing folder $dir..."
        dirbackupfile=$(basename $dir)_`date +%Y-%m-%d-%H-%M-%S`.tgz
	tar -cvzf $dirbackupfile --directory="$dir" . > /dev/null

	echo "Uploading $dirbackupfile to Google Drive..."
        php google_drive_uploader.php $dirbackupfile  $GDRIVE_DIR_ID

	echo "Cleaning up..."
	rm $dirbackupfile
    fi
done
