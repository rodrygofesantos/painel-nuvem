"use strict";

const path = require("node:path");
const os = require("node:os");
const express = require("express");

/**
 * Cria e configura a aplicação Express.
 * Mantemos essa função separada de server.js para que os testes
 * possam importar a aplicação sem precisar abrir uma porta de rede.
 */
function createApp() {
  const app = express();

  const appName = process.env.APP_NAME || "Painel de Implantação em Nuvem";
  const appVersion = process.env.APP_VERSION || "v1.0";
  const appEnvironment = process.env.APP_ENVIRONMENT || "local";

  // Desliga o cabeçalho "X-Powered-By" por boa prática básica de segurança.
  app.disable("x-powered-by");

  // Serve os arquivos estáticos da interface visual (HTML, CSS, JS do navegador).
  app.use(express.static(path.join(__dirname, "public")));

  // Endpoint de saúde: usado pelas probes do Kubernetes (readiness/liveness/startup)
  // e também pelos scripts de validação local.
  app.get("/healthz", (req, res) => {
    res.status(200).type("text/plain").send("ok");
  });

  // Endpoint de informações: usado pela interface visual para mostrar dados
  // sobre a versão e o ambiente em que a aplicação está executando.
  app.get("/api/info", (req, res) => {
    res.status(200).json({
      nome: appName,
      versao: appVersion,
      ambiente: appEnvironment,
      dataHora: new Date().toISOString(),
      hostname: os.hostname(),
    });
  });

  // Tratamento de rota não encontrada.
  app.use((req, res) => {
    res.status(404).json({ erro: "Recurso não encontrado" });
  });

  // Tratamento básico de erros inesperados.
  // eslint-disable-next-line no-unused-vars
  app.use((err, req, res, next) => {
    console.error("Erro inesperado na aplicação:", err);
    res.status(500).json({ erro: "Erro interno do servidor" });
  });

  return app;
}

module.exports = { createApp };
