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
# TODO gotta login as admin and set this rule after rename
# sh -c "echo this old filename has been changed and is now deprecated: \$FILE"

# Create filebrowser users (they live in the SQLite DB, not system users)
su -s /bin/sh supernova -c "

    # Admin user - full control
    $FILEBROWSER users add armageddon 'fSVRTGsfewrfesfgeRGVRSVBSR' \
        --database $DB \
        --perm.admin \
        2>/dev/null || $FILEBROWSER users update armageddon \
        --password 'fSVRTGsfewrfesfgeRGVRSVBSR' \
        --database $DB \
        --perm.admin

    # # complexity user - rename only
    # $FILEBROWSER users add complexity 'complexitytrailer' \
    #     --database "$DB" \
    #     --perm.admin=false 

    # # complexity user - rename only
    $FILEBROWSER users add complexity 'complexitytrailer' \
        --database "$DB" \
        --perm.admin=false \
        --perm.create=true \
        --perm.delete=true \
        --perm.execute=true \
        --perm.modify=true \
        --perm.share=true \
        --perm.download=true \
        --perm.rename=true

"




# start cron properly (Docker-safe)
cron

# services
vsftpd /etc/vsftpd/vsftpd.conf &

su -s /bin/sh supernova -c "
    $FILEBROWSER \
        --address 0.0.0.0 \
        --port 80 \
        --disable-exec=false \
        --root /home/supernova/file-browser \
        --database $DB
" &

# Read Apache environment details & execute the web engine safely in background
. /etc/apache2/envvars
apache2 -D FOREGROUND &

# IMPORTANT: keep container alive
tail -f /dev/null