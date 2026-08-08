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

## Preparação do ambiente Azure para publicar uma aplicação em nuvem
Nesta etapa, vamos preparar a Azure para receber a imagem Docker da aplicação **Painel Nuvem**.

Ao final, teremos:

- uma assinatura Azure selecionada;
- um grupo de recursos para organizar os serviços;
- um Azure Container Registry (ACR) para guardar as imagens Docker;
- os valores que serão usados posteriormente no GitHub Actions e no AKS.

> Para acompanhar melhor, realize **um bloco por vez**: copie o comando, execute, confira a mensagem de sucesso e só então avance.

---

### Antes de começar
Você precisa ter o **Azure CLI** instalado e acesso a uma conta Azure com uma assinatura ativa.

Abra o terminal:

- **Windows:** PowerShell ou Windows Terminal;
- **macOS:** Terminal;
- **Linux:** Terminal.
Nesta aula, utilizaremos estes nomes:

```
Grupo de recursos: rg-painel-nuvem
Região: brazilsouth
Nome da imagem: painel-nuvem
Namespace Kubernetes: aula-nuvem
```
O nome do ACR será definido por cada aluno, pois ele precisa ser exclusivo no Azure.

---

## 1. Fazer login na Azure
Execute:

```bash
az login
```
O navegador será aberto para que você entre com sua conta Microsoft/Azure.

Após concluir o login, volte ao terminal. Serão exibidas informações sobre as assinaturas disponíveis na sua conta.

> Objetivo deste passo: permitir que o terminal se conecte à sua conta Azure.

---

## 2. Conferir e selecionar a assinatura Azure
Uma conta pode possuir mais de uma assinatura. A assinatura define onde os recursos serão criados e quem será responsável pela cobrança.

Para listar as assinaturas disponíveis, execute:

```bash
az account list --output table
```
Localize a assinatura que será utilizada. No exemplo desta aula:

```
Nome da assinatura: Azure subscription 1
ID da assinatura: 487d9a8b-f30e-44d7-b6b7-6754be75e161
```
Agora, selecione a assinatura pelo ID:

```bash
az account set --subscription 487d9a8b-f30e-44d7-b6b7-6754be75e161
```
Para confirmar qual assinatura está ativa, execute:

```bash
az account show --output table
```
Confira se o nome e o ID exibidos correspondem à assinatura correta.

> Objetivo deste passo: garantir que os recursos da aula serão criados na assinatura desejada.

---

## 3. Criar o grupo de recursos
Um **grupo de recursos** é como uma pasta organizadora dentro da Azure. Nele, reuniremos os serviços que fazem parte da aplicação, como o ACR, o AKS e outros recursos que serão usados nas próximas etapas.

Execute:

```bash
az group create \
  --name rg-painel-nuvem \
  --location brazilsouth
```

### O que cada parte significa?

- `az group create`: cria um grupo de recursos;
- `--name rg-painel-nuvem`: define o nome do grupo;
- `--location brazilsouth`: define a região do datacenter Azure, neste caso, **Brasil Sul**.
Para verificar se o grupo foi criado, execute:

```bash
az group show \
  --name rg-painel-nuvem \
  --output table
```
Se as informações do grupo aparecerem no terminal, o passo foi concluído com sucesso.

> Objetivo deste passo: criar o local onde os recursos do projeto ficarão organizados.

---

## 4. Escolher o nome do Azure Container Registry
O **Azure Container Registry**, ou **ACR**, é um repositório privado para imagens Docker.

Pense nele como um “depósito na nuvem” onde a aplicação será guardada após ser empacotada em uma imagem Docker. Depois, o AKS buscará essa imagem no ACR para executar a aplicação.

O nome do ACR precisa seguir estas regras:

- ser único em todo o Azure;
- conter somente letras minúsculas e números;
- não conter espaço, hífen, ponto ou caracteres especiais;
- ter entre 5 e 50 caracteres.
Exemplo de nome:

```
acrpainelnuvemrodrigo2026
```

