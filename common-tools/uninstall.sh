DIR="/usr/local/opt"
BIN_DIR="/usr/local/bin"

PROJECT="altoshift/common-tools"
PROJECT_DIR="${DIR}/${PROJECT}"

APP_URL="https://altoshift.com/installer/alto.sh"
APP_CONF_URL="https://altoshift.com/installer/server.list"
APP_NAME="alto"
APP_CONFIG="${PROJECT_DIR}/server.list"
APP="${PROJECT_DIR}/${APP_NAME}"

echo "Uninstal ${APP_NAME}..."

rm ${APP}
rm -rf ${BIN_DIR}/${APP_NAME}

echo "Uninstall Done."
