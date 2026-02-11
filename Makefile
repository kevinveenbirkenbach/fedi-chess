.ONESHELL:
SHELL := /bin/bash
.SHELLFLAGS := -euo pipefail -c

COMPOSE ?= docker compose
PROJECT ?= fedi-chess

.DEFAULT_GOAL := help

.PHONY: help build up down restart logs clean

help:
	@echo ""
	@echo "fedi-chess development commands"
	@echo ""
	@echo "  make build     Build the Docker image"
	@echo "  make up        Start the stack (detached)"
	@echo "  make down      Stop the stack"
	@echo "  make restart   Restart the stack"
	@echo "  make logs      Follow container logs"
	@echo "  make clean     Remove containers and volumes"
	@echo ""

# ------------------------------------------------------------
# Build image
# ------------------------------------------------------------
build:
	$(COMPOSE) build --pull

# ------------------------------------------------------------
# Start services
# ------------------------------------------------------------
up:
	$(COMPOSE) up -d

# ------------------------------------------------------------
# Stop services
# ------------------------------------------------------------
down:
	$(COMPOSE) down

restart:
	$(COMPOSE) down
	$(COMPOSE) up -d

# ------------------------------------------------------------
# Logs
# ------------------------------------------------------------
logs:
	$(COMPOSE) logs -f --tail=200

# ------------------------------------------------------------
# Clean everything (incl. volumes)
# ------------------------------------------------------------
clean:
	$(COMPOSE) down -v --remove-orphans

.PHONY: e2e
e2e:
	bash tests/e2e.sh
