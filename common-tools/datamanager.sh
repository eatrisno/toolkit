DATETIME=$(date +'%d-%m-%Y_%H_%M_%S')
S3KEY=""
S3SECRET=""
S3BUCKET=""
S3PATH=""
FOLDER=`pwd`"/backups/"
FILE=""

function help(){
	echo "	Backup Mongo Parameter
	-i | --input | filename
	-k | --key | S3 Key | ex: abcd
	-s | --secret | S3 Secret | ex: abcd
	-b | --bucket | S3 Bucket | ex: abcd
	-f | --folder | backup folder
	-h | --help | help"
}

while [[ "$#" -gt 0 ]]; do case $1 in
  -i|--input) FILE="$2"; shift;;
  -k|--key) S3KEY="$2"; shift;;
  -s|--key) S3SECRET="$2"; shift;;
  -b|--bucket) S3BUCKET="$2"; shift;;
  -f|--folder) FOLDER="$2"; shift;;
  -h|--help) help && exit ; shift;;
  *) echo "Unknown parameter passed: $1"; exit 1;;
esac; shift; done

function putS3
{
  resource="/${S3BUCKET}/${FILE}"
  contentType="application/x-compressed-tar"
  dateValue=`date -R`
  stringToSign="PUT\n\n${contentType}\n${dateValue}\n${resource}"
  signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${S3SECRET} -binary | base64`
  curl -X PUT -T "${FILE}" \
    -H "Host: ${S3BUCKET}.s3.amazonaws.com" \
    -H "Date: ${dateValue}" \
    -H "Content-Type: ${contentType}" \
    -H "Authorization: AWS ${S3KEY}:${signature}" \
    https://${S3BUCKET}.s3-ap-southeast-1.amazonaws.com/${FILE}

}

function main(){
	putS3
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
