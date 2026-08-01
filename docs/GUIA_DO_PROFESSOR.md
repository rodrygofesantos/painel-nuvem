# Guia do professor — painel-nuvem

Este documento é um roteiro de condução da prática, não um conjunto de slides. Ele foi escrito para ser consultado durante a aula, com os pontos que precisam ser explicados antes de cada bloco de comandos.

## Objetivo pedagógico

Fazer com que o aluno compreenda, de forma prática e sequencial, a diferença entre **executar** uma aplicação e **implantá-la**, percorrendo o caminho completo: código local → contêiner → registro de imagens → cluster Kubernetes gerenciado → acesso público. O foco não é ensinar Kubernetes em profundidade, e sim dar uma visão coerente do fluxo de implantação em nuvem, usando o AKS Automatic como exemplo de nuvem pública.

## Público-alvo

Turma heterogênea, com alunos de Tecnologia da Informação e de outras áreas, cursando a disciplina de Implantação de Software em Nuvem Privada e Nuvem Pública. Nem todos os alunos terão experiência prévia com linha de comando, Docker ou Kubernetes — a condução deve equilibrar profundidade técnica com clareza conceitual.

## Duração estimada

3h30 a 4h, incluindo pausas e tempo de espera do provisionamento de recursos Azure (a criação do AKS Automatic e a atribuição do IP público podem levar de 5 a 15 minutos cada).

## Divisão da prática em etapas

| Etapa | Conteúdo | Tempo aproximado |
| --- | --- | --- |
| 1 | Apresentação do fluxo e dos conceitos fundamentais (seção 2 e 3 do README) | 20 min |
| 2 | Checkpoint 1 e 2 — executar e testar localmente | 20 min |
| 3 | Checkpoint 3 e 4 — construir e executar a imagem Docker | 25 min |
| 4 | Checkpoint 5 — publicar no GitHub | 15 min |
| 5 | Preparação do Azure e criação do ACR | 25 min |
| 6 | Criação do AKS Automatic pelo Portal | 30 a 45 min (inclui espera de provisionamento) |
| 7 | Configuração do OIDC (Secrets e Variables) | 25 min |
| 8 | Checkpoint 6 e 7 — primeiro deploy e verificação no cluster | 30 min |
| 9 | Checkpoint 8 — atualização de v1.0 para v1.1 | 20 min |
| 10 | Limpeza dos recursos e encerramento | 15 min |

## Checkpoints para sincronizar a turma

Use os checkpoints do README (`Checkpoint 1` a `Checkpoint 8`) como pontos de sincronização: antes de avançar para o próximo bloco de comandos, confirme verbalmente que a maioria da turma concluiu o checkpoint atual. Alunos mais rápidos podem ser convidados a ajudar colegas com dificuldade, o que também reforça o próprio aprendizado.

## Pontos que devem ser explicados antes dos comandos

- Antes do Checkpoint 3 (Docker): explique a diferença entre imagem e contêiner antes de rodar `docker build`. Muitos alunos confundem os dois termos.
- Antes da seção de preparação do Azure: reforce que a criação de recursos pode gerar custo, mesmo em contas de testes/free tier, e que o grupo de recursos será removido ao final.
- Antes da criação do AKS Automatic: explique o que é um cluster gerenciado e por que o AKS Automatic reduz a quantidade de decisões de configuração que o aluno precisaria tomar manualmente.
- Antes da configuração do OIDC: explique o conceito de autenticação federada com uma analogia simples (ex.: um crachá de visitante temporário, emitido a cada visita, em vez de uma chave permanente da casa).
- Antes do Checkpoint 8 (atualização de versão): reforce que o mesmo pipeline que fez o primeiro deploy é o que executa a atualização — não há um processo manual separado.

## Perguntas que podem ser feitas aos alunos

- "Qual é a diferença entre rodar `npm start` na sua máquina e o que acontece quando fazemos `git push`?"
- "Por que a aplicação tem dois arquivos (`app.js` e `server.js`) em vez de um só?"
- "O que aconteceria se o Service não existisse e só tivéssemos os Pods?"
- "Por que usamos uma tag de imagem baseada no commit, em vez de sempre usar `latest`?"
- "O que o OIDC evita que uma senha fixa não evitaria?"
- "O que aconteceria com a aplicação se apagássemos um dos dois Pods manualmente?" (Boa oportunidade para demonstrar `kubectl delete pod` e observar o Deployment recriar o Pod.)

## Resultado esperado em cada etapa

- **Execução local:** página carrega em `http://localhost:3000`, `/healthz` retorna `ok`, `/api/info` retorna JSON válido.
- **Docker local:** contêiner responde da mesma forma que a execução local, na mesma porta.
- **GitHub:** repositório criado e código publicado na branch `main`.
- **Azure (ACR/AKS):** recursos criados dentro do grupo `rg-aula-aks-auto`, visíveis no Portal.
- **Primeiro deploy:** workflow do GitHub Actions conclui com sucesso, Pods em estado `Running`, Service com `EXTERNAL-IP` atribuído.
- **Atualização v1.1:** novo workflow executado automaticamente após o `push`, rollout concluído sem downtime perceptível, página exibindo a nova versão.

