"use strict";

const test = require("node:test");
const assert = require("node:assert/strict");
const { createApp } = require("../app");

/**
 * Sobe a aplicação em uma porta aleatória do sistema operacional (porta 0)
 * apenas durante o teste, e garante que o servidor é encerrado no final.
 */
function iniciarServidorDeTeste() {
  const app = createApp();
  const server = app.listen(0);
  const { port } = server.address();
  return { server, baseUrl: `http://127.0.0.1:${port}` };
}

test("GET /healthz responde 200 com o texto ok", async () => {
  const { server, baseUrl } = iniciarServidorDeTeste();
  try {
    const resposta = await fetch(`${baseUrl}/healthz`);
    const corpo = await resposta.text();

    assert.equal(resposta.status, 200);
    assert.equal(corpo, "ok");
  } finally {
    server.close();
  }
});

test("GET /api/info responde 200 com JSON contendo os campos esperados", async () => {
  const { server, baseUrl } = iniciarServidorDeTeste();
  try {
    const resposta = await fetch(`${baseUrl}/api/info`);
    const dados = await resposta.json();

    assert.equal(resposta.status, 200);
    assert.equal(resposta.headers.get("content-type").includes("application/json"), true);
    assert.equal(typeof dados.nome, "string");
    assert.equal(typeof dados.versao, "string");
    assert.equal(typeof dados.ambiente, "string");
    assert.equal(typeof dados.dataHora, "string");
    assert.equal(typeof dados.hostname, "string");
  } finally {
    server.close();
  }
});

test("GET /rota-inexistente responde 404", async () => {
  const { server, baseUrl } = iniciarServidorDeTeste();
  try {
    const resposta = await fetch(`${baseUrl}/rota-inexistente`);
    assert.equal(resposta.status, 404);
  } finally {
    server.close();
  }
});
