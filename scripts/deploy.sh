#!/bin/bash
set -euo pipefail

unset DOCKER_INSECURE_NO_IPTABLES_RAW

echo "Iniciando deploy do Traefik stack..."

# Caminhos
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/.."
ENV_FILE="$PROJECT_ROOT/.env"
STACK_FILE="$PROJECT_ROOT/traefik-stack.yml"

# Verifica .env
if [ ! -f "$ENV_FILE" ]; then
  echo "Arquivo .env não encontrado em $ENV_FILE"
  exit 1
fi

# Exporta variáveis do .env
echo "Carregando variáveis de ambiente do .env"
set -a
source "$ENV_FILE"
set +a

# Verifica se o modo swarm está ativo
if ! docker info | grep -q 'Swarm: active'; then
  echo "Swarm não está ativo. Inicializando com 'docker swarm init'"
  docker swarm init || true
fi

# Executa deploy do stack
echo "Deploy da stack Traefik usando arquivo $STACK_FILE"
docker stack deploy -c "$STACK_FILE" traefik

echo "Deploy concluído com sucesso."
