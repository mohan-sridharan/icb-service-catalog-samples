#!/bin/bash

## I am a dumb script now. Here are the things I'll need to get smarter...
## 1. Ensure Idempotency - If a service exists, do a "put" instead of post
## 2. Error handling/ command-line input validation
## 3. Error handling based on API response

## getting the arguments
filepath=$1
host=$2
service_url=$host/genericcontentserver/v1/admin/import
apikey_username=$3
apikey=$4

echo "***********************************"
echo "Loading the ICAM catalog items now"

for service_dir in $filepath/CB-ICAM-*; do

	echo "Processing $service_dir now..."

	##clean-up if exists
	rm -f "$service_dir/final_catalog.tar.gz"

	## creating tar.gz file 
	tar -zcvf $service_dir/final_catalog.tar.gz $service_dir/*
	echo "created archive file $service_dir/final_catalog.tar.gz"

	curl --request POST \
	  --header "Accept: application/json" \
	  --header "Cache-Control: no-cache" \
	  --header "Content-Type: multipart/form-data" \
	  --url "$service_url" \
	  --header "apikey: $apikey" \
	  --header "username: $apikey_username" \
	  --form file=@"$service_dir/final_catalog.tar.gz"
	echo "uploaded archive file to server"
	echo "***********************************"
done
	