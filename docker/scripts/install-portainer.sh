#!/usr/bin/env bash
# Instala o Portainer CE para gerir Docker pela interface web.
# Uso: ./docker/scripts/install-portainer.sh
# Depois: https://IP-DO-SERVIDOR:9443 (HTTPS, certificado próprio)
#         ou http://IP-DO-SERVIDOR:9000 (HTTP, conforme versão)
#
# Se der "permission denied" no docker, corre: newgrp docker
# ou executa este script com: sudo ./docker/scripts/install-portainer.sh

set -euo pipefail

DOCKER=(docker)
if ! docker info >/dev/null 2>&1; then
  if sudo -n docker info >/dev/null 2>&1; then
    DOCKER=(sudo docker)
    echo ">>> A usar sudo para falar com o Docker."
  else
    echo "Erro: não há permissão para usar o Docker."
    echo "Corre: newgrp docker   (ou fecha a sessão SSH e volta a entrar)"
    echo "Ou executa: sudo $0"
    exit 1
  fi
fi

"${DOCKER[@]}" volume create portainer_data 2>/dev/null || true

"${DOCKER[@]}" rm -f portainer 2>/dev/null || true

echo ">>> A descarregar e iniciar Portainer CE..."
"${DOCKER[@]}" pull portainer/portainer-ce:latest
"${DOCKER[@]}" run -d \
  -p 9000:9000 \
  -p 9443:9443 \
  --name portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest

echo ""
echo ">>> Portainer a correr."
echo ">>> Abre no browser (troca pelo IP ou hostname do servidor):"
echo ">>>   https://$(hostname -I 2>/dev/null | awk '{print $1}' || echo SEU_IP):9443"
echo ">>>   ou http://...:9000 se a tua versão mostrar HTTP na porta 9000"
echo ">>> Na primeira vez defines utilizador e palavra-passe de admin do Portainer."
echo ">>> Firewall: permite TCP 9443 e/ou 9000 se acederes de fora."
