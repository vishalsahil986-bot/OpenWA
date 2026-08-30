#!/usr/bin/env bash

set -e

if ! command -v cloudflared >/dev/null 2>&1; then
  echo "cloudflared not found. Installing..."

  ARCH="$(dpkg --print-architecture)"

  curl -fsSL \
    "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-${ARCH}.deb" \
    -o /tmp/cloudflared.deb

  sudo dpkg -i /tmp/cloudflared.deb

  rm -f /tmp/cloudflared.deb

  echo "cloudflared installed."
fi

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
