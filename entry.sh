#!/bin/sh
set -e

DB=/home/supernova/filebrowser.db

if [ ! -f "$DB" ]; then
    su -s /bin/sh supernova -c "
        filebrowser config init \
            --database $DB \
            --root /home/supernova/file-browser
    "

    su -s /bin/sh supernova -c "
        filebrowser users add armageddon armageddonarmageddon \
            --database $DB \
            --perm.admin
    "
# TODO make them able to ONLY rename files, nothing else 
    su -s /bin/sh supernova -c "
        filebrowser users add complexity complexitytrailer \
            --database $DB
    "
fi

vsftpd /etc/vsftpd/vsftpd.conf &

exec su -s /bin/sh supernova -c "
    filebrowser \
        --address 0.0.0.0 \
        --port 80 \
        --root /home/supernova/file-browser \
        --disable-exec=false \
        --database $DB
"