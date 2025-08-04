#!/bin/bash
set -e

# Carrega o .env relativo à raiz do projeto (infra-traefik)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/.."
ENV_FILE="$PROJECT_ROOT/.env"

if [ ! -f "$ENV_FILE" ]; then
  echo "Arquivo .env não encontrado em $ENV_FILE"
  exit 1
fi

# Exporta as variáveis do .env ignorando linhas vazias e comentários
export $(grep -v '^#' "$ENV_FILE" | grep -v '^$' | xargs)

echo "Iniciando setup do Traefik..."

echo "...criando rede Docker $TRAEFIK_NETWORK"
docker network create "$TRAEFIK_NETWORK" || echo "Rede $TRAEFIK_NETWORK já existe ou erro ignorado"

echo "...criando arquivo acme.json para certificados"
SECRETS_DIR="$PROJECT_ROOT/secrets"
mkdir -p "$SECRETS_DIR"
ACME_FILE="$SECRETS_DIR/acme.json"

if [ ! -f "$ACME_FILE" ]; then
  touch "$ACME_FILE"
  chmod 600 "$ACME_FILE"
  echo "Arquivo acme.json criado e permissão 600 aplicada."
else
  echo "Arquivo acme.json já existe."
fi

echo "Setup finalizado com sucesso."
