# Changelog

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