> Cada aluno deve usar um nome próprio. Se o Azure informar que o nome já existe, altere o final, por exemplo: `acrpainelnuvemrfs2026`.

---

## 5. Criar o Azure Container Registry
Substitua o nome abaixo pelo nome único que você escolheu e execute o comando:

```bash
az acr create \
  --resource-group rg-painel-nuvem \
  --name acrpainelnuvemrodrigo2026 \
  --sku Basic
```

### O que cada parte significa?

- `az acr create`: cria um Azure Container Registry;
- `--resource-group rg-painel-nuvem`: informa em qual grupo de recursos o ACR será criado;
- `--name acrpainelnuvemrodrigo2026`: define o nome do registro;
- `--sku Basic`: seleciona o plano Básico, adequado para estudos, testes e ambientes iniciais.

> Importante: no seu projeto, use o mesmo nome do ACR em todos os comandos e configurações futuras.

---

## 6. Confirmar a criação do ACR
Execute:

```bash
az acr show \
  --name acrpainelnuvemrodrigo2026 \
  --resource-group rg-painel-nuvem \
  --output table
```
Se o terminal mostrar as informações do registro, o ACR foi criado corretamente.

Você também pode obter o endereço completo do registro:

```bash
az acr show \
  --name acrpainelnuvemrodrigo2026 \
  --resource-group rg-painel-nuvem \
  --query loginServer \
  --output tsv
```
O resultado será semelhante a:

```
acrpainelnuvemrodrigo2026.azurecr.io
```
Esse endereço identifica o local onde as imagens Docker serão armazenadas.

---

## 7. Registrar os valores do seu ambiente
Anote os valores abaixo. Eles serão utilizados na configuração do AKS e do GitHub Actions.

```
Grupo de recursos: rg-painel-nuvem
Localização: brazilsouth
Nome do ACR: acrpainelnuvemrodrigo2026
Endereço do ACR: acrpainelnuvemrodrigo2026.azurecr.io
Nome do cluster AKS: será criado em etapa posterior
Namespace Kubernetes: aula-nuvem
Nome da imagem: painel-nuvem
```

> Dica de organização: mantenha esses valores em um arquivo de anotações. Evite alterar nomes depois de iniciar a configuração, pois eles serão usados em vários arquivos e comandos.

---

# Configurar o GitHub Actions para acessar a Azure
O **GitHub Actions** é o serviço que automatiza tarefas no repositório GitHub. Neste projeto, ele fará o processo de entrega da aplicação na nuvem.

De forma resumida, o fluxo será:

1. o GitHub Actions recebe uma alteração no código;
2. cria a imagem Docker da aplicação;
3. envia a imagem para o ACR;
4. acessa o AKS;
5. atualiza os contêineres que executam a aplicação.
Para isso, o GitHub precisa de uma identidade autorizada a acessar a Azure. Essa configuração será feita em uma etapa específica, usando o Microsoft Entra ID e credenciais federadas.

---

## 8. Onde cadastrar os valores no GitHub
No repositório GitHub do projeto, acesse:

```
Settings → Secrets and variables → Actions
```
Existem dois tipos de informações:

- **Secrets:** dados sensíveis, que não devem aparecer publicamente;
- **Variables:** dados de configuração que podem ser visualizados no repositório.

> Nunca publique senhas, chaves privadas ou tokens diretamente no código-fonte ou no arquivo README.

---

## Cadastrar os secrets no GitHub
Os **secrets** são valores usados pelo GitHub Actions para se autenticar na Azure com segurança.

Cada aluno deve utilizar os **identificadores da própria conta Azure**. Não compartilhe esses valores em mensagens, prints públicos, commits ou arquivos do projeto.

No repositório do GitHub, acesse:

```
Settings → Secrets and variables → Actions
```
Em seguida, clique em:

```
New repository secret
```
Você criará **três secrets separados**. Para cada um, informe o nome no campo **Name**, cole o valor correspondente no campo **Secret** e clique em **Add secret**.

