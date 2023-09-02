# database-backup-container

#### how to run the backup

```
docker run --rm --name "database-backup" \
  -e S3_ENDPOINT=xxxxxyyyxx.compat.objectstorage.ap-hyderabad-1.oci.customer-oci.com \
  -e S3_ACCESS_KEY_ID=xxxxxxxxxxxx \
  -e S3_SECRET_ACCESS_KEY=xxxxxxxxx \
  -e S3_BUCKET=my-s3-bucket \
  -e S3_SSL=true \
  -e DB_TYPE=mongodb \
  -e MONGODB_URI=mongodb://host:port \
  moinologics/database-backup:latest
```
