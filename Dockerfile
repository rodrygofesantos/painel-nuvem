# Dockerfile didático para o projeto painel-nuvem.
# Utiliza uma imagem Alpine (leve) do Node.js 24, adequada para aulas
# e para publicação em registros de contêiner como o Azure Container Registry.

FROM node:24-alpine

# Diretório de trabalho dentro do contêiner.
WORKDIR /app

# Variáveis de ambiente padrão da imagem. Podem ser sobrescritas no
# Deployment do Kubernetes por meio do ConfigMap do laboratório.
ENV NODE_ENV=production
ENV PORT=3000

# Copiamos primeiro apenas os arquivos de dependências para aproveitar
# o cache de camadas do Docker: se o código mudar mas as dependências
# não, o "npm ci" não precisa ser executado novamente.
COPY package.json package-lock.json ./

# Instala somente as dependências de produção, de forma reprodutível.
RUN npm ci --omit=dev

# Copia o restante do código-fonte já atribuindo a propriedade dos
# arquivos ao usuário não privilegiado "node", que já existe na imagem
# node:24-alpine.
COPY --chown=node:node app.js server.js ./
COPY --chown=node:node public ./public

# Executa a aplicação como usuário não privilegiado, evitando execução como root.
USER node

# Documenta a porta utilizada pela aplicação dentro do contêiner.
EXPOSE 3000

# Verificação de saúde: o Docker consulta periodicamente o endpoint /healthz
# para saber se o contêiner está respondendo corretamente.
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/healthz', (res) => { process.exit(res.statusCode === 200 ? 0 : 1); }).on('error', () => process.exit(1));"

# Comando de inicialização da aplicação.
CMD ["npm", "start"]
