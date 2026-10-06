# Changelog

## [1.2.0] - 2026-10-06

* Moved the base image from Node 24 to Node 26 and pinned it by digest.
* The image is now built with npm from the upstream package-lock.json instead
  of Yarn. Node 25 and later no longer ship Corepack, which broke the build.
* The runtime image no longer contains npm, npx, Corepack or Yarn. The
  entrypoint starts the migration and the server directly with Node.
* The Compose file now uses Postgres 18 and mounts its volume at
  /var/lib/postgresql. A local volume created with Postgres 16 is not migrated.
* Updated the GitHub Actions used by the workflows and aligned all parts of the
  CodeQL action on one version.
* Dependabot now updates the parts of the CodeQL action together.

## [1.1.0] - 2026-10-06

* Moved the base image from Node 20 on Debian bullseye to Node 24 on Debian
  trixie. Debian bullseye reached end of life and the old base no longer built.
* Images are now published for amd64 and arm64, each built on a native runner.
* A release publishes the image under its version tag. The latest tag follows
  the highest version and is no longer overwritten by ordinary pushes.
* Removed the build arguments CHESS_IMAGE and CHESS_VERSION. The base image is
  now fixed in the Dockerfile.
* Dependabot now updates the GitHub Actions, the base image and the Compose
  images.
* Added CodeQL, OpenSSF Scorecard, a Trivy image scan, dependency review and a
  security policy.

## [1.0.1] - 2026-02-11

* Refine CI workflow to prevent duplicate builds, add concurrency control, and harden Dockerfile defaults for reliable GHCR publishing.


## [1.0.0] - 2026-02-11

* 🥳 Official Release

