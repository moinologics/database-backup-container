#!/bin/sh

BACKUP_FILE_PATH=/tmp/backup-latest.gz
CONTENT_TYPE=application/gz

echo "making Backup quietly..."

mongodump --quiet --uri=$MONGODB_URI --gzip --archive=$BACKUP_FILE_PATH

echo "Backup saved to file $BACKUP_FILE_PATH"
echo "Uploading Backup file to S3"

s3-uploader \
  -endpoint=$S3_ENDPOINT \
  -accessKeyID=$S3_ACCESS_KEY_ID \
	-secretAccessKey=$S3_SECRET_ACCESS_KEY \
	-bucketName=$S3_BUCKET \
	-useSSL=$S3_SSL \
	-filePath=$BACKUP_FILE_PATH \
	-contentType=$CONTENT_TYPE

if [ $? -eq 0 ]; then
  echo "backup done successfully"
fi