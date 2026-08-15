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

## Roteiro rápido para os alunos

Esta seção foi escrita para ser seguida **uma etapa por vez**. Não tente
executar todos os comandos de uma só vez.

Use este método durante a atividade:

1. Leia somente o passo atual.
2. Execute apenas o bloco de comando daquele passo.
3. Compare sua tela com o resultado esperado.
4. Marque o passo como concluído.
5. Somente então avance para o próximo passo.

> Se um passo apresentar erro, pare nele. Não continue esperando que o erro se
> resolva sozinho. Leia a seção [Erros comuns](#erros-comuns-ao-rodar-o-app) ou
> peça ajuda mostrando o comando executado e a mensagem completa do erro.

### Caminho 1 — Rodar o app diretamente com Node.js

Este é o caminho recomendado para a primeira execução.

#### Passo 1 — Abrir o terminal na pasta correta

Abra a pasta `painel-nuvem` no VS Code e depois abra **Terminal → New
Terminal**.

Confira se o terminal está na pasta do projeto:

```bash
pwd
```

No PowerShell do Windows, você também pode usar:

```powershell
Get-Location
```

O caminho exibido deve terminar em `painel-nuvem`.

- [ ] Estou dentro da pasta `painel-nuvem`.

#### Passo 2 — Conferir o Node.js e o npm

Execute:

```bash
node --version
npm --version
```

Resultado esperado:

- o primeiro comando começa com `v24`;
- o segundo comando mostra a versão do npm;
- nenhum dos comandos mostra “command not found” ou “não é reconhecido”.

- [ ] O Node.js 24 e o npm estão disponíveis.

#### Passo 3 — Instalar as dependências

Execute:

```bash
npm ci
```

Aguarde o terminal terminar. O comando deve voltar a mostrar o cursor sem uma
mensagem de erro.

> Não feche o terminal enquanto o npm estiver trabalhando.

- [ ] O comando `npm ci` terminou sem erro.

#### Passo 4 — Executar os testes

Execute:

```bash
npm test
```

Resultado esperado no resumo:

```text
tests 3
pass 3
fail 0
```

Se aparecer `fail 1` ou outro valor maior que zero, pare e corrija o problema
antes de iniciar o servidor.

- [ ] Os três testes passaram.

#### Passo 5 — Iniciar o servidor

Execute:

```bash
npm start
```

O terminal ficará ocupado enquanto o servidor estiver rodando. **Isso é
normal.** Não feche esse terminal.

- [ ] O servidor iniciou sem erro.

#### Passo 6 — Abrir a aplicação

Abra o navegador e teste estes três endereços, um por vez:

1. [http://localhost:3000](http://localhost:3000)
2. [http://localhost:3000/healthz](http://localhost:3000/healthz)
3. [http://localhost:3000/api/info](http://localhost:3000/api/info)

Resultados esperados:

- a página principal mostra o Painel Nuvem;
- `/healthz` mostra `ok`;
- `/api/info` mostra informações em formato JSON.

- [ ] A página principal abriu.
- [ ] O endpoint `/healthz` respondeu `ok`.
- [ ] O endpoint `/api/info` mostrou um JSON.

#### Passo 7 — Parar o servidor

Volte ao terminal em que executou `npm start` e pressione:

```text
Ctrl + C
```

O cursor do terminal deve reaparecer.

- [ ] O servidor local foi encerrado.

### Caminho 2 — Rodar o app com Docker

Faça este caminho somente depois que o Caminho 1 estiver funcionando.

#### Passo 1 — Conferir o Docker

Abra o Docker Desktop, aguarde ele iniciar e execute:

```bash
docker version
```

O comando deve mostrar informações de `Client` e `Server`.

- [ ] O Docker está em execução.

#### Passo 2 — Construir a imagem

Execute na pasta do projeto:

```bash
docker build -t painel-nuvem:validacao .
```

O ponto final (`.`) faz parte do comando. Aguarde até aparecer uma mensagem de
conclusão sem erro.

- [ ] A imagem `painel-nuvem:validacao` foi construída.

#### Passo 3 — Iniciar o container

Execute:

```bash
docker run --rm -d \
  --name painel-nuvem \
  -p 3000:3000 \
  painel-nuvem:validacao
```

No PowerShell, se a quebra de linha causar erro, use o comando em uma linha:

```powershell
docker run --rm -d --name painel-nuvem -p 3000:3000 painel-nuvem:validacao
```

- [ ] O Docker exibiu o identificador do container.

#### Passo 4 — Conferir o container e a saúde

Execute:

```bash
docker ps
docker logs painel-nuvem
curl http://localhost:3000/healthz
```

Resultado esperado: o container aparece como ativo e o último comando responde
`ok`.

No PowerShell, se `curl` não funcionar como esperado, use:

```powershell
(Invoke-WebRequest http://localhost:3000/healthz).Content
```

- [ ] O container está ativo.
- [ ] O endpoint de saúde respondeu `ok`.

#### Passo 5 — Parar o container

Execute:

```bash
docker stop painel-nuvem
```

- [ ] O container foi encerrado.

### Erros comuns ao rodar o app

| Mensagem ou situação | O que conferir |
| --- | --- |
| `node: command not found` ou “node não é reconhecido” | Instale o Node.js 24, feche o terminal e abra outro. |
| `npm ci` informa versão de Node incompatível | Confirme com `node --version`. A versão deve começar com `v24`. |
| `EADDRINUSE` ou “porta 3000 em uso” | Já existe outro servidor/container usando a porta. Volte ao terminal anterior e pressione `Ctrl + C`, ou execute `docker stop painel-nuvem`. |
| A página não abre | Confirme que `npm start` continua rodando e use exatamente `http://localhost:3000`. |
| Docker informa que não consegue acessar o daemon | Abra o Docker Desktop e aguarde a inicialização completa. |
| O nome `painel-nuvem` já está em uso no Docker | Execute `docker stop painel-nuvem` e tente novamente. |
| `/healthz` não responde `ok` | Leia `docker logs painel-nuvem` ou a mensagem do terminal que executa `npm start`. |

## Como usar o prompt da atividade

### O que é um prompt?

Um **prompt** é o texto com as instruções entregues ao assistente de IA. Ele
explica o objetivo, os limites de segurança, os arquivos que devem ser lidos e
o resultado esperado.

Nesta atividade, o prompt orienta o assistente a revisar e publicar o projeto
usando Docker, GitHub Actions, Azure Container Registry e AKS Automatic.

> O prompt ajuda na execução, mas não substitui a conferência do aluno. Leia o
> plano, os comandos e os avisos de custo antes de responder `sim` ou
> `confirmo`.

### Antes de enviar o prompt

Conclua esta lista:

- [ ] Abri a pasta correta do repositório no assistente de IA.
- [ ] Executei `npm ci`, `npm test` e o build Docker local.
- [ ] Entendi que AKS, ACR, IP público e monitoramento podem gerar cobrança.
- [ ] Sei qual assinatura Azure será usada.
- [ ] Não coloquei senha, token, client secret ou dados de pagamento no prompt.
- [ ] Fiz commit ou backup das alterações importantes.

### Passo a passo para usar o prompt

#### Passo 1 — Abrir o projeto

Abra o assistente de IA com a pasta `painel-nuvem` como pasta de trabalho. O
assistente precisa conseguir ler arquivos como `README.md`, `Dockerfile`,
`package.json`, `.github/workflows/deploy.yml` e `manifests/`.

#### Passo 2 — Iniciar uma conversa nova

Use uma conversa nova para não misturar esta atividade com pedidos antigos.

#### Passo 3 — Colar o prompt completo

Cole o prompt fornecido pelo professor **do começo ao fim**. Não remova as
partes “Objetivo”, “Siga rigorosamente estas instruções” e “Importante”.

Depois do prompt, acrescente:

```text
Comece inspecionando o repositório. Explique somente o próximo passo e aguarde
minha confirmação antes de criar recursos que geram custo ou excluir algo.
```

#### Passo 4 — Conferir a inspeção

Antes de permitir alterações, verifique se o assistente identificou:

- Node.js 24 e porta `3000`;
- teste com `npm test`;
- endpoint `/healthz`;
- Dockerfile existente;
- workflow `.github/workflows/deploy.yml`;
- namespace `aula-nuvem`;
- Service do tipo `LoadBalancer`.

Se algo estiver errado, não responda apenas `sim`. Escreva qual informação
precisa ser corrigida.

#### Passo 5 — Ler o plano e o aviso de custo

O assistente deve apresentar os recursos, a região, os nomes propostos, as
permissões e o alerta de cobrança.

Confirme a criação somente se o plano estiver correto e você estiver autorizado
a usar a assinatura. Uma resposta clara pode ser:

```text
Confirmo a criação dos recursos descritos no plano e estou ciente dos custos.
```

#### Passo 6 — Fazer autenticações pessoalmente

Quando aparecer uma etapa de login:

1. abra o link indicado;
2. entre com sua própria conta;
3. conclua MFA, se solicitado;
4. volte à conversa e responda `concluído`.

Nunca envie ao assistente:

- senha;
- número de cartão;
- código temporário de MFA;
- token de acesso;
- client secret.

IDs como `Subscription ID`, `Tenant ID` e `Client ID` não são senhas, mas ainda
devem ser tratados com cuidado e não devem ser publicados em prints ou fóruns.

#### Passo 7 — Avançar uma etapa por vez

Use mensagens curtas e específicas:

```text
Explique o próximo passo com um comando por vez.
```

```text
Mostre o resultado esperado antes de executar.
```

```text
Pare antes de qualquer ação que gere custo ou exclua recursos.
```

```text
O comando falhou. Analise esta mensagem de erro: <cole o erro aqui>.
```

Evite enviar vários `sim` seguidos sem ler o que será feito.

#### Passo 8 — Conferir as evidências finais

Ao terminar, peça e confira:

- [ ] resultado de `npm test`;
- [ ] resultado do build Docker;
- [ ] nome e tag da imagem no ACR;
- [ ] link da execução do GitHub Actions;
- [ ] dois Pods em estado `Running`;
- [ ] rollout concluído;
- [ ] IP externo do Service;
- [ ] resposta `ok` de `/healthz`;
- [ ] comandos de diagnóstico e limpeza;
- [ ] confirmação de que nenhum segredo foi salvo no GitHub.

### Se você perder a concentração ou não souber onde parou

Não reinicie tudo. Envie ao assistente:

```text
Resuma o que já foi concluído, mostre o que ainda falta e apresente somente o
próximo passo. Não execute nada até eu confirmar.
```

Também pode ajudar:

- fechar abas que não são usadas na etapa atual;
- manter somente um terminal para o servidor e outro para comandos;
- marcar as caixas de seleção deste README;
- trabalhar por blocos curtos e fazer uma pausa entre as etapas;
- anotar o último passo concluído antes de interromper a atividade.

### Regra de segurança mais importante

Nunca peça ao assistente para “apagar tudo” sem informar o nome exato do recurso
e entender o impacto. Para laboratórios Azure, primeiro confira os recursos e
somente depois use o script de limpeza documentado neste repositório.

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
Você precisa ter o **Azure CLI 2.86.0 ou posterior** instalado e acesso a uma
conta Azure com uma assinatura ativa.

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

> **Aviso de custo:** não execute as etapas de criação sem confirmar a
> assinatura e aceitar a cobrança. O ACR Basic tem custo recorrente; o AKS
> Automatic cobra pelos recursos de computação utilizados, e o LoadBalancer/IP
> público também pode gerar cobrança. Exclua o grupo de recursos ao terminar o
> laboratório.

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
Localize a assinatura que será utilizada e confirme explicitamente que ela é
a responsável pela cobrança. Não copie um ID de exemplo:

```
Nome da assinatura: <nome-da-assinatura-confirmada>
ID da assinatura: <id-da-assinatura-confirmada>
```
Agora, selecione a assinatura pelo ID:

```bash
az account set --subscription <id-da-assinatura-confirmada>
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
  --location brazilsouth \
  --sku Basic \
  --admin-enabled false \
  --dnl-scope TenantReuse \
  --role-assignment-mode rbac
```

### O que cada parte significa?

- `az acr create`: cria um Azure Container Registry;
- `--resource-group rg-painel-nuvem`: informa em qual grupo de recursos o ACR será criado;
- `--name acrpainelnuvemrodrigo2026`: define o nome do registro;
- `--sku Basic`: seleciona o plano Básico, adequado para estudos, testes e ambientes iniciais;
- `--admin-enabled false`: mantém desabilitada a conta administrativa local;
- `--dnl-scope TenantReuse`: protege contra reutilização indevida do nome DNS;
- `--role-assignment-mode rbac`: mantém compatibilidade com `AcrPush` e com o
  `AcrPull` configurado por `--attach-acr`.

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
acrpainelnuvemrodrigo2026-<hash>.azurecr.io
```
Esse endereço identifica o local onde as imagens Docker serão armazenadas. O
sufixo é esperado porque `TenantReuse` protege o nome DNS contra reutilização.

---

## 7. Registrar os valores do seu ambiente
Anote os valores abaixo. Eles serão utilizados na configuração do AKS e do GitHub Actions.

```
Grupo de recursos: rg-painel-nuvem
Localização: brazilsouth
Nome do ACR: acrpainelnuvemrodrigo2026
Endereço do ACR: <valor-loginServer-retornado-pela-Azure>
Nome do cluster AKS: será criado em etapa posterior
Namespace Kubernetes: aula-nuvem
Nome da imagem: painel-nuvem
```

> Dica de organização: mantenha esses valores em um arquivo de anotações. Evite alterar nomes depois de iniciar a configuração, pois eles serão usados em vários arquivos e comandos.

---

## 8. Criar o AKS Automatic e preparar o namespace

Somente depois da confirmação de custo, crie o cluster e vincule o ACR à
identidade kubelet. A opção `--attach-acr` concede `AcrPull` ao AKS; ela não
concede permissão de publicação ao GitHub Actions.

```bash
az aks create \
  --resource-group rg-painel-nuvem \
  --name aks-painel-nuvem \
  --location brazilsouth \
  --sku automatic \
  --enable-hosted-system

az aks update \
  --resource-group rg-painel-nuvem \
  --name aks-painel-nuvem \
  --attach-acr <nome-unico-do-acr>
```

Crie o namespace uma única vez no bootstrap como **Managed Namespace**. Essa
abordagem usa o plano de controle do Azure e dispensa conceder Cluster Admin à
identidade que executa o bootstrap:

```bash
az aks namespace add \
  --resource-group rg-painel-nuvem \
  --cluster-name aks-painel-nuvem \
  --name aula-nuvem \
  --cpu-request 500m \
  --cpu-limit 2000m \
  --memory-request 512Mi \
  --memory-limit 2Gi \
  --ingress-policy AllowAll \
  --egress-policy AllowAll \
  --delete-policy Delete \
  --labels finalidade=aula-implantacao-nuvem
```

O workflow não cria nem altera namespaces. Essa separação permite limitar sua
identidade ao namespace `aula-nuvem`.

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

## 9. Onde cadastrar os valores no GitHub
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

## Corrigir o erro `AZURE_CLIENT_ID` no GitHub Actions
O workflow foi interrompido porque o GitHub ainda não sabe **qual identidade pode acessar sua conta Azure**.

A solução é criar uma identidade de acesso na Azure e registrar o identificador dela no GitHub.

> Faça uma etapa por vez. Ao concluir uma etapa, marque o item antes de seguir para a próxima.

---

### Visão geral: o que vamos fazer

```
Azure cria uma identidade
        ↓
GitHub recebe o identificador dessa identidade
        ↓
Azure autoriza essa identidade no projeto
        ↓
GitHub Actions consegue publicar a aplicação
```

---

## Etapa 1 — Abrir o Microsoft Entra ID

1. Acesse [portal.azure.com](https://portal.azure.com/).
2. Na barra de pesquisa superior, pesquise por:

```
Microsoft Entra ID
```
3. Clique no resultado **Microsoft Entra ID**.
4. No menu lateral, clique em:

```
Registros de aplicativo
```
5. Clique em:

```
+ Novo registro
```

---

## Etapa 2 — Criar a identidade do GitHub Actions
Preencha a tela de criação desta forma:

```
Nome: github-actions-painel-nuvem
Tipos de conta com suporte: Contas somente neste diretório organizacional
URI de redirecionamento: deixe em branco
```
Clique em:

```
Registrar
```
A Azure abrirá a página da aplicação criada.

> Concluído: agora existe uma identidade específica para o GitHub Actions. Ela não é uma pessoa, senha ou usuário. É uma identidade técnica da aplicação.

---

## Etapa 3 — Copiar o Client ID
Na página da aplicação, localize:

```
ID do aplicativo (cliente)
```

1. Clique no ícone de cópia ao lado desse valor.
2. Guarde-o temporariamente em um local seguro.
Esse é o valor que será utilizado como `AZURE_CLIENT_ID`.

> Não use o campo **ID do objeto**. O valor correto é somente o campo **ID do aplicativo (cliente)**.

---

## Etapa 4 — Cadastrar o Client ID no GitHub

1. Abra o repositório do projeto no GitHub.
2. Acesse:

```
Settings → Secrets and variables → Actions
```
3. Na área **Repository secrets**, clique em:

```
New repository secret
```
4. Preencha:

```
Name: AZURE_CLIENT_ID
Secret: <cole-aqui-o-ID-do-aplicativo-cliente>
```
5. Clique em:

```
Add secret
```
Ao finalizar, a lista de secrets deve conter:

```
AZURE_CLIENT_ID
AZURE_SUBSCRIPTION_ID
AZURE_TENANT_ID
```

> Pare aqui por um momento: o erro `AZURE_CLIENT_ID` foi corrigido, mas o GitHub ainda precisa ser autorizado a usar essa identidade na Azure. Continue para a próxima etapa.

---

## Etapa 5 — Criar a credencial federada para o GitHub
A credencial federada permite que o GitHub Actions se autentique na Azure sem salvar uma senha permanente no repositório.

1. Volte à página da aplicação criada no **Microsoft Entra ID**.
2. No menu lateral, clique em:

```
Certificados e segredos
```
3. Clique na aba:

```
Credenciais federadas
```
4. Clique em:

```
+ Adicionar credencial
```
5. Em **Cenário de credencial federada**, escolha:

```
GitHub Actions implantando recursos do Azure
```
6. Preencha os dados do seu repositório:

```
Organização: <seu-usuário-ou-organização-no-github>
Repositório: <nome-do-repositório>
Tipo de entidade: Branch
Branch: main
Nome: github-actions-main
```
7. Clique em:

```
Adicionar
```

Confira os claims antes de salvar. Eles devem ser exatamente:

```text
issuer: https://token.actions.githubusercontent.com
audience: api://AzureADTokenExchange
subject: repo:rodrygofesantos/painel-nuvem:ref:refs/heads/main
```

Alternativa equivalente pela Azure CLI, usando o Client ID do aplicativo:

```bash
az ad app federated-credential create \
  --id <azure-client-id> \
  --parameters '{"name":"github-actions-main","issuer":"https://token.actions.githubusercontent.com","subject":"repo:rodrygofesantos/painel-nuvem:ref:refs/heads/main","audiences":["api://AzureADTokenExchange"]}'
```

O deploy manual também deve selecionar a branch `main`; outra ref não corresponde
ao `subject` federado e executa apenas o job de validação.

---

## Etapa 6 — Conceder acesso da identidade ao projeto na Azure
Agora a identidade do GitHub existe, mas ainda não possui autorização para acessar os recursos do projeto.

Não conceda `Contributor` no grupo de recursos. Obtenha o **Object ID** do
service principal (não o Client ID) e os escopos exatos:

```bash
GITHUB_SP_OBJECT_ID=$(az ad sp show --id <azure-client-id> --query id --output tsv)
ACR_ID=$(az acr show --name <nome-unico-do-acr> --resource-group rg-painel-nuvem --query id --output tsv)
AKS_ID=$(az aks show --name aks-painel-nuvem --resource-group rg-painel-nuvem --query id --output tsv)
NAMESPACE_ID=$(az aks namespace show --name aula-nuvem --cluster-name aks-painel-nuvem --resource-group rg-painel-nuvem --query id --output tsv)
```

Conceda somente:

```bash
az role assignment create \
  --assignee-object-id "$GITHUB_SP_OBJECT_ID" \
  --assignee-principal-type ServicePrincipal \
  --role AcrPush \
  --scope "$ACR_ID"

az role assignment create \
  --assignee-object-id "$GITHUB_SP_OBJECT_ID" \
  --assignee-principal-type ServicePrincipal \
  --role "Container Registry Configuration Reader and Data Access Configuration Reader" \
  --scope "$ACR_ID"

az role assignment create \
  --assignee-object-id "$GITHUB_SP_OBJECT_ID" \
  --assignee-principal-type ServicePrincipal \
  --role "Azure Kubernetes Service Cluster User Role" \
  --scope "$AKS_ID"

az role assignment create \
  --assignee-object-id "$GITHUB_SP_OBJECT_ID" \
  --assignee-principal-type ServicePrincipal \
  --role "Azure Kubernetes Service RBAC Writer" \
  --scope "$NAMESPACE_ID"
```

`AcrPush` permite publicar a imagem. A função de leitura de configuração
do ACR é adicional porque o workflow usa `az acr show` e `az acr login`, mas
continua restrita ao registro. `Cluster User Role` permite obter o kubeconfig.
`RBAC Writer`, restrita ao namespace, permite aplicar ConfigMap, Deployment e
Service; ela não permite alterar namespaces, Roles ou RoleBindings. Observe que
Writer pode ler Secrets do namespace, portanto não mantenha segredos de outras
aplicações em `aula-nuvem`.

---

## Etapa 7 — Executar o workflow novamente
Volte ao GitHub:

```
Actions → escolha o workflow → Re-run jobs
```
O erro referente a `AZURE_CLIENT_ID` não deverá mais aparecer.

---

## Checklist final
Antes de executar novamente o workflow, confira:

- Criei o registro de aplicativo `github-actions-painel-nuvem`;
- Copiei o campo **ID do aplicativo (cliente)**;
- Criei o secret `AZURE_CLIENT_ID` no GitHub;
- Cadastrei a credencial federada para o repositório e a branch correta;
- Concedi apenas as funções de ACR e AKS descritas acima, nos escopos exatos;
- Executei novamente o workflow.

> Segurança: não crie um “segredo do cliente” para este fluxo. A autenticação será feita pela **credencial federada do GitHub**, sem precisar guardar uma senha da Azure no repositório.

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
AZURE_AKS_CLUSTER=aks-painel-nuvem
AZURE_ACR_NAME=<nome-unico-do-acr>
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
