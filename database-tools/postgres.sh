DATETIME=$(date +'%d-%m-%Y_%H_%M_%S')
TYPE="backup"
DATABASE="postgres"
DUMPHOST="localhost"
DUMPPORT="5432"
DOCKERCONTAINER=""
USERNAME="postgres"
INPUTFILE=""
OUTFOLDER=`pwd`"/backups/postgres"
ZIPFILE="NO"
OUTFILENAME=""

function help(){
        echo "  Postgres Parameter "
        echo "-t | --type | type action | ex: backup / restore | default: backup"
        echo "-d | --database | database name | ex: postgres | default: postgres"
        echo "--host | database host | ex: localhost / docker | default: localhost"
        echo "-u | --user | database user | ex: postgres | default: 'postgres'"
        echo "-p | --port | database port | ex: 5432 | default: 5432"
        echo "-c | --container | container | ex: docker_compose_1 | default: compose_2_postgresdb_1"
        echo "-i | --input | backup file | ex: file.bak | default: ''"
        echo "-o | --outfile | output file name | ex: backup_postgres.sql"
        echo "-f | --folder | output folder | ex: ./backup | default: '`pwd`/backup'"
        echo "-z | --zip | zip package"
        echo "-h | --help | help"
}

while [[ "$#" -gt 0 ]]; do case $1 in
  -t|--type) TYPE="$2"; shift;;
  -d|--database) DATABASE="$2"; shift;;
  --host) DUMPHOST="$2"; shift;;
  -u|--user) USERNAME="$2"; shift;;
  -p|--port) DUMPPORT="$2"; shift;;
  -c|--container) DOCKERCONTAINER="$2"; shift;;
  -i|--input) INPUTFILE="$2"; shift;;
  -o|--outfile) OUTFILENAME="$2"; shift;;
  -f|--folder) OUTFOLDER="$2"; shift;;
  -z|--zip) ZIPFILE="YES"; shift;;
  -h|--help) help && exit ; shift;;
  *) echo "Unknown parameter passed: $1"; exit 1;;
esac; shift; done
#[ ! ${TYPE} == "backup" ] && [ ! ${TYPE} == "restore" ] && echo "--type [backup / restore]" && exit 1

function initDumpPostgres(){
        [ -z ${OUTFILENAME} ] && OUTFILENAME="PG_${USERNAME}_${DATABASE}_${DATETIME}.sql"
        [ ${ZIPFILE} == "YES" ] && OUTFILENAME="${OUTFILENAME}.gz"
        [ ! -d ${OUTFOLDER} ] && mkdir -p ${OUTFOLDER} && echo "Success create Out Folder : ${OUTFOLDER}"
        OUTFILE=$OUTFOLDER"/"$OUTFILENAME

        echo "=====BACKUP-POSTGRES-CONFIG====";
        echo "DATABASE : ${DATABASE}";
        echo "HOST : ${DUMPHOST}";
        echo "PORT : ${DUMPPORT}";
        echo "USERNAME : ${USERNAME}";
        echo "OUT FILE : ${OUTFILE}";
        echo "ZIP : ${ZIPFILE}";
        [ ! ${DOCKERCONTAINER} == "" ] && echo "DOCKER CONTAINER : ${DOCKERCONTAINER}";
}

function dumpPostgres(){
        echo "=====Initializing=====" && initDumpPostgres && echo "Initialization done";
        echo "=====START-BACKUP=====";
        CMD="pg_dump "
        #[ ${ZIPFILE} == "YES" ] && CMD="$CMD -Fc"
        [ ${USERNAME} ] && CMD="$CMD -U $USERNAME"
        [ ${DUMPHOST} ] && CMD="$CMD -h $DUMPHOST"
        [ ${DUMPPORT} ] && CMD="$CMD -p $DUMPPORT"
        [ ${DATABASE} ] && CMD="$CMD -d $DATABASE"

        [ ! ${DOCKERCONTAINER} == "" ] && CMD="docker exec -it $DOCKERCONTAINER $CMD"
        [ $ZIPFILE == "YES" ] && CMD="$CMD | gzip"
        CMD="${CMD} > ${OUTFILE}"
        echo "Backing Up..."
        echo $CMD
        eval "$CMD" && echo "Success Backup" && du -lsh ${OUTFILE} || echo "Backup Fail"
        #du -lsh $OUTFILE
}

function initRestPostgres(){
        [ -z ${INPUTFILE} ] && echo "folder path: ${OUTFOLDER}"  && echo "choose backup file below:" && ls -ltrh ${OUTFOLDER} | tail -n '10' && echo "--input filename" && exit 1
        [ ${ZIPFILE} == "YES" ] && OLDINPUTFILE=${INPUTFILE} &&  INPUTFILE=$(basename "$INPUTFILE" ".gz") && eval "gunzip ${OUTFOLDER}/${OLDINPUTFILE} -c > ${OUTFOLDER}/${INPUTFILE}" && echo "Unzip done"
}

function restPostgres(){
        echo "=====Initializing=====" && initRestPostgres && echo "Initialization done";
        echo "=====START-RESTORE=====";
        CMD="psql"
        [ ${USERNAME} ] && CMD="$CMD -U $USERNAME"
        [ ${DUMPHOST} ] && CMD="$CMD -h $DUMPHOST"
        [ ${DUMPPORT} ] && CMD="$CMD -p $DUMPPORT"
        [ ${DATABASE} ] && CMD="$CMD -d $DATABASE"

        [ ! ${DOCKERCONTAINER} == "" ] && CMD="docker exec -i $DOCKERCONTAINER $CMD"
        CMD="cat ${OUTFOLDER}/${INPUTFILE} | ${CMD}"
        echo "Restoring..."
        echo $CMD
        eval "$CMD" && echo "Success restore" || echo "Restore Failed"
        #du -lsh $OUTFILE
        [ $ZIPFILE == "YES" ] && echo "Cleaning..." && rm ${OUTFOLDER}/${INPUTFILE}
}

function main(){
        if [ ${TYPE} == "backup" ]; then
                dumpPostgres
        elif [ ${TYPE} == "restore" ]; then
                restPostgres
        else
                echo "--type [backup / restore]" && exit 1
        fi
        echo "===DONE==="
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
