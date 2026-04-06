#!/usr/bin/env bash
# Sobe a stack em docker/docker-compose.stack.yml (valores já no YAML; .env.stack é opcional).
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$DIR"
echo ">>> A subir stack em $DIR"
if [[ -f .env.stack ]]; then
  docker compose --env-file .env.stack -f docker-compose.stack.yml up -d
else
  docker compose -f docker-compose.stack.yml up -d
fi
echo ">>> https://chat.penhacontabilidade.com.br (FRONTEND_URL no compose)"
echo ">>> Primeira vez: ./docker/scripts/stack-db-prepare.sh"
