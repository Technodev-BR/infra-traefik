#!/bin/bash
set -e

echo "Iniciando deploy Traefik stack..."

# Gera configs a partir dos templates e variáveis do .env (opcional, garante configs atualizadas)
bash scripts/generate-configs.sh

NETWORK_NAME=${TRAEFIK_NETWORK:-traefik-public}

# Verifica se rede existe (requer rede overlay para Swarm)
if ! docker network ls | grep -qw "$NETWORK_NAME"; then
  echo "Rede $NETWORK_NAME não encontrada, criando..."
  docker network create --driver=overlay "$NETWORK_NAME"
else
  echo "Rede $NETWORK_NAME já existe."
fi

# Deploy da stack docker swarm
docker stack deploy -c prod/traefik-stack.yml traefik

echo "Deploy concluído."
