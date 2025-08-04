#!/bin/bash
set -euo pipefail

unset DOCKER_INSECURE_NO_IPTABLES_RAW

# Caminhos
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/.."
ENV_FILE="$PROJECT_ROOT/.env"
SECRETS_DIR="$PROJECT_ROOT/secrets"
ACME_FILE="$SECRETS_DIR/acme.json"

echo "Iniciando setup do Traefik..."

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

# Cria a rede overlay
echo "Criando rede Docker: $TRAEFIK_NETWORK"
docker network create --driver=overlay --attachable "$TRAEFIK_NETWORK" 2>/dev/null \
  && echo "Rede $TRAEFIK_NETWORK criada." \
  || echo "Rede $TRAEFIK_NETWORK já existe."

# Cria o arquivo acme.json com permissão 600
echo "Garantindo arquivo acme.json em $SECRETS_DIR"
mkdir -p "$SECRETS_DIR"

if [ ! -f "$ACME_FILE" ]; then
  touch "$ACME_FILE"
  chmod 600 "$ACME_FILE"
  echo "acme.json criado com permissão 600."
else
  echo "acme.json já existe."
fi

echo "Setup finalizado com sucesso."
