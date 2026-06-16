#!/bin/bash

# Users

useradd -m -s /bin/bash winter
echo "winter:winter" | chpasswd

useradd -m -s /bin/bash guy
echo "guy:guy" | chpasswd

# Winter can sudo

usermod -aG sudo winter

# Flags

cp /opt/whoareyou/flags/user.txt /home/guy/user.txt
cp /opt/whoareyou/flags/root.txt /root/root.txt

chown guy:guy /home/guy/user.txt

chmod 600 /home/guy/user.txt
chmod 600 /root/root.txt

# FTP

cat > /etc/vsftpd.conf <<EOF
listen=YES
listen_ipv6=NO

anonymous_enable=YES
anon_root=/opt/whoareyou/ftp

local_enable=YES
write_enable=NO

dirmessage_enable=YES
use_localtime=YES

xferlog_enable=YES

connect_from_port_20=YES

secure_chroot_dir=/var/run/vsftpd/empty

pam_service_name=vsftpd
EOF