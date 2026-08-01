"use strict";

const { createApp } = require("./app");

const PORT = Number(process.env.PORT) || 3000;
const HOST = "0.0.0.0";

const app = createApp();

const server = app.listen(PORT, HOST, () => {
  console.log(
    `[painel-nuvem] aplicação iniciada e escutando em http://${HOST}:${PORT}`
  );
});

/**
 * Encerramento controlado (graceful shutdown).
 * Isso é importante no Kubernetes: quando um Pod é encerrado, o cluster
 * envia SIGTERM e espera a aplicação parar de aceitar conexões novas
 * antes de finalizar o processo.
 */
function shutdown(signal) {
  console.log(`[painel-nuvem] sinal ${signal} recebido, encerrando servidor...`);
  server.close((err) => {
    if (err) {
      console.error("[painel-nuvem] erro ao encerrar o servidor:", err);
      process.exitCode = 1;
      return;
    }
    console.log("[painel-nuvem] servidor encerrado com sucesso.");
  });
}

process.on("SIGTERM", () => shutdown("SIGTERM"));
process.on("SIGINT", () => shutdown("SIGINT"));

module.exports = { server };
