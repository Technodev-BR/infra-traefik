#!/bin/bash
set -e

echo "Iniciando deploy do Traefik stack..."

# Carregar variáveis do .env
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo "Arquivo .env não encontrado! Abortando."
  exit 1
fi

docker stack deploy -c prod/traefik-stack.yml traefik

echo "Deploy concluído."
