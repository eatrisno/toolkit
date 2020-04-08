_now=$(date +"%m-%d-%Y_%H:%M:%S")
DIR="/usr/local/opt"
BIN_DIR="/usr/local/bin"

PROJECT="altoshift/common-tools"
PROJECT_DIR="${DIR}/${PROJECT}"


APP_NAME="alto"
APP="${PROJECT_DIR}/${APP_NAME}"
APP_CONFIG="${PROJECT_DIR}/server.list"

mkdir -p "${PROJECT_DIR}"

#url name replace setSymlink

APP_REPO=(
        "https://altoshift.com/installer/common-tools/app.sh		alto"
        "hsttps://altoshift.com/installer/common-tools/server.list	server.list"
)


printf "Downloading.."
for row in "${APP_REPO[@]}"; do
    printf "..."
    url=$(echo $row | awk 'END {print $1}')
    dst=$(echo $row | awk 'END {print $2}')
    RESP=$(curl -sk --fail --url ${url} --output ${PROJECT_DIR}/${dst})
    if ! $RESP ; then
        echo "Download Failed" && exit 1;
    fi
done
echo ""

echo "Setting up.."

sed -i -e "s#_CONFIG_#${APP_CONFIG}#" ${APP}

chmod u+x ${APP}

ln -sf ${APP} ${BIN_DIR}/${APP_NAME}

echo "Before use this app:"
echo ""
echo "1. you need to configure ${BIN_DIR}/${CONFIG_FILE}"
echo ""
echo "nano ${APP_CONFIG}"
echo ""
echo "example :"
echo "._______________________________________________________________________."
echo "| demo      demo.altoshift.com    ubuntu   ~/.ssh/New-Altoshift-Dev.pem |"
echo "| sortcut   host                  user     key                          |"
echo "|_______________________________________________________________________|"
echo ""
echo "*How to use :"
echo "##############################"
echo "#   ${APP_NAME} host_name"
echo "##############################"
echo ""
echo "Enjoy :)"

