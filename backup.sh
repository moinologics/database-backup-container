#!/bin/sh

mongodb_backup() {
	mongodump --quiet --uri=$MONGODB_URI --gzip --archive=$TMP_BACKUP_FILE_PATH
}

postgresql_backup() {
	PGPASSWORD=$POSTGRESQL_PASSWORD pg_dumpall -d $POSTGRESQL_URI | gzip > $TMP_BACKUP_FILE_PATH
}

upload_to_s3() {
	echo "Uploading Backup file to S3"
	s3-uploader \
		-endpoint=$S3_ENDPOINT \
		-accessKeyID=$S3_ACCESS_KEY_ID \
		-secretAccessKey=$S3_SECRET_ACCESS_KEY \
		-bucketName=$S3_BUCKET \
		-filePath=$TMP_BACKUP_FILE_PATH \
		-contentType=$CONTENT_TYPE
}

save_to_volume() {
	mkdir -p $(dirname $BACKUP_FILE_PATH)
	cp $TMP_BACKUP_FILE_PATH $BACKUP_FILE_PATH
	echo "Backup saved to file $BACKUP_FILE_PATH"
}

TMP_BACKUP_FILE_PATH=/tmp/backup-latest.gz
BACKUP_FILE_PATH=/backup/$DB_TYPE/backup-latest.gz
CONTENT_TYPE=application/gz

echo "making Backup quietly..."

case $DB_TYPE in
  mongodb)
    mongodb_backup
    ;;
  mysql)
    echo "DB_TYPE $DB_TYPE not implemented yet"; exit 128;
    ;;
  postgresql)
    postgresql_backup
    ;;
	mariadb)
    echo "DB_TYPE $DB_TYPE not implemented yet"; exit 128;
    ;;
  *)
    echo "invalid DB_TYPE $DB_TYPE"; exit 128;
    ;;
esac

case $STORAGE in
  filesystem)
		save_to_volume
    ;;
  s3)
		upload_to_s3
    ;;
  *)
    echo "invalid STORAGE $STORAGE"; exit 128;
    ;;
esac

echo "backup done successfully"