# fedi-chess

Dockerized build of a federated chess server based on
[castling.club](https://github.com/stephank/castling.club).

This repository provides a reproducible container image tailored for
**Infinito.Nexus** deployments.

---

## ♟ About

`fedi-chess` builds and packages the federated chess server originally
developed by Stephan Köhler (GitHub: stephank) under the project:

→ https://github.com/stephank/castling.club

The upstream project implements a decentralized chess server using the
ActivityPub protocol, allowing games to federate across the Fediverse.

This repository does **not** reimplement the application.
It provides:

- A reproducible Docker image
- Deterministic Yarn 4 builds
- Production-ready runtime configuration
- PostgreSQL integration
- Compatibility with Infinito.Nexus orchestration

---

## 🧩 Purpose

This image was written specifically for integration into:

**Infinito.Nexus**  
https://github.com/kevinveenbirkenbach/infinito-nexus

The goal is to:

- Avoid on-host builds
- Ensure reproducible deployments
- Provide clean CI/CD integration
- Enable GHCR image publishing
- Standardize runtime behavior

---

## 🚀 Usage

```bash
cp env.example .env
make build
make up
````

The service will be available on:

[http://localhost:5080](http://localhost:5080)

---

## 🔐 Upstream Credits

Original software:

**castling.club**
Author: Stephan Köhler
GitHub: [https://github.com/stephank/castling.club](https://github.com/stephank/castling.club)

This repository builds upon that work and does not replace or modify
the upstream project beyond containerization and deployment concerns.

---

## 📜 License

This repository is licensed under the MIT License.

The upstream project (castling.club) retains its original license.
Please consult the upstream repository for its licensing terms.
