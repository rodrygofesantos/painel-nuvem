#!/usr/bin/env bash
# Executa a validação completa do laboratório em ambiente local:
# instala dependências, roda os testes, sobe a aplicação sem contêiner,
# consulta /healthz, constrói a imagem Docker, executa o contêiner,
# consulta a aplicação containerizada e encerra tudo ao final.

set -euo pipefail

IMAGEM="painel-nuvem:v1.0"
CONTAINER="painel-nuvem-validacao"
PORTA="3000"

PID_SERVIDOR_LOCAL=""

limpar() {
  echo ""
  echo "Limpando processos e contêineres de validação..."

  if [ -n "$PID_SERVIDOR_LOCAL" ] && kill -0 "$PID_SERVIDOR_LOCAL" 2>/dev/null; then
    kill "$PID_SERVIDOR_LOCAL" 2>/dev/null || true
    wait "$PID_SERVIDOR_LOCAL" 2>/dev/null || true
  fi

  if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER}$"; then
    docker rm -f "$CONTAINER" > /dev/null 2>&1 || true
  fi
}
trap limpar EXIT

echo "1) Instalando dependências (npm ci)..."
npm ci

echo ""
echo "2) Executando testes automatizados (npm test)..."
npm test

echo ""
echo "3) Iniciando a aplicação localmente (sem contêiner)..."
PORT="$PORTA" npm start &
PID_SERVIDOR_LOCAL=$!

echo "   Aguardando a aplicação responder em /healthz..."
sucesso=0
for tentativa in $(seq 1 20); do
  if curl -fsS "http://localhost:${PORTA}/healthz" > /dev/null 2>&1; then
    sucesso=1
    break
  fi
  sleep 0.5
done

if [ "$sucesso" -eq 1 ]; then
  echo "   OK: /healthz respondeu com sucesso (execução local)."
else
  echo "   ERRO: /healthz não respondeu a tempo (execução local)."
  exit 1
fi

kill "$PID_SERVIDOR_LOCAL" 2>/dev/null || true
wait "$PID_SERVIDOR_LOCAL" 2>/dev/null || true
PID_SERVIDOR_LOCAL=""

echo ""
echo "4) Construindo a imagem Docker ($IMAGEM)..."
docker build -t "$IMAGEM" .

echo ""
echo "5) Executando o contêiner de validação..."
docker run --rm -d --name "$CONTAINER" -p "${PORTA}:3000" "$IMAGEM" > /dev/null

echo "   Aguardando o contêiner responder em /healthz..."
sucesso=0
for tentativa in $(seq 1 20); do
  if curl -fsS "http://localhost:${PORTA}/healthz" > /dev/null 2>&1; then
    sucesso=1
    break
  fi
  sleep 0.5
done

if [ "$sucesso" -eq 1 ]; then
  echo "   OK: /healthz respondeu com sucesso (contêiner)."
else
  echo "   ERRO: /healthz não respondeu a tempo (contêiner)."
  docker logs "$CONTAINER" || true
  exit 1
fi

echo ""
echo "Validação local concluída com sucesso!"
