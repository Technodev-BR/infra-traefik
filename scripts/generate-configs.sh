#!/bin/bash
set -e

# Carregar .env se existir
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

echo "Gerando arquivos de configuração Traefik..."

envsubst < configs/traefik.template.yml > configs/traefik.yml
envsubst < configs/middlewares.template.yml > configs/middlewares.yml

echo "Arquivos configs/traefik.yml e configs/middlewares.yml gerados com sucesso."
