#!/usr/bin/env bash
# Prepara o ficheiro .env para desenvolvimento com docker-compose (Postgres do compose usa DB "chatwoot").
# Executa a partir da raiz do repositório ou de qualquer pasta (o script localiza a raiz).

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

if [[ ! -f .env ]]; then
  echo ">>> Criando .env a partir de .env.example"
  cp .env.example .env
fi

if grep -q 'replace_with_lengthy_secure_hex' .env; then
  KEY="$(openssl rand -hex 64)"
  # Linux e macOS (BSD sed)
  if sed --version >/dev/null 2>&1; then
    sed -i "s/SECRET_KEY_BASE=replace_with_lengthy_secure_hex/SECRET_KEY_BASE=${KEY}/" .env
  else
    sed -i '' "s/SECRET_KEY_BASE=replace_with_lengthy_secure_hex/SECRET_KEY_BASE=${KEY}/" .env
  fi
  echo ">>> SECRET_KEY_BASE definido"
fi

if ! grep -q '^POSTGRES_DATABASE=' .env; then
  echo '' >> .env
  echo '# Alinhado com POSTGRES_DB do serviço postgres em docker-compose.yaml' >> .env
  echo 'POSTGRES_DATABASE=chatwoot' >> .env
  echo ">>> POSTGRES_DATABASE=chatwoot adicionado ao .env"
fi

# URL que o browser no host usa (ajuste se expuser outra porta/host)
if grep -q '^FRONTEND_URL=' .env; then
  if sed --version >/dev/null 2>&1; then
    sed -i 's|^FRONTEND_URL=.*|FRONTEND_URL=http://localhost:3000|' .env
  else
    sed -i '' 's|^FRONTEND_URL=.*|FRONTEND_URL=http://localhost:3000|' .env
  fi
else
  echo 'FRONTEND_URL=http://localhost:3000' >> .env
fi

# Mailhog no compose
if grep -q '^SMTP_ADDRESS=$' .env; then
  if sed --version >/dev/null 2>&1; then
    sed -i 's/^SMTP_ADDRESS=$/SMTP_ADDRESS=mailhog/' .env
  else
    sed -i '' 's/^SMTP_ADDRESS=$/SMTP_ADDRESS=mailhog/' .env
  fi
fi

echo ">>> .env pronto para docker-compose (raiz: $ROOT)"
