# infra-traefik
Infraestrutura do Traefik em Docker Swarm com HTTPS automático via Let's Encrypt.

## Estrutura do projeto

- `configs/` → configurações do Traefik (middlewares.yml, traefik.yml)
- `dev/` → docker-compose para ambiente de desenvolvimento
- `prod/` → stack para ambiente de produção (Docker Swarm)
- `scripts/` → scripts de setup e deploy
- `secrets/` → arquivos sensíveis (ex: acme.json), **NÃO versionar**
- `.env` e `.env.example` → variáveis de ambiente
- `.gitignore` → padrão para ignorar arquivos sensíveis e temporários

## Pré-requisitos

- Docker instalado
- Swarm inicializado (`docker swarm init`)
- Domínio configurado apontando para sua VPS
- Portas 80 e 443 liberadas
- Porta 8080 do Dashboard network
- Let's Encrypt (ACME)
- TLS (via redirect 80 → 443)
- Autenticação com BasicAuth no dashboard

## Configuração do `.env`

! Copie o arquivo `.env.example` para `.env` e ajuste as variáveis conforme seu ambiente


## Setup inicial


Antes de rodar o setup, certifique-se que o Docker Swarm está inicializado e seu nó atual é manager. Para isso, execute:

```bash
docker swarm init
```

Para parar a execução do swarm execulte:

```bash
docker swarm leave --force
```

Ambiente dev:

```bash
chmod +x scripts/setup-dev.sh
./scripts/setup-dev.sh
```

Ambiente prod:

```bash
chmod +x scripts/setup-prod.sh
./scripts/setup-prod.sh
```

Caso ocorra um problema sobre a rede use o setup-down para limpar:


```bash
chmod +x scripts/setup-down.sh
./scripts/setup-down.sh
```

## Ambiente Desenvolvimento
Para testes e desenvolvimento sem gerar reais certificados HTTPS:


```bash
cd dev
docker-compose --env-file ../.env up -d
```

Dashboard acessível em http://localhost:8080

## Deploy em Produção (Docker Swarm)

Para deploy em prod usar:

```bash
chmod +x scripts/deploy.sh 
./scripts/deploy.sh
```