## Erros que podem ser simulados com segurança

Estes erros são seguros de reproduzir em aula porque são reversíveis e não afetam recursos fora do namespace do laboratório:

- Alterar temporariamente a porta em `manifests/service.yaml` para um valor incorreto e mostrar o efeito no acesso externo.
- Digitar errado o nome da imagem no `IMAGE_PLACEHOLDER` manualmente (fora do pipeline) para provocar um `ErrImagePull` e demonstrar o diagnóstico.
- Escalar o Deployment para `0` réplicas (`kubectl scale deployment/painel-nuvem -n aula-nuvem --replicas=0`) e mostrar o Service sem endpoints disponíveis, depois voltar para `2`.
- Apagar um Pod manualmente e observar o Deployment recriá-lo automaticamente.

Evite simular erros de autenticação OIDC ou de permissão do Azure em produção real da instituição — prefira apenas descrever esses cenários usando a tabela de diagnóstico do README.

## Orientações para não expor dados sensíveis

- Nunca exiba o conteúdo de `AZURE_CLIENT_ID`, `AZURE_TENANT_ID` ou `AZURE_SUBSCRIPTION_ID` na tela projetada; ao cadastrar os Secrets, cubra a tela ou faça esse cadastro previamente, fora do horário de projeção.
- Utilize uma conta Azure de demonstração preparada especificamente para a aula, sem acesso a outros recursos sensíveis da instituição.
- Ao compartilhar a tela para mostrar o Portal do Azure, feche outras abas ou aplicações que possam expor informações não relacionadas à aula.

## Plano alternativo quando os alunos não tiverem assinatura Azure

- Alunos sem assinatura Azure podem concluir integralmente os Checkpoints 1 a 5 (execução local, testes, Docker e publicação no GitHub), que já demonstram grande parte do fluxo de containerização.
- Para a parte de Azure (ACR, AKS, OIDC), esses alunos podem acompanhar a demonstração feita pelo professor com a conta preparada, ou formar dupla com um colega que tenha assinatura ativa.
- Caso a instituição disponibilize uma assinatura Azure compartilhada para fins acadêmicos, o professor pode usá-la como alternativa, desde que cada aluno utilize um namespace ou prefixo de nome diferente para evitar conflitos entre os recursos da turma.

## Recomendação de demonstrar o Azure com uma conta preparada

Para turmas grandes ou aulas mais curtas, é recomendável que o professor execute a criação do ACR, do AKS Automatic e a configuração do OIDC previamente, com uma conta de demonstração, e mostre o resultado já funcionando, complementando com a leitura guiada dos comandos do README. Isso evita que o tempo de provisionamento da Azure (que pode levar minutos) consuma o tempo da aula.

## Orientação para disponibilizar previamente o repositório quando a aula for mais curta

Se a carga horária disponível for menor que o estimado (3h30–4h), disponibilize o repositório `painel-nuvem` já publicado no GitHub antes da aula, e peça que os alunos façam um `git clone` em vez de `git init` + primeiro commit. Isso permite pular diretamente para os Checkpoints 6, 7 e 8, focando o tempo de aula na parte de nuvem pública.

## Roteiro para atualizar a aplicação de v1.0 para v1.1

1. Relembre a turma de que a alteração será mínima: apenas o valor de `APP_VERSION` no ConfigMap (`manifests/configmap.yaml`) e, opcionalmente, uma mensagem de status na interface.
2. Peça que cada aluno faça a alteração no seu próprio fork/repositório.
3. Rode `npm test` antes de commitar, reforçando o hábito de testar antes de publicar.
4. Acompanhe, junto com a turma, a execução do workflow na guia Actions.
5. Use `kubectl rollout status` para mostrar, em tempo real, a substituição gradual dos Pods antigos pelos novos (RollingUpdate).
6. Atualize a página no navegador para confirmar a nova versão — se necessário, explique o efeito do cache do navegador (`Ctrl+F5` / `Cmd+Shift+R`).

## Orientação para excluir os recursos no encerramento

Reserve os últimos 15 minutos da aula para a limpeza dos recursos Azure, mesmo que isso signifique cortar algum conteúdo opcional. Execute (ou peça que cada aluno execute, se tiver criado recursos próprios):

```bash
./scripts/cleanup-azure.sh
```

Confirme, junto com a turma, que o comando pede confirmação explícita antes de excluir. Reforce que a exclusão do grupo de recursos `rg-aula-aks-auto` remove **todos** os recursos criados durante o laboratório, e que essa etapa é obrigatória para evitar cobranças após o término da aula. Recomende que cada aluno confirme, no Portal do Azure, que o grupo de recursos realmente desapareceu antes de encerrar a sessão.
