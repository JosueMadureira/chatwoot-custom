#!/usr/bin/env bash
# Migrações + seed inicial quando a BD ainda não existe (Chatwoot).
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$DIR"
if [[ -f .env.stack ]]; then
  docker compose --env-file .env.stack -f docker-compose.stack.yml run --rm chatwoot_app bundle exec rails db:chatwoot_prepare
else
  docker compose -f docker-compose.stack.yml run --rm chatwoot_app bundle exec rails db:chatwoot_prepare
fi
