#!/usr/bin/env bash

while true; do
  echo "$(date) - checking OpenWA"

  if curl -fsS 'http://127.0.0.1:2785/api/health/ready' >/dev/null; then
    echo "OpenWA HEALTHY"
  else
    echo "OpenWA DOWN"
  fi

  sleep 300
done
