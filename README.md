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

### Criar um registro de imagens no Azure

O Azure Container Registry (ACR) é o repositório onde a imagem Docker da sua aplicação será armazenada antes de ser usada pelo Kubernetes. Pense nele como um “depósito” central de imagens, semelhante a um repositório de pacotes, porém para containers.

Quando o GitHub Actions construí a imagem Docker, ele precisa enviar essa imagem para algum lugar. O ACR é esse lugar. Depois, o AKS busca a imagem no ACR e sobe os pods da aplicação.

#### Passo a passo

1. Faça login na Azure:

```bash
az login
```

2. Verifique a assinatura ativa:

```bash
az account list --output table
az account set --subscription "<nome-ou-id-da-sua-assinatura>"
```

3. Crie um grupo de recursos:

```bash
az group create --name rg-painel-nuvem --location brazilsouth
```

4. Crie o Azure Container Registry:

```bash
az acr create \
  --resource-group rg-painel-nuvem \
  --name <nome-unico-do-acr> \
  --sku Basic
```

Importante:

- o nome do ACR precisa ser único globalmente na Azure;
- use somente letras minúsculas e números;
- o valor `Basic` é suficiente para começar.

5. Verifique se o registro foi criado com sucesso:

```bash
az acr show --name <nome-unico-do-acr> --resource-group rg-painel-nuvem --output table
```

#### Por que isso é importante?

Sem o ACR, o GitHub Actions não consegue publicar a imagem Docker em um lugar acessível pelo cluster. O AKS precisa de um registro para localizar e baixar a imagem que será executada.

#### Configurar o GitHub Actions para o Azure

Depois de criar o ACR, você precisa informar ao GitHub quais valores da Azure ele deve usar. No repositório, acesse Settings → Secrets and variables → Actions.

Cadastre os seguintes secrets:

```text
AZURE_CLIENT_ID
AZURE_TENANT_ID
AZURE_SUBSCRIPTION_ID
```

E as seguintes variables:

```text
AZURE_RESOURCE_GROUP=rg-painel-nuvem
AZURE_AKS_CLUSTER=<nome-do-cluster-aks>
AZURE_ACR_NAME=<nome-unico-do-acr>
KUBERNETES_NAMESPACE=aula-nuvem
IMAGE_NAME=painel-nuvem
```

Se algum desses valores estiver ausente, o workflow para de executar com uma mensagem clara antes de tentar autenticar no Azure.

#### Modelo prático para os alunos

Use este modelo como referência para preencher os valores no GitHub e na Azure:

```text
Grupo de recursos: rg-painel-nuvem
Localização: brazilsouth
Nome do ACR: <nome-unico-do-acr>
Nome do cluster AKS: <nome-do-cluster-aks>
Namespace Kubernetes: aula-nuvem
Nome da imagem: painel-nuvem
```

Exemplo de configuração no GitHub:

Secrets:

```text
AZURE_CLIENT_ID=00000000-0000-0000-0000-000000000000
AZURE_TENANT_ID=11111111-1111-1111-1111-111111111111
AZURE_SUBSCRIPTION_ID=22222222-2222-2222-2222-222222222222
```

Variables:

```text
AZURE_RESOURCE_GROUP=rg-painel-nuvem
AZURE_AKS_CLUSTER=aks-aula-auto
AZURE_ACR_NAME=acraula123
KUBERNETES_NAMESPACE=aula-nuvem
IMAGE_NAME=painel-nuvem
```

Para a autenticação com o GitHub Actions, a ideia é esta:

1. criar uma identidade no Microsoft Entra ID;
2. conceder permissões mínimas para o ACR e para o AKS;
3. configurar a credencial federada do GitHub;
4. colocar os identificadores no repositório GitHub como secrets.

Esses valores são usados pelo workflow para que o GitHub Actions consiga:

- entrar na Azure;
- enviar a imagem Docker para o ACR;
- obter as credenciais do AKS;
- aplicar os manifestos Kubernetes.

Em resumo:

- o Docker cria a imagem localmente;
- o GitHub Actions envia essa imagem para o ACR;
- o AKS usa essa imagem para criar os containers da aplicação na nuvem.

## Dicas rápidas

- Se a porta 3000 estiver ocupada, troque a porta do container ou encerre o processo conflitante.
- Em Windows, use PowerShell para os comandos.
- Em Linux e macOS, use Bash/Zsh.
- Se o Docker não iniciar, verifique se o Docker Desktop está aberto e com o daemon ativo.

- Azure CLI — https://learn.microsoft.com/cli/azure/
- Gateway API (Kubernetes) — https://gateway-api.sigs.k8s.io/
