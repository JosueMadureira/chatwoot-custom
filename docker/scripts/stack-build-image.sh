#!/usr/bin/env bash
# Constrói a imagem com o código atual (inclui as tuas alterações) — tag igual à stack de produção.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"
echo ">>> A construir localhost/chatwoot-custom:latest (contexto: $ROOT)"
docker build -t localhost/chatwoot-custom:latest -f docker/Dockerfile .
