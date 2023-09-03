FROM golang:1.21.0-alpine as builder

RUN apk add --no-cache mongodb-tools mariadb-client postgresql14-client

RUN mkdir /targeted-bin

RUN for file in /usr/bin/mongodump /usr/bin/mysqldump /usr/bin/pg_dump /usr/bin/pg_dumpall; do cp "$file" /targeted-bin/; done

COPY src src

RUN cd src && go build -o /targeted-bin/s3-uploader -ldflags="-w -s" -gcflags=all=-l


FROM alpine:3.18

WORKDIR /usr/bin

COPY --from=builder /targeted-bin /usr/bin

RUN apk add --no-cache rsyslog-gssapi libpq-dev

COPY backup.sh .

RUN chmod 777 backup.sh

ENV STORAGE=filesystem

ENV S3_ENDPOINT=""
ENV S3_ACCESS_KEY_ID=""
ENV S3_SECRET_ACCESS_KEY=""
ENV S3_BUCKET=""

ENV DB_TYPE=mongodb
ENV MONGODB_URI=""

VOLUME [ "/backup" ]

CMD [ "./backup.sh" ]