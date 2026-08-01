# Painel Nuvem

Este projeto é um exemplo didático de uma aplicação Node.js com Express, containerizada com Docker e preparada para ser publicada no GitHub e implantada em ambientes de nuvem.

## Status atual

A aplicação já foi validada localmente com sucesso:

- a execução local funcionou com Node.js;
- a imagem Docker foi construída com sucesso;
- o container foi iniciado e respondeu corretamente no endpoint de saúde;
- o projeto está pronto para seguir para GitHub Actions e implantação em Kubernetes/Azure.

## O que o projeto faz

- expõe uma interface web simples;
- disponibiliza endpoints de saúde e informação;
- pode ser executado diretamente no Node.js;
- pode ser executado em um container Docker;
- é uma base prática para CI/CD e implantação em nuvem.

## Requisitos

Antes de começar, instale:

- Git
- Node.js 24
- npm
- Docker Desktop ou Docker Engine
- VS Code (recomendado)

### Linux

Use a instalação do Node.js e do Docker compatível com a sua distribuição.

### macOS

O fluxo mais comum é usar Homebrew:

```bash
brew install node
brew install --cask docker
```

### Windows

Instale o Node.js LTS e o Docker Desktop com suporte a WSL 2.

## Clonar o projeto

```bash
git clone https://github.com/rodrygofesantos/painel-nuvem.git
cd painel-nuvem
```

## Instalar dependências

```bash
npm ci
```

## Executar localmente

### Linux/macOS

```bash
npm start
```

### Windows (PowerShell)

```powershell
npm start
```

Acesse:

- http://localhost:3000
- http://localhost:3000/healthz
- http://localhost:3000/api/info

## Executar testes

```bash
npm test
```

## Construir a imagem Docker

### Linux/macOS

```bash
docker build -t painel-nuvem:v1.0 .
```

### Windows (PowerShell)

```powershell
docker build -t painel-nuvem:v1.0 .
```

## Rodar o container

### Linux/macOS

```bash
docker run --rm -d --name painel-nuvem -p 3000:3000 painel-nuvem:v1.0
```

### Windows (PowerShell)

```powershell
docker run --rm -d --name painel-nuvem -p 3000:3000 painel-nuvem:v1.0
```

Para validar rapidamente:

```bash
docker ps
docker logs painel-nuvem
curl http://localhost:3000/healthz
```

Para parar o container:

```bash
docker stop painel-nuvem
```

## Publicar no GitHub

```bash
git add .
git commit -m "Atualiza projeto"
git branch -M main
git remote add origin https://github.com/<seu-usuario>/painel-nuvem.git
git push -u origin main
```

## Estrutura do projeto

```text
painel-nuvem/
├── app.js
├── server.js
├── Dockerfile
├── package.json
├── public/
├── scripts/
├── test/
├── manifests/
└── .github/workflows/
```

## Próximos passos

Depois de validar o ambiente local e o container, o próximo passo natural é:

1. publicar o código no GitHub;
2. configurar o GitHub Actions;
3. conectar o repositório à Azure;
4. implantar a aplicação em um cluster Kubernetes.

## Dicas rápidas

- Se a porta 3000 estiver ocupada, troque a porta do container ou encerre o processo conflitante.
- Em Windows, use PowerShell para os comandos.
- Em Linux e macOS, use Bash/Zsh.
- Se o Docker não iniciar, verifique se o Docker Desktop está aberto e com o daemon ativo.

- Azure CLI — https://learn.microsoft.com/cli/azure/
- Gateway API (Kubernetes) — https://gateway-api.sigs.k8s.io/
