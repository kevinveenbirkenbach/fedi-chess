# ------------------------------------------------------------
# fedi-chess - Multi-stage build for castling.club
# ------------------------------------------------------------

# ============================================================
# Stage 1: Build
# ============================================================
FROM node:26-trixie@sha256:39cff0f037088f0d8faf3e5a3ca055d653a15b66faaba8af3daf72f0102f375f AS build

# Defaults are important for CI builds (GitHub Actions)
ARG CHESS_REPO_URL="https://github.com/stephank/castling.club.git"
ARG CHESS_REPO_REF="main"

RUN apt-get update && apt-get install -y --no-install-recommends \
    git ca-certificates openssl python3 build-essential \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /src
RUN git clone --depth 1 --branch "${CHESS_REPO_REF}" "${CHESS_REPO_URL}" ./

RUN npm ci

RUN npm run build

RUN npm prune --omit=dev \
 && npm audit fix --omit=dev --audit-level=none

# ============================================================
# Stage 2: Runtime
# ============================================================
FROM node:26-trixie@sha256:39cff0f037088f0d8faf3e5a3ca055d653a15b66faaba8af3daf72f0102f375f

ARG CHESS_APP_DATA_DIR=/app/data
ARG CONTAINER_PORT=5080

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash dumb-init postgresql-client ca-certificates curl \
 && rm -rf /var/lib/apt/lists/*

RUN rm -rf /usr/local/lib/node_modules/npm /usr/local/lib/node_modules/corepack \
    /usr/local/bin/npm /usr/local/bin/npx /usr/local/bin/corepack \
    /usr/local/bin/yarn /usr/local/bin/yarnpkg /opt/yarn-v*

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
