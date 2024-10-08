FROM node:16 as builder

WORKDIR /workspace

RUN apt-get update && \
    apt-get install -y git && \
    git clone --branch v3.4.0 https://github.com/joundy/janoside-btc-rpc-explorer.git .

RUN npm install

FROM node:16-alpine

WORKDIR /workspace

COPY --from=builder /workspace .

EXPOSE ${BTC_RPC_EXPLORER_PORT}

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:${BTC_RPC_EXPLORER_PORT}/ || exit 1

STOPSIGNAL SIGINT

CMD ["npm", "start"]