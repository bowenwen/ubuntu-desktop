#!/bin/bash

FORCE=$1
if [ $(docker ps | grep unhealthy -c) != 0 ] || [ "$FORCE" = "force" ]; then
    if [ -n "$DOCKER_COMPOSE_DIR" ]; then
        echo "Restarting unhealthy vpn app..."
        cd $DOCKER_COMPOSE_DIR
        docker-compose down
        sleep 5
        docker-compose pull
        sleep 5
        docker-compose up -d
    fi
else
    echo "Looking good, doing nothing..."
fi
