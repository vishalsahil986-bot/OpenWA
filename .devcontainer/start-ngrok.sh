#!/usr/bin/env bash

set -e

if ! command -v ngrok >/dev/null 2>&1; then
  echo "ngrok not found. Installing..."

  curl -fsSL https://bin.ngrok.com/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz \
    -o /tmp/ngrok.tgz

  tar -xzf /tmp/ngrok.tgz -C /tmp

  sudo mv /tmp/ngrok /usr/local/bin/ngrok

  rm -f /tmp/ngrok.tgz

  echo "ngrok installed."
fi

if [ -z "$NGROK_AUTHTOKEN" ]; then
  echo "NGROK_AUTHTOKEN is missing."
  exit 1
fi

ngrok config add-authtoken "$NGROK_AUTHTOKEN" >/dev/null

if pgrep -f "ngrok http 2785" >/dev/null; then
  echo "ngrok tunnel already running."
  exit 0
fi

echo "Starting ngrok tunnel..."

nohup ngrok http 2785 > /tmp/openwa-ngrok.log 2>&1 &

echo $! > /tmp/openwa-ngrok.pid

sleep 8

cat /tmp/openwa-ngrok.log
