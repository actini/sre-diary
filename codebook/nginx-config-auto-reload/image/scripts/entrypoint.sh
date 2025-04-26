#!/bin/sh

export INTERVAL=10
export CONFIGMAP="nginx-conf"
export TEMP_FOLDER="/tmp/nginx/conf.d"
export CONFIG_FOLDER="/etc/nginx/conf.d"

mkdir -p $TEMP_FOLDER

/app/scripts/refresh_config.sh &
/app/scripts/reload_config.sh &

exec "$@"
