# Development Containers

Simple dev containers. Can be used in `devcontainer.json` and run e.g. locally or in GitHub Codespaces.

## Dev images overview

| Image          | Based on                      | Note |
|----------------|-------------------------------|------|
| dev-node       | dhi.io/debian-base:trixie-dev | Base dev tools, Node.js LTS + pnpm |
| dev-playwright | dev-node                      | Playwright browser dependencies preinstalled |
| dev-firebase   | dev-playwright                | JRE to run Firebase Emulators |
| dev-quizmaster | dev-playwright                | OpenJDK to develop [scrumdojo/quizmaster](https://github.com/scrumdojo/quizmaster) |
| dev-rust       | dev-node                      | Run development stack |

## Security design principles

These images aim to reduce common supply-chain and credential risks in day-to-day development, while staying practical for local use.

- Based on [Docker Hardened](https://www.docker.com/products/hardened-images/) Debian Base
    [`dhi.io/debian-base:trixie-dev`](https://hub.docker.com/hardened-images/catalog/dhi/debian-base)
- Non-root `dev:dev` (`1001:1001`) user by default
- `sudo` restricted to `apt-get` and `service ssh` management
- Disabled `npm` lifecycle scripts by default (`ignore-scripts=true`)
- Use [fine-grained](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#fine-grained-personal-access-tokens) `GITHUB_TOKEN` to access only project repository

This is not a complete security boundary. Treat these images as a safer default, then add project-specific controls as needed.

## Base Container with Node.js

Base development environment with [Node.js](https://nodejs.org) LTS to run all common AI Coding Agent CLIs.

Available at: `ghcr.io/scrumdojo/dev-node:v4`

- Based on [Docker Hardened](https://www.docker.com/products/hardened-images/) Debian Base
    [`dhi.io/debian-base:trixie-dev`](https://hub.docker.com/hardened-images/catalog/dhi/debian-base)
- OpenSSH server (off by default)
- `git` and GitHub CLI (`gh`)
- `zsh` with common plugins, `tmux`, `fzf`, `ripgrep`, `fd` and other modern CLI tools
- [Node.js](https://nodejs.org) managed by [fnm](https://github.com/Schniz/fnm), and [pnpm](https://pnpm.io)
- [oh-my-posh](https://ohmyposh.dev)

Install common AI Coding Agent CLIs in: `/home/dev/init/`

## Node.js with Playwright dependencies

Development container with pre-installed [Playwright](https://playwright.dev/) browser system dependencies
Playwright itself, not any browser, are *not* pre-installed, as their versions are project specific,
and need to be installed inside the container for each respective project.

Available at: `ghcr.io/scrumdojo/dev-playwright:v4`

- Based on `ghcr.io/scrumdojo/dev-node:v4`
- Playwight [browser system dependencies](https://playwright.dev/docs/browsers#install-system-dependencies)

## Firebase Emulator ready

Development container with headless JRE to run [Firebase Emulators](https://firebase.google.com/docs/emulator-suite).
Firebase CLI itself (which contain the emulators) is not pre-installed, as it is updated frequently.

Available at: `ghcr.io/scrumdojo/dev-firebase:v4`

- Based on `ghcr.io/scrumdojo/dev-playwright:v4`
- Headless Java JRE to run the Firebase Emulators

### Firebase CLI
Install [Firebase CLI](https://firebase.google.com/docs/cli/): `pnpm install -g firebase-tools`

Login to Firebase from within the container: `firebase login --no-localhost`

## Rust Development

Available at: `ghcr.io/scrumdojo/dev-rust:v4`

- Based on `ghcr.io/scrumdojo/dev-node:v4`
- [Rust](https://rust-lang.org/) development stack

## How to use
Example compose file to create a dev container locally:

```yaml
services:
    dev-container:
        # one of the above images
        image: ghcr.io/scrumdojo/dev-node:v4
        container_name: dev-container
        hostname: dev-container
        environment:
            - TZ=
            - GIT_USER_NAME=
            - GIT_USER_EMAIL=
            - GITHUB_TOKEN=
            - SSH_START=
            - SSH_PUBKEY=
        volumes:
            - devhome:/home/dev

volumes:
    devhome:
```

Inside the container, run `~/init/git.sh` to initialize `~/.gitconfig` with your user name and email,
and login to GitHub using `gh` and provided `GITHUB_TOKEN`.

### SSH Access
For `sshd` to autostart, pass `SSH_START=true` to the container.

You can pass your public SSH key via `SSH_PUBKEY`, which gets added to `~/.ssh/authorized_keys`.
