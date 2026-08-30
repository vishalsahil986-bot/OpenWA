#!/usr/bin/env bash

set -e

echo "Starting OpenWA Codespaces setup..."

if [ -z "$OPENWA_API_MASTER_KEY" ]; then
  echo "ERROR: OPENWA_API_MASTER_KEY Codespaces secret is missing."
  echo "Create it in GitHub: Settings > Secrets and variables > Codespaces."
  exit 1
fi

if [ ${#OPENWA_API_MASTER_KEY} -lt 32 ]; then
  echo "ERROR: OPENWA_API_MASTER_KEY must be at least 32 characters."
  exit 1
fi

PUBLIC_URL="https://${CODESPACE_NAME}-2785.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}"

mkdir -p data

cat > .env <<EOF
NODE_ENV=production
BIND_HOST=0.0.0.0

ENGINE_TYPE=baileys
AUTO_START_SESSIONS=true

DATABASE_TYPE=sqlite
DATABASE_SYNCHRONIZE=true

SERVE_DASHBOARD=true

API_MASTER_KEY=${OPENWA_API_MASTER_KEY}
ALLOW_DEV_API_KEY=false
ENABLE_SWAGGER=false

BASE_URL=${PUBLIC_URL}
DASHBOARD_URL=${PUBLIC_URL}
CORS_ORIGINS=${PUBLIC_URL}

LOG_LEVEL=info
EOF

echo ""
echo "OpenWA public URL:"
echo "$PUBLIC_URL"
echo ""

docker compose -f docker-compose.dev.yml up -d --build

echo ""
echo "Waiting for OpenWA to start..."

for i in {1..60}; do
  if curl -fsS http://localhost:2785/api/health/ready >/dev/null 2>&1; then
    echo ""
    echo "OpenWA is ready."
    echo "Dashboard: $PUBLIC_URL"
    echo ""
    docker compose -f docker-compose.dev.yml ps
    exit 0
  fi

  sleep 5
done

echo ""
echo "OpenWA did not become ready in time."
echo "Showing container logs:"
docker compose -f docker-compose.dev.yml logs --tail=100

exit 1
