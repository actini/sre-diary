#! /bin/sh

# Watching configuration files and reload if changed
inotifywait -m -r -e close_write -e move ${CONFIG_FOLDER}/ | while read changes; do
    echo "$changes"

    nginx -t

    if [ $? -ne 0 ]
    then
        echo "[$(date)] ERROR: Bad syntax"
        continue
    fi

    nginx -s reload
    echo "[$(date)] Nginx configuration reloaded"
done
