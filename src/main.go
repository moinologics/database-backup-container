package main

import (
	"context"
	"flag"
	"fmt"
	"log"
	"net/url"
	"os"
	"path/filepath"
	"slices"

	"github.com/dustin/go-humanize"
	"github.com/minio/minio-go/v7"
	"github.com/minio/minio-go/v7/pkg/credentials"
)

func args() (string, string, string, string, string, string) {
	endpoint := flag.String("endpoint", "", "s3 endpoint")
	accessKeyID := flag.String("accessKeyID", "", "s3 accessKeyID")
	secretAccessKey := flag.String("secretAccessKey", "", "s3 secretAccessKey")
	bucketName := flag.String("bucketName", "", "s3 bucketName")
	filePath := flag.String("filePath", "", "filePath of upload targeted file")
	contentType := flag.String("contentType", "", "contentType of upload targeted file")
	flag.Parse()
	return *endpoint, *accessKeyID, *secretAccessKey, *bucketName, *filePath, *contentType
}

func createMinioClient(endpoint string, accessKeyID string, secretAccessKey string) (*minio.Client, error) {

	endpointURL, err := url.Parse(endpoint)

	if err != nil || !slices.Contains([]string{"https", "http"}, endpointURL.Scheme) {
		log.Fatalf("invalid endpoint %s", endpoint)
	}

	return minio.New(endpointURL.Host, &minio.Options{
		Creds:  credentials.NewStaticV4(accessKeyID, secretAccessKey, ""),
		Secure: endpointURL.Scheme == "https",
	})
}

func main() {
	ctx := context.Background()

	endpoint, accessKeyID, secretAccessKey, bucketName, filePath, contentType := args()

	minioClient, err := createMinioClient(endpoint, accessKeyID, secretAccessKey)

	if err != nil {
		log.Fatalln(err)
	}

	exists, err := minioClient.BucketExists(ctx, bucketName)

	if err != nil {
		log.Fatalln(err)
	}

	if !exists {
		log.Fatalf("bucket %s not exists", bucketName)
	}

	file, err := os.Open(filePath)

	if err != nil {
		log.Fatalln(err)
	}
	defer file.Close()

	fileStat, err := file.Stat()
	if err != nil {
		log.Fatalln(err)
	}

	objectName := filepath.Base(filePath)

	info, err := minioClient.PutObject(ctx, bucketName, objectName, file, fileStat.Size(), minio.PutObjectOptions{ContentType: contentType})

	if err != nil {
		log.Fatalln(err)
	}

	fmt.Printf("uploaded %s of size %s\n", objectName, humanize.IBytes(uint64(info.Size)))
}
