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

    # complexity user - rename only
    $FILEBROWSER users add complexity 'complexitytrailer' \
        --database $DB \
        --perm.rename \
        2>/dev/null || $FILEBROWSER users update complexity \
        --password 'complexitytrailer' \
        --database $DB \
        --perm.rename
"

# configure rename hook (triggers when complexity renames files)
# su -s /bin/sh supernova -c "
#     $FILEBROWSER config set \
#         --database $DB \
#         commands.after_rename \
#         'sh -c \"echo this filename has been renamed: \$FILE\"'
# "

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

# Read Apache environment details & execute the web engine safely in background
. /etc/apache2/envvars
apache2 -D FOREGROUND &

# IMPORTANT: keep container alive
tail -f /dev/null