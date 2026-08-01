# Painel Nuvem

Este projeto é um exemplo didático de uma aplicação Node.js com Express, containerizada com Docker e preparada para ser implantada em ambientes de nuvem com GitHub Actions e Kubernetes.

O objetivo é mostrar, de forma prática, como executar a aplicação localmente e, em seguida, empacotá-la, versioná-la e implantá-la em diferentes sistemas operacionais.

## O que este projeto faz

- roda uma aplicação web localmente em Node.js;
- expõe endpoints de saúde e informações;
- pode ser executada em containers Docker;
- pode ser publicada no GitHub e utilizada em pipelines de CI/CD;
- serve como base para implantação em Azure AKS.

## Requisitos

Antes de começar, instale estas ferramentas:

- Git
- Node.js 24
- npm
- Docker Desktop ou Docker Engine
- Azure CLI (opcional, para implantação na nuvem)
- kubectl (opcional, para Kubernetes)
- VS Code (recomendado)

### Linux

- Instale o Node.js e o Docker conforme a distribuição usada.
- Para Ubuntu/Debian, normalmente é suficiente usar os repositórios oficiais ou o gerenciador de pacotes da distro.
- O Docker pode ser instalado com o Docker Engine ou Docker Desktop, conforme a sua preferência.

### macOS

- Recomenda-se usar Homebrew para instalar Node.js e Docker Desktop.
- Exemplo:

```bash
brew install node
brew install --cask docker
```

### Windows

- Instale o Node.js LTS no site oficial.
- Instale o Docker Desktop com suporte a WSL 2.
- Abra um terminal PowerShell ou Windows Terminal após a instalação.

## Verificar se o ambiente está pronto

### Linux/macOS

```bash
./scripts/check-prerequisites.sh
```

### Windows (PowerShell)

```powershell
./scripts/check-prerequisites.ps1
```

Você também pode validar manualmente com:

```bash
git --version
node --version
npm --version
docker --version
```

## Clonar e instalar dependências

```bash
git clone https://github.com/rodrygofesantos/painel-nuvem.git
cd painel-nuvem
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

Depois disso, abra no navegador:

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

Para confirmar que a imagem foi criada:

```bash
docker images painel-nuvem
```

## Rodar o container localmente

### Linux/macOS

```bash
docker run --rm -d --name painel-nuvem -p 3000:3000 painel-nuvem:v1.0
```

### Windows (PowerShell)

```powershell
docker run --rm -d --name painel-nuvem -p 3000:3000 painel-nuvem:v1.0
```

Para acompanhar o container:

```bash
docker ps
docker logs painel-nuvem
```

Para parar:

```bash
docker stop painel-nuvem
```

## Publicar no GitHub

```bash
git init
git add .
git commit -m "Initial commit"
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

O repositório também inclui arquivos para integração com GitHub Actions e Kubernetes. Para implantar na Azure, siga os passos de configuração do workflow e dos manifestos em `manifests/`.

Fluxo básico:

1. criar conta e acesso na Azure;
2. configurar o GitHub Actions com as credenciais adequadas;
3. fazer o push do código;
4. acompanhar o deployment no GitHub Actions;
5. validar o serviço no cluster AKS.

## Dicas rápidas

- Se a porta 3000 estiver ocupada, troque a porta no comando do Docker ou encerre o processo conflitante.
- Em Windows, use PowerShell para executar os scripts `.ps1`.
- Em Linux e macOS, use o terminal Bash/Zsh para executar os scripts `.sh`.
- Se o Docker não iniciar, verifique se o Docker Desktop está aberto e com o daemon ativo.

