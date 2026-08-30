#!/usr/bin/env bash
set -euo pipefail

cd /workspaces/OpenWA

docker compose up -d

if ! pgrep -f "ngrok http.*2785" >/dev/null; then
    nohup ngrok http \
        --domain=unguarded-valid-prankish.ngrok-free.dev \
        2785 \
        > /tmp/ngrok.log 2>&1 &
fi

echo "OpenWA and ngrok startup completed."