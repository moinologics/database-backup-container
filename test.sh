#!/bin/sh

# docker run --rm --name "database-backup" \
# 	-e STORAGE=s3 \
#   -e S3_ENDPOINT=https://axtomllnh4ge.compat.objectstorage.ap-hyderabad-1.oci.customer-oci.com \
#   -e S3_ACCESS_KEY_ID=cf70907c8b558fb959cfb43f2d3dbddcfa7488af \
#   -e S3_SECRET_ACCESS_KEY=i/nSAui0EC2nhnpqar4VvF0UhZBKsMyEjSGG8DGNVs4= \
#   -e S3_BUCKET=oracle-bucket-0 \
# 	-e DB_TYPE=mongodb \
# 	-e MONGODB_URI=mongodb://host.docker.internal:27017 \
# 	moinologics/database-backup:latest

docker run --rm --name "database-backup" \
	-e STORAGE=s3 \
  -e S3_ENDPOINT=https://gateway.storjshare.io \
  -e S3_ACCESS_KEY_ID=jxh5dsg6azdc3i57ajswngogs5ha \
  -e S3_SECRET_ACCESS_KEY=jzw2lo2xbvpuhatez7ysdbqgc724prjug6k72bu7uprybq4nak47y \
  -e S3_BUCKET=postgresql \
	-e DB_TYPE=mongodb \
	-e MONGODB_URI=mongodb://host.docker.internal:27017 \
	moinologics/database-backup:latest

# docker run --rm --name "database-backup" \
# 	-e STORAGE=filesystem \
# 	-e DB_TYPE=mongodb \
# 	-e MONGODB_URI=mongodb://host.docker.internal:27017 \
# 	-v $(pwd)/backup:/backup \
# 	moinologics/database-backup:latest
