#!/bin/bash
set -e

echo "Iniciando setup do ambiente Traefik..."

# Gera configs a partir dos templates e variáveis do .env
bash scripts/generate-configs.sh

# Cria rede docker se não existir
NETWORK_NAME=${TRAEFIK_NETWORK:-traefik-public}

if ! docker network ls | grep -qw "$NETWORK_NAME"; then
  echo "Criando rede Docker overlay: $NETWORK_NAME"
  docker network create --driver=overlay --attachable "$NETWORK_NAME"
else
  echo "Rede Docker $NETWORK_NAME já existe."
fi

# Cria arquivo acme.json se não existir e aplica permissão
ACME_FILE="secrets/acme.json"
if [ ! -f "$ACME_FILE" ]; then
  echo "Criando arquivo $ACME_FILE"
  mkdir -p secrets
  touch "$ACME_FILE"
  chmod 600 "$ACME_FILE"
else
  echo "Arquivo $ACME_FILE já existe."
fi

echo "Setup concluído com sucesso."
