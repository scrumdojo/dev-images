# Development Containers

Simple dev containers. Can be used in `devcontainer.json` and run e.g. locally or in GitHub Codespaces.

## Base Container with Node.js

Base development environment with [Node.js](https://nodejs.org) LTS to run all common AI Coding Agent CLIs.

Available at: `ghcr.io/scrumdojo/dev-node:v1`

- Based on [Docker Hardened](https://www.docker.com/products/hardened-images/) Debian Base
    [`dhi.io/debian-base:trixie`](https://hub.docker.com/hardened-images/catalog/dhi/debian-base)
- User `dev:dev` (`1000:1000`)
- `git` and GitHub CLI (`gh`)
- [Node.js](https://nodejs.org) managed by [fnm](https://github.com/Schniz/fnm), and [pnpm](https://pnpm.io)
- [oh-my-posh](https://ohmyposh.dev) with custom Nebula Surge theme

Install common AI Coding Agent CLIs in: `/home/dev/init/`

## Rust Development

Available at: `ghcr.io/scrumdojo/dev-rust:v1`

- Based on `ghcr.io/scrumdojo/dev-node:v1`
- [Rust](https://rust-lang.org/) development stack
