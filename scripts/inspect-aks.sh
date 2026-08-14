#!/usr/bin/env bash
# Inspeciona os recursos do laboratório painel-nuvem em execução no AKS Automatic.
# Útil para os alunos verificarem Pods, Deployments, Services, eventos e logs
# durante e depois da implantação feita pelo GitHub Actions.
#
# Uso:
#   ./scripts/inspect-aks.sh
#
# Variáveis de ambiente aceitas (todas têm valores padrão do laboratório):
#   RESOURCE_GROUP  (padrão: rg-painel-nuvem)
#   AKS_CLUSTER     (padrão: aks-painel-nuvem)
#   NAMESPACE       (padrão: aula-nuvem)

set -euo pipefail

RESOURCE_GROUP="${RESOURCE_GROUP:-rg-painel-nuvem}"
AKS_CLUSTER="${AKS_CLUSTER:-aks-painel-nuvem}"
NAMESPACE="${NAMESPACE:-aula-nuvem}"

separador() {
  echo ""
  echo "==================================================================="
  echo "$1"
  echo "==================================================================="
}

separador "Obtendo credenciais do cluster $AKS_CLUSTER (grupo $RESOURCE_GROUP)"
az aks get-credentials \
  --resource-group "$RESOURCE_GROUP" \
  --name "$AKS_CLUSTER" \
  --overwrite-existing

separador "Pods no namespace $NAMESPACE"
kubectl get pods -n "$NAMESPACE" -o wide

separador "Deployments no namespace $NAMESPACE"
kubectl get deployments -n "$NAMESPACE"

separador "Services no namespace $NAMESPACE"
kubectl get services -n "$NAMESPACE"

separador "Eventos recentes no namespace $NAMESPACE"
kubectl get events -n "$NAMESPACE" --sort-by=.lastTimestamp

separador "Status do rollout do Deployment painel-nuvem"
kubectl rollout status deployment/painel-nuvem -n "$NAMESPACE" --timeout=30s || true

separador "Últimas linhas de log do Deployment painel-nuvem"
kubectl logs deployment/painel-nuvem -n "$NAMESPACE" --tail=50 || true

separador "Inspeção concluída"
echo "Para acompanhar o IP externo em tempo real, execute:"
echo "  kubectl get service painel-nuvem -n $NAMESPACE --watch"
