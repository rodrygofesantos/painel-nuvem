#!/usr/bin/env bash
# Verifica se as ferramentas necessárias para o laboratório estão instaladas.
# Este script apenas verifica e orienta: ele NÃO instala nada automaticamente.

set -uo pipefail

VERDE="\033[0;32m"
VERMELHO="\033[0;31m"
AMARELO="\033[0;33m"
SEM_COR="\033[0m"

algum_erro=0

verificar_comando() {
  local nome="$1"
  local comando="$2"
  local comando_versao="$3"
  local dica_instalacao="$4"

  if command -v "$comando" > /dev/null 2>&1; then
    local versao
    versao=$($comando_versao 2>&1 | head -n 1)
    echo -e "${VERDE}[OK]${SEM_COR} $nome encontrado — $versao"
  else
    echo -e "${VERMELHO}[FALTANDO]${SEM_COR} $nome não foi encontrado."
    echo -e "           ${AMARELO}Sugestão:${SEM_COR} $dica_instalacao"
    algum_erro=1
  fi
}

echo "Verificando pré-requisitos do laboratório painel-nuvem..."
echo ""

verificar_comando "Git" "git" "git --version" \
  "instale em https://git-scm.com/downloads"

verificar_comando "Node.js" "node" "node --version" \
  "instale a versão 24 em https://nodejs.org/"

verificar_comando "NPM" "npm" "npm --version" \
  "o NPM é instalado junto com o Node.js"

verificar_comando "Docker" "docker" "docker --version" \
  "instale o Docker Desktop em https://www.docker.com/products/docker-desktop/"

verificar_comando "Azure CLI" "az" "az version" \
  "instale em https://learn.microsoft.com/cli/azure/install-azure-cli"

verificar_comando "kubectl" "kubectl" "kubectl version --client" \
  "instale em https://kubernetes.io/docs/tasks/tools/"

echo ""
echo "Verificando se o daemon do Docker está em execução..."
if docker info > /dev/null 2>&1; then
  echo -e "${VERDE}[OK]${SEM_COR} Docker está em execução."
else
  echo -e "${VERMELHO}[FALTANDO]${SEM_COR} Docker não está respondendo."
  echo -e "           ${AMARELO}Sugestão:${SEM_COR} abra o Docker Desktop e aguarde ele iniciar."
  algum_erro=1
fi

echo ""
if [ "$algum_erro" -eq 0 ]; then
  echo -e "${VERDE}Tudo certo! Todas as ferramentas necessárias foram encontradas.${SEM_COR}"
else
  echo -e "${AMARELO}Atenção: revise os itens marcados como FALTANDO antes de continuar.${SEM_COR}"
fi

exit "$algum_erro"
