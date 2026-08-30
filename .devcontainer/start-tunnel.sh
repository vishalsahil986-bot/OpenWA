#!/usr/bin/env bash

set -e

if pgrep -f "cloudflared tunnel --url http://localhost:2785" >/dev/null; then
  echo "Cloudflare tunnel already running."
  exit 0
fi

echo "Starting Cloudflare tunnel..."

cloudflared tunnel --url http://localhost:2785 \
  > /tmp/openwa-cloudflared.log 2>&1 &

echo $! > /tmp/openwa-cloudflared.pid

sleep 8

cat /tmp/openwa-cloudflared.log
