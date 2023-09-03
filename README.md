# database-backup-container

#### how to run the s3 backup

```
docker run --rm --name "database-backup" \
  -e STORAGE=s3 \
  -e S3_ENDPOINT=https://xxxxxyyyxx.compat.objectstorage.ap-hyderabad-1.oci.customer-oci.com \
  -e S3_ACCESS_KEY_ID=xxxxxxxxxxxx \
  -e S3_SECRET_ACCESS_KEY=xxxxxxxxx \
  -e S3_BUCKET=my-s3-bucket \
  -e DB_TYPE=mongodb \
  -e MONGODB_URI=mongodb://host:port \
  moinologics/database-backup:latest
```

#### how to run the local backup

```
docker run --rm --name "database-backup" \
  -e STORAGE=filesystem \
  -v $(pwd)/backup:/backup \
  -e DB_TYPE=mongodb \
  -e MONGODB_URI=mongodb://host.docker.internal:27017 \
  moinologics/database-backup:latest
```
