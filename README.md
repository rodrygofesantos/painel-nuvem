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

## Implantação em nuvem

Depois de validar a aplicação localmente e em container, o próximo passo é levar o projeto para um ambiente de nuvem.

O fluxo de implantação funciona assim:

1. O código é enviado para o GitHub.
2. O GitHub Actions executa os testes e monta a imagem Docker.
3. A imagem é enviada para um registro de containers, como o Azure Container Registry (ACR).
4. O Kubernetes, por exemplo no AKS da Azure, baixa essa imagem e sobe os pods da aplicação.
5. O Service do Kubernetes expõe a aplicação para acesso externo.

Para isso, este repositório já inclui:

- o workflow de CI/CD em .github/workflows/;
- os manifestos Kubernetes em manifests/;
- a configuração da aplicação para rodar na porta 3000.

Em termos práticos, o processo envolve:

- criar ou selecionar um recurso no Azure;
- configurar as credenciais do GitHub Actions;
- fazer o push para a branch principal;
- acompanhar a execução do workflow;
- validar a aplicação no cluster.

Esse é o caminho natural para transformar o projeto local em uma aplicação disponível na nuvem.

## Dicas rápidas

- Se a porta 3000 estiver ocupada, troque a porta do container ou encerre o processo conflitante.
- Em Windows, use PowerShell para os comandos.
- Em Linux e macOS, use Bash/Zsh.
- Se o Docker não iniciar, verifique se o Docker Desktop está aberto e com o daemon ativo.

- Azure CLI — https://learn.microsoft.com/cli/azure/
- Gateway API (Kubernetes) — https://gateway-api.sigs.k8s.io/
