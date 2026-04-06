#!/usr/bin/env bash
# Sobe Postgres, Redis, Mailhog, prepara a BD, (opcional) seed e inicia Rails + Sidekiq + Vite.
# Depois abra no browser: http://localhost:3000
#
# Login após db:seed (desenvolvimento): john@acme.inc / Password1!
#
# Portainer: use o mesmo docker-compose.yaml; defina .env (ou variáveis) com POSTGRES_DATABASE=chatwoot
# e SECRET_KEY_BASE válido; no container rails, uma vez: bundle exec rails db:prepare && bundle exec rails db:seed

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

if ! command -v docker >/dev/null 2>&1; then
  echo "Erro: o comando 'docker' não foi encontrado. Instale o Docker Engine e o plugin Compose, depois execute de novo."
  exit 1
fi

COMPOSE=(docker compose)
if ! docker compose version >/dev/null 2>&1; then
  if command -v docker-compose >/dev/null 2>&1; then
    COMPOSE=(docker-compose)
  else
    echo "Erro: precisa de 'docker compose' ou 'docker-compose'."
    exit 1
  fi
fi

"$ROOT/docker/scripts/prepare-env-for-docker-dev.sh"

echo ">>> A subir Postgres, Redis e Mailhog..."
"${COMPOSE[@]}" up --build -d postgres redis mailhog

echo ">>> A aguardar Postgres..."
until "${COMPOSE[@]}" exec -T postgres pg_isready -U postgres >/dev/null 2>&1; do
  sleep 2
done

echo ">>> db:prepare (cria BD, schema e migrations)..."
# Imagem rails: entrypoint espera Postgres e corre bundle install
"${COMPOSE[@]}" run --rm --no-deps rails bundle exec rails db:prepare

echo ">>> db:seed (ignora erro se já tiver sido executado antes)..."
set +e
"${COMPOSE[@]}" run --rm --no-deps rails bundle exec rails db:seed
SEED_EXIT=$?
set -e
if [[ "$SEED_EXIT" -ne 0 ]]; then
  echo ">>> Aviso: db:seed terminou com código $SEED_EXIT (normal se os dados já existirem)."
fi

echo ">>> A iniciar Rails (3000), Sidekiq e Vite (3036). Ctrl+C para parar."
echo ">>> Abra: http://localhost:3000"
"${COMPOSE[@]}" up --build rails sidekiq vite postgres redis mailhog
