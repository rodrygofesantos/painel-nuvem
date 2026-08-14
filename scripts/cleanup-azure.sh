#!/usr/bin/env bash
# Remove os recursos Azure criados para o laboratório painel-nuvem,
# excluindo o grupo de recursos inteiro. Isso evita cobranças indevidas
# após o término da aula.
#
# ATENÇÃO: excluir o grupo de recursos remove TODOS os recursos contidos
# nele (AKS Automatic, ACR, discos, IPs públicos, etc.). Essa ação não
# pode ser desfeita.
#
# Uso:
#   ./scripts/cleanup-azure.sh
#
# Variável de ambiente aceita:
#   RESOURCE_GROUP (padrão: rg-painel-nuvem)

set -euo pipefail

RESOURCE_GROUP="${RESOURCE_GROUP:-rg-painel-nuvem}"

echo "==================================================================="
echo "LIMPEZA DE RECURSOS DO LABORATÓRIO painel-nuvem"
echo "==================================================================="
echo ""
echo "O grupo de recursos que será REMOVIDO é:"
echo ""
echo "    $RESOURCE_GROUP"
echo ""
echo "Isso inclui o cluster AKS Automatic, o Azure Container Registry e"
echo "qualquer outro recurso criado dentro deste grupo durante a aula."
echo ""
echo "O comando que será executado é:"
echo ""
echo "    az group delete --name \"$RESOURCE_GROUP\" --yes --no-wait"
echo ""
read -r -p "Digite exatamente o nome do grupo acima para confirmar a exclusão: " confirmacao

if [ "$confirmacao" != "$RESOURCE_GROUP" ]; then
  echo ""
  echo "Confirmação não corresponde ao nome do grupo. Operação cancelada."
  exit 1
fi

echo ""
echo "Confirmação recebida. Executando a exclusão..."
az group delete --name "$RESOURCE_GROUP" --yes --no-wait

echo ""
echo "Solicitação de exclusão enviada ao Azure (execução assíncrona, --no-wait)."
echo "Verifique no Portal do Azure se o grupo '$RESOURCE_GROUP' foi removido"
echo "por completo após alguns minutos."
