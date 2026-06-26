#!/bin/sh
set -e

DB=/home/supernova/filebrowser.db
FILEBROWSER=/home/supernova/bin/filebrowser

# init filebrowser
if [ ! -f "$DB" ]; then
    su -s /bin/sh supernova -c "
        $FILEBROWSER config init \
            --database $DB \
            --root /home/supernova/file-browser
    "
fi

# start cron properly (Docker-safe)
cron

# services
vsftpd /etc/vsftpd/vsftpd.conf &

su -s /bin/sh supernova -c "
    $FILEBROWSER \
        --address 0.0.0.0 \
        --port 80 \
        --root /home/supernova/file-browser \
        --database $DB
" &

# IMPORTANT: keep container alive
tail -f /dev/null