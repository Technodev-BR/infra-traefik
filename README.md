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


## Gerando a senha para o dashboard Traefik

Para proteger o dashboard com autenticação básica, utilizamos um hash bcrypt para o usuário administrador.

Para gerar o hash da sua senha, execute o comando:

## Setup inicial

```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
```

## Ambiente Desenvolvimento
Para testes e desenvolvimento sem gerar reais certificados HTTPS:


```bash
cd dev
docker-compose up -d
```

Dashboard acessível em http://localhost:8080

## Deploy em Produção (Docker Swarm)

Para deploy em prod usar:

```bash
chmod +x scripts/deploy.sh 
./scripts/deploy.sh
```
