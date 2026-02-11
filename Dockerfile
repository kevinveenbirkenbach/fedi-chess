# ------------------------------------------------------------
# fedi-chess - Multi-stage build for castling.club
# ------------------------------------------------------------

ARG CHESS_VERSION=20-bullseye
ARG CHESS_IMAGE=node

# ============================================================
# Stage 1: Build
# ============================================================
FROM ${CHESS_IMAGE}:${CHESS_VERSION} AS build

# Defaults are important for CI builds (GitHub Actions)
ARG CHESS_REPO_URL="https://github.com/stephank/castling.club.git"
ARG CHESS_REPO_REF="main"

RUN apt-get update && apt-get install -y --no-install-recommends \
    git ca-certificates openssl python3 build-essential \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /src
RUN git clone --depth 1 --branch "${CHESS_REPO_REF}" "${CHESS_REPO_URL}" ./

RUN corepack enable \
 && corepack prepare yarn@4.9.1 --activate

ENV YARN_NODE_LINKER=node-modules

RUN if [ -f yarn.lock ]; then \
      echo "[chess] yarn.lock found -> immutable install"; \
      corepack yarn install --immutable --inline-builds; \
    else \
      echo "[chess] yarn.lock missing -> normal install"; \
      corepack yarn install --inline-builds; \
    fi

RUN corepack yarn build

# ============================================================
# Stage 2: Runtime
# ============================================================
FROM ${CHESS_IMAGE}:${CHESS_VERSION}

ARG CHESS_APP_DATA_DIR=/app/data
ARG CONTAINER_PORT=5080

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash dumb-init postgresql-client ca-certificates curl \
 && rm -rf /var/lib/apt/lists/*

# Remove Yarn 1 binaries to avoid accidental usage
RUN rm -f /usr/local/bin/yarn /usr/local/bin/yarnpkg /usr/bin/yarn /usr/bin/yarnpkg || true

RUN corepack enable \
 && corepack prepare yarn@4.9.1 --activate

ENV YARN_NODE_LINKER=node-modules

COPY --from=build /src /app
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN mkdir -p ${CHESS_APP_DATA_DIR} /home/node \
 && chown -R node:node /app /home/node

ENV HOME=/home/node
USER node

EXPOSE ${CONTAINER_PORT}

ENTRYPOINT ["dumb-init", "--"]
CMD ["docker-entrypoint.sh"]
