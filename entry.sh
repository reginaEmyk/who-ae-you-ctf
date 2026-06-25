#!/bin/sh
set -e

DB=/srv/filebrowser.db

# init ONLY if missing
if [ ! -f "$DB" ]; then
    filebrowser config init \
        --database "$DB" \  
        --key="hooks.after_rename" \
        --value='sh -c "echo this filename has been renamed: $FILE"'
        --root /srv/files

    filebrowser users add armageddon armageddonarmageddon \
        --database "$DB" \
        --perm.admin
# TODO this user can ONLY RENAME files and NOTHING ELSE 
    filebrowser users add complexity complexitytrailer \
        --database "$DB"
    
    # Restrict complexity to ONLY rename
    filebrowser users update 2 --perm.create=false --perm.modify=false --perm.delete=false --perm.share=false --perm.download=false --perm.execute=false
    
    # Set the hook for CVE-2026-35585
    # keep this here for documentation purposes, but it is not working as expected: do it manually 
    # filebrowser config set --database /filebrowser.db --key="hooks.after_rename" --value="sh -c "echo this filename has been renamed: \$FILE""
fi


#
# START FTP (aespa user access)
#
vsftpd /etc/vsftpd/vsftpd.conf &

#
# START FILEBROWSER (supernova web layer)
#
# IMPORTANT: no CLI DB access after this point

exec filebrowser \
    --address 0.0.0.0 \
    --port 80 \
    --root /srv/files \
    --disable-exec=false \
    --database "$DB"
