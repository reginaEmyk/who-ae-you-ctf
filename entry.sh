#!/bin/bash

# simple static servers (NO python)
npx serve /app/web -l 80 &
npx serve /app/drama -l 1110 &

# run n8n as supernova ONLY
su - supernova -c "n8n start --port 5678"

wait