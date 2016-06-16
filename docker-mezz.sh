#!/bin/bash
# Script to manage docker container with Mezzanine server. Used as a sample app

if [[ $# < 1 ]]; then
    echo "Usage:: $0 [run|start|stop|rm|rmf|logs|list|psql|createdb|runserver|bash]"
    exit
fi
ENV="$DOCKER_PG_ENV"
if [ -z "$ENV" ]; then
    ENV="-e POSTGRES_DB=vhtest_db -e POSTGRES_USER=vhtest_user -e POSTGRES_PASSWORD=vhtest_pass"
fi

VOL=""
if [ ! -z "$PGDATA_DIR" ]; then
    VOL="-v $PGDATA_DIR:/var/lib/postgresql/data"
fi
if [ ! -z "$STATIC_DIR" ]; then
    VOL="$VOL -v $STATIC_DIR:/myproject/static"
fi
case $1 in
    run)
    docker run --name mezz-server -d $ENV $VOL -p 80:8000 pankajku/mezzanine
    ;;
    logs)
    docker logs mezz-server
    ;;
    start)
    docker start mezz-server
    ;;
    stop)
    docker stop mezz-server
    ;;
    rm)
    docker rm mezz-server
    ;;
    rmf)
    docker rm -f mezz-server
    ;;
    psql)
    docker exec -it mezz-server /usr/bin/psql -U vhtest_user vhtest_db
    ;;
    bash)
    docker exec -it mezz-server /bin/bash
    ;;
    runserver)
    docker exec -it mezz-server /bin/bash runserver.sh
    ;;
    createdb)
    docker exec -it mezz-server /bin/bash createdb.sh
    ;;
    list)
    docker ps -a | grep mezz-server
    ;;
    *)
    echo "Unknown command: $1"
    echo "Usage:: $0 [run|start|stop|rm|rmf|logs|list|psql|createdb|runserver|bash]"
    ;;
esac
