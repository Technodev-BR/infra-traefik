#!/bin/bash
set -euo pipefail

echo "Iniciando deploy do Traefik stack..."

# Caminho absoluto do diretório do script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/.."
ENV_FILE="$PROJECT_ROOT/.env"
STACK_FILE="$PROJECT_ROOT/prod/traefik-stack.yml"

# Carrega variáveis do .env
if [ -f "$ENV_FILE" ]; then
  echo "Carregando variáveis de ambiente do $ENV_FILE"
  set -a
  source "$ENV_FILE"
  set +a
else
  echo "Arquivo .env não encontrado em $ENV_FILE"
  exit 1
fi

# Verifica se o Docker Swarm está ativo
if ! docker info | grep -q 'Swarm: active'; then
  echo "Docker Swarm não está ativo. Inicializando com 'docker swarm init'"
  docker swarm init || true
fi

# Faz o deploy da stack
echo "Deploy do stack usando $STACK_FILE"
docker stack deploy -c "$STACK_FILE" traefik

echo "Deploy concluído com sucesso."
