#!/bin/bash

service ssh start
service vsftpd start

exec /opt/venv/bin/python /opt/whoareyou/app/app.py