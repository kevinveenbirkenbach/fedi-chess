#!/usr/bin/env bash
set -euo pipefail

COMPOSE="${COMPOSE:-docker compose}"
URL="${E2E_URL:-http://127.0.0.1:5080/}"
TIMEOUT_S="${E2E_TIMEOUT_S:-120}"

log() { echo "[e2e] $*"; }

cleanup() {
  log "teardown (compose down -v --remove-orphans)"
  ${COMPOSE} down -v --remove-orphans >/dev/null 2>&1 || true
}
trap cleanup EXIT

log "build"
${COMPOSE} build --pull

log "up"
${COMPOSE} up -d

log "waiting up to ${TIMEOUT_S}s for HTTP 200: ${URL}"
deadline=$(( $(date +%s) + TIMEOUT_S ))

while true; do
  code="$(curl -sS -o /dev/null -w "%{http_code}" "${URL}" || true)"

  if [[ "${code}" == "200" ]]; then
    log "OK: got HTTP 200"
    exit 0
  fi

  if (( $(date +%s) >= deadline )); then
    log "FAILED: expected 200, got ${code} (or no response) after ${TIMEOUT_S}s"
    log "---- docker compose ps ----"
    ${COMPOSE} ps || true
    log "---- docker compose logs (tail) ----"
    ${COMPOSE} logs --tail=200 || true
    exit 1
  fi

  sleep 2
done
