WHOAMI=$(whoami)
DIR="/usr/local/opt"
BIN_DIR="/usr/local/bin"

PROJECT="altoshift/database-tools"
PROJECT_DIR="${DIR}/${PROJECT}"

sudo mkdir -p "${PROJECT_DIR}"

APP_REPO=(
        "https://altoshift.com/installer/database-tools/mongo.sh    altomongo	YES"
        "https://altoshift.com/installer/database-tools/postgres.sh       altopostgres	YES"
)

printf "Downloading.."
for row in "${APP_REPO[@]}"; do
    url=$(echo $row | awk 'END {print $1}')
    dst=$(echo $row | awk 'END {print $2}')
    sym=$(echo $row | awk 'END {print $3}')
    printf "..."
    RESP=$(sudo curl -sk --fail --url ${url} --output ${PROJECT_DIR}/${dst})
    if ! $RESP ; then
        echo "Download Failed" && exit 1;
    fi
    [ ${sym} == "YES" ] && eval "sudo chmod u+x ${PROJECT_DIR}/${dst}" && sudo ln -sf ${PROJECT_DIR}/${dst} ${BIN_DIR}/${dst}
    sudo chown ${WHOAMI} ${PROJECT_DIR}/${dst}
done

echo "*How to use :"
echo "##############################"
echo "#   ${APP_NAME} -t backup/restore"
echo "##############################"
echo ""
echo "Enjoy :)"

