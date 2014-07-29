#!/bin/bash

TMPDIR=tmpsqlfiles

DATABASES="$1"
USER="$2"
PASSWD="$3"
GDRIVE_DIR_ID="$4"

if [ -z $DATABASES ] || [ -z $USER  ] || [ -z $PASSWD ] || [ -z $GDRIVE_DIR_ID ] ; then
    echo "Usage: "$0" db1,db2,...,dbN user passwd gdrive_dir_id"
    exit 1
fi

if [ -d $TMPDIR ]; then
    rm -rf $TMPDIR
fi
mkdir $TMPDIR

dbbackupfile=sql_`date +%Y-%m-%d-%H-%M-%S`.tgz
dbarray=$(echo $DATABASES | tr "," "\n")
for db in $dbarray
do
    mysqldump -u$USER -p$PASSWD --opt $db > $TMPDIR/$db.sql
done

tar -cvzf $dbbackupfile --directory=./$TMPDIR .
php google_drive_uploader.php $dbbackupfile $GDRIVE_DIR_ID

rm -rf $TMPDIR
rm $dbbackupfile
