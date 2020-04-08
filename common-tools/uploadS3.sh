#maintainer: eko@altoshift.com | eaprilitrisno@gmail.com

DATETIME=$(date +'%d-%m-%Y_%H_%M_%S')
S3KEY=""
S3SECRET=""
S3BUCKET=""
S3REGION="ap-southeast-1"
S3PATH=""
FOLDER=`pwd`"/backups/"
INPUT=""

function help(){
	echo "	Backup Mongo Parameter
	-i | --input | file / folder name
	-k | --s3key | S3 Key | ex: abcd
	-s | --s3secret | S3 Secret | ex: abcd
        -r | --s3region | ap-southeast-1
	-p | --s3path | S3 Path
	-b | --s3bucket | S3 Bucket | ex: abcd
	-h | --help | help"
}

while [[ "$#" -gt 0 ]]; do case $1 in
  -i|--input) INPUT="$2"; shift;;
  -k|--s3key) S3KEY="$2"; shift;;
  -s|--s3key) S3SECRET="$2"; shift;;
  -r|--s3region) S3REGION="$2"; shift;;
  -b|--s3bucket) S3BUCKET="$2"; shift;;
  -p|--s3path) S3PATH="$2"; shift;;
  -h|--help) help && exit ; shift;;
  *) echo "Unknown parameter passed: $1"; exit 1;;
esac; shift; done

function putS3(){
  _file=$1
  _folder=$2
  resource="/${S3BUCKET}${S3PATH}/${_file}"
  contentType="application/x-compressed-tar"
  dateValue=`date -R`
  stringToSign="PUT\n\n${contentType}\n${dateValue}\n${resource}"
  signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${S3SECRET} -binary | base64`
  curl --fail -s -X PUT -T "${_folder}/${_file}" \
    -H "Host: ${S3BUCKET}.s3.amazonaws.com" \
    -H "Date: ${dateValue}" \
    -H "Content-Type: ${contentType}" \
    -H "Authorization: AWS ${S3KEY}:${signature}" \
    https://${S3BUCKET}.s3-${S3REGION}.amazonaws.com${S3PATH}/${_file}

}

function main(){
	printf "Uploading.."
	for file in $(find ${INPUT} -mindepth 1 -type f -printf '%P\n'); do
		printf ".."
		RESP=$(putS3 $file ${INPUT})
	done
	echo "===Done==="
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
