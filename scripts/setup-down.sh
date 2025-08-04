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

# Variável da rede Docker a partir do .env
NETWORK_NAME=${TRAEFIK_NETWORK}

echo "Tentando remover a rede Docker: $NETWORK_NAME"

if docker network ls --format '{{.Name}}' | grep -wq "$NETWORK_NAME"; then
  docker network rm "$NETWORK_NAME"
  echo "Rede '$NETWORK_NAME' removida com sucesso."
else
  echo "Rede '$NETWORK_NAME' não existe."
fi
