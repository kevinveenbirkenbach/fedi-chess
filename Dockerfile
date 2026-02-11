# ------------------------------------------------------------
# fedi-chess - Multi-stage build for castling.club
# ------------------------------------------------------------

# -------- Base args (shared) --------
ARG CHESS_VERSION=20-bullseye
ARG CHESS_IMAGE=node

# ============================================================
# Stage 1: Build
# ============================================================
FROM ${CHESS_IMAGE}:${CHESS_VERSION} AS build

ARG CHESS_REPO_URL
ARG CHESS_REPO_REF

# Install minimal build deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    git ca-certificates openssl python3 build-essential \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /src

# Clone upstream
RUN git clone --depth 1 --branch "${CHESS_REPO_REF}" "${CHESS_REPO_URL}" ./

# ------------------------------------------------------------
# Enforce Yarn 4 and classic node_modules linker
# ------------------------------------------------------------
RUN corepack enable \
 && corepack prepare yarn@4.9.1 --activate

ENV YARN_NODE_LINKER=node-modules

# Install dependencies
RUN if [ -f yarn.lock ]; then \
      echo "[chess] yarn.lock found -> immutable install"; \
      corepack yarn install --immutable --inline-builds; \
    else \
      echo "[chess] yarn.lock missing -> normal install"; \
      corepack yarn install --inline-builds; \
    fi

# Build application
RUN corepack yarn build


# ============================================================
# Stage 2: Runtime
# ============================================================
FROM ${CHESS_IMAGE}:${CHESS_VERSION}

ARG CHESS_APP_DATA_DIR=/app/data
ARG CONTAINER_PORT=5080

WORKDIR /app

# Minimal runtime deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash dumb-init postgresql-client ca-certificates curl \
 && rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------
# Remove Yarn 1 binaries to avoid accidental usage
# ------------------------------------------------------------
RUN rm -f /usr/local/bin/yarn /usr/local/bin/yarnpkg || true

# Enable Yarn 4 again in runtime image
RUN corepack enable \
 && corepack prepare yarn@4.9.1 --activate

ENV YARN_NODE_LINKER=node-modules

# Copy built application
COPY --from=build /src /app

# Copy entrypoint
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Prepare writable directories
RUN mkdir -p ${CHESS_APP_DATA_DIR} /home/node \
 && chown -R node:node /app /home/node

ENV HOME=/home/node

USER node

EXPOSE ${CONTAINER_PORT}

ENTRYPOINT ["dumb-init", "--"]
CMD ["docker-entrypoint.sh"]