---

### 1. `AZURE_SUBSCRIPTION_ID`
Este secret identifica a assinatura Azure em que os recursos serão criados.

No Terminal, execute:

```
az account show --query id --output tsv
```
O terminal exibirá o ID da sua assinatura.

No GitHub, cadastre:

```
Name: AZURE_SUBSCRIPTION_ID
Secret: <id-da-sua-assinatura-azure>
```

---

### 2. `AZURE_TENANT_ID`
Este secret identifica sua organização no Microsoft Entra ID.

No Terminal, execute:

```
az account show --query tenantId --output tsv
```
O terminal exibirá o ID do seu tenant.

No GitHub, cadastre:

```
Name: AZURE_TENANT_ID
Secret: <id-do-seu-tenant>
```

---

### 3. `AZURE_CLIENT_ID`
Este secret identificará a identidade que o GitHub Actions utilizará para acessar a Azure.

Ele será obtido em uma etapa posterior, quando criaremos uma identidade no Microsoft Entra ID e configuraremos a credencial federada do GitHub.

Por enquanto, **não crie este secret**.

Quando o valor for gerado, ele será cadastrado assim:

```
Name: AZURE_CLIENT_ID
Secret: <id-da-identidade-criada-no-microsoft-entra-id>
```

---

### Como conferir os secrets cadastrados
Ao final desta etapa, a página do GitHub deverá exibir os nomes:

```
AZURE_SUBSCRIPTION_ID
AZURE_TENANT_ID
```
Após a configuração da identidade no Microsoft Entra ID, será acrescentado:

```
AZURE_CLIENT_ID
```

> Segurança: o GitHub protege o conteúdo dos secrets e não permite visualizá-los novamente após o cadastro. Confira com atenção antes de clicar em **Add secret**.

---

## 10. Cadastrar as variables
Na seção **Variables**, cadastre os seguintes valores:

```
AZURE_RESOURCE_GROUP=rg-painel-nuvem
AZURE_AKS_CLUSTER=<nome-do-cluster-aks>
AZURE_ACR_NAME=<nome-unico-do-acr>
KUBERNETES_NAMESPACE=aula-nuvem
IMAGE_NAME=painel-nuvem
```
Exemplo preenchido:

```
AZURE_RESOURCE_GROUP=rg-painel-nuvem
AZURE_AKS_CLUSTER=aks-painel-nuvem
AZURE_ACR_NAME=acrpainelnuvemrodrigo2026
KUBERNETES_NAMESPACE=aula-nuvem
IMAGE_NAME=painel-nuvem
```

> O valor de `AZURE_AKS_CLUSTER` somente deve ser preenchido após a criação do cluster AKS.

---

## Por que o ACR é importante?
Sem o ACR, o GitHub Actions não tem um local privado na Azure para publicar a imagem Docker da aplicação.

O AKS também precisa do ACR porque ele deve saber onde encontrar a imagem que será transformada em contêineres.

O fluxo completo é:

```
Código da aplicação
        ↓
GitHub Actions cria a imagem Docker
        ↓
ACR armazena a imagem na Azure
        ↓
AKS baixa a imagem do ACR
        ↓
AKS executa os contêineres da aplicação
```
Em resumo:

- **Docker** empacota a aplicação;
- **GitHub Actions** automatiza a entrega;
- **ACR** armazena a imagem Docker;
- **AKS** executa a aplicação em contêineres na nuvem.

---

## Checklist de conclusão
Antes de avançar, confirme:

- Realizei o login com `az login`;
- Selecionei a assinatura Azure correta;
- Criei o grupo de recursos `rg-painel-nuvem`;
- Criei um ACR com nome único;
- Consultei o ACR com o comando `az acr show`;
- Anotei o nome e o endereço do ACR;
- Entendi que os secrets serão configurados após a criação da identidade no Microsoft Entra ID;
- Entendi que o nome do cluster AKS será informado em uma etapa posterior.

## Dicas rápidas

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