| Falha no `npm ci` | `package-lock.json` ausente ou desatualizado em relação ao `package.json` | Comparar as duas versões do arquivo | Rodar `npm install` localmente para regenerar o lockfile e commitar a atualização |
| Falha no Docker build | Erro de sintaxe no Dockerfile ou contexto incorreto | Ler a mensagem de erro exibida pelo `docker build` | Corrigir a instrução indicada e rodar novamente |
| Erro de autenticação GitHub | Token de push expirado ou remoto incorreto | `git remote -v` | Reconfigurar a URL do remoto ou reautenticar (`gh auth login` ou credencial do Git) |
| Erro OIDC | Credencial federada não configurada ou branch/repositório não correspondem | Revisar a credencial federada no Entra ID | Corrigir o repositório/branch cadastrados na credencial federada |
| `Unauthorized` | Identidade sem permissão suficiente ou token inválido | Logs do passo `azure/login` no workflow | Revisar papéis (roles) atribuídos à identidade no Azure |
| `Forbidden` | Identidade autenticada, mas sem permissão para a ação específica | Mensagem detalhada do `az` ou `kubectl` | Conceder o papel RBAC adequado no recurso correto |
| `ImagePullBackOff` | Imagem inexistente na tag informada, ou cluster sem permissão para o ACR | `kubectl describe pod <nome> -n aula-nuvem` | Confirmar que o push da imagem foi concluído e que o AKS tem acesso ao ACR |
| `ErrImagePull` | Nome de imagem ou tag incorretos no manifesto | `kubectl describe pod <nome> -n aula-nuvem` | Corrigir o valor substituído no lugar de `IMAGE_PLACEHOLDER` |
| `CrashLoopBackOff` | A aplicação está encerrando logo após iniciar | `kubectl logs <pod> -n aula-nuvem --previous` | Corrigir o erro indicado nos logs da aplicação |
| `EXTERNAL-IP` como `pending` | Provisionamento do balanceador de carga ainda em andamento | `kubectl get service painel-nuvem -n aula-nuvem --watch` | Aguardar alguns minutos; se persistir, verificar cotas de IP público na assinatura |
| Falha de readiness probe | Aplicação demorando para iniciar ou `/healthz` respondendo erro | `kubectl describe pod <nome> -n aula-nuvem` | Verificar logs da aplicação e, se necessário, aumentar `failureThreshold` no manifesto |
| Workflow não iniciado | Push não foi feito na branch monitorada, ou Actions desabilitado no repositório | Guia Actions do GitHub | Confirmar branch `main` e que Actions está habilitado nas configurações do repositório |
| Branch incorreta | Push feito em uma branch diferente de `main` | `git branch --show-current` | Fazer merge/push para `main` |
| Namespace incorreto | Comandos `kubectl` executados sem `-n aula-nuvem` | Saída vazia ou "not found" | Sempre incluir `-n aula-nuvem` nos comandos |
| Aplicação ainda mostrando versão antiga | Rollout ainda em andamento, ou cache do navegador | `kubectl rollout status deployment/painel-nuvem -n aula-nuvem` | Aguardar o rollout terminar e atualizar a página |
| Cache do navegador | O navegador reutilizou uma resposta antiga | Comparar com uma aba anônima | Atualizar com `Ctrl+F5` / `Cmd+Shift+R` ou usar aba anônima |

## 19. Segurança

- Nunca armazene segredos (senhas, tokens, chaves) diretamente no Git.
- Prefira sempre OIDC a um client secret quando o provedor de nuvem oferecer suporte.
- Utilize permissões mínimas necessárias (princípio do menor privilégio) para a identidade usada pelo GitHub Actions.
- Revise os arquivos gerados automaticamente por assistentes do Portal do Azure antes de aceitar um Pull Request.
- Não execute o contêiner da aplicação como usuário `root` (este projeto já usa o usuário `node` no Dockerfile e `runAsNonRoot` no manifesto).
- Utilize probes (`readinessProbe`, `livenessProbe`, `startupProbe`) para que o Kubernetes só envie tráfego a Pods realmente prontos.
- Defina limites de recursos (`resources.requests` e `resources.limits`) para evitar que um Pod consuma recursos além do razoável.
- Utilize tags imutáveis baseadas no SHA do commit para as imagens implantadas.
- Evite depender exclusivamente da tag `latest`, que pode mudar de conteúdo sem aviso.
- Não exiba IDs de assinatura, tokens ou outros valores sensíveis durante a aula (inclusive em capturas de tela).
- Não conceda permissões administrativas apenas para "fazer o erro sumir" — investigue a causa raiz do erro de permissão.

## 20. Custos e limpeza

> ⚠️ **Atenção:** os recursos criados neste laboratório (AKS Automatic, ACR, IP público, discos) podem gerar cobrança na assinatura Azure enquanto estiverem ativos. Remova-os assim que a aula terminar.

```bash
az group delete \
  --name rg-aula-aks-auto \
  --yes \
  --no-wait
```

Este comando **exclui todo o grupo de recursos** `rg-aula-aks-auto`, incluindo o cluster AKS Automatic, o Azure Container Registry e qualquer outro recurso criado dentro dele durante o laboratório. Essa ação não pode ser desfeita.

Você também pode usar o script pronto, que pede confirmação explícita antes de executar:

```bash
./scripts/cleanup-azure.sh
```

Depois de alguns minutos, acesse o **Portal do Azure** e confirme que o grupo de recursos `rg-aula-aks-auto` não aparece mais na lista de grupos de recursos, indicando que a exclusão foi concluída.

## 21. Referências

- Node.js — https://nodejs.org/en/docs
- Express — https://expressjs.com/
- Docker — https://docs.docker.com/
- Kubernetes — https://kubernetes.io/docs/home/
- GitHub Actions — https://docs.github.com/actions
- GitHub OIDC com Azure — https://learn.microsoft.com/azure/developer/github/connect-from-azure
- Azure Container Registry — https://learn.microsoft.com/azure/container-registry/
- Azure Kubernetes Service (AKS) — https://learn.microsoft.com/azure/aks/
- AKS Automatic — https://learn.microsoft.com/azure/aks/intro-aks-automatic
- Azure CLI — https://learn.microsoft.com/cli/azure/
- Gateway API (Kubernetes) — https://gateway-api.sigs.k8s.io/
