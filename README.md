# Development Containers

Simple dev containers. Can be used in `devcontainer.json` and run e.g. locally or in GitHub Codespaces.

## Base Container with Node.js

Base development environment with [Node.js](https://nodejs.org) LTS to run all common AI Coding Agent CLIs.

Available at: `ghcr.io/scrumdojo/dev-node:v2`

- Based on [Docker Hardened](https://www.docker.com/products/hardened-images/) Debian Base
    [`dhi.io/debian-base:trixie`](https://hub.docker.com/hardened-images/catalog/dhi/debian-base)
- User `dev:dev` (`1000:1000`)
- `git` and GitHub CLI (`gh`) with `sudo` limited to `apt-get`
- [Node.js](https://nodejs.org) managed by [fnm](https://github.com/Schniz/fnm), and [pnpm](https://pnpm.io)
- [oh-my-posh](https://ohmyposh.dev) with custom Nebula Surge theme

Install common AI Coding Agent CLIs in: `/home/dev/init/`

## Node.js with Playwright dependencies

Development container with pre-installed [Playwright](https://playwright.dev/) browser system dependencies
Playwright itself, not any browser, are *not* pre-installed, as their versions are project specific,
and need to be installed inside the container for each respective project.

Available at: `ghcr.io/scrumdojo/dev-playwright:v2`

- Based on `ghcr.io/scrumdojo/dev-node:v2`
- Playwight [browser system dependencies](https://playwright.dev/docs/browsers#install-system-dependencies)

## Firebase Emulator ready

Development container with headless JRE to run [Firebase Emulators](https://firebase.google.com/docs/emulator-suite).
Firebase CLI itself (which contain the emulators) is not pre-installed, as it is updated frequently.

Available at: `ghcr.io/scrumdojo/dev-firebase:v2`

- Based on `ghcr.io/scrumdojo/dev-playwright:v2`
- Headless Java JRE to run the Firebase Emulators

### Firebase CLI
Install [Firebase CLI](https://firebase.google.com/docs/cli/): `pnpm install -g firebase-tools`

Login to Firebase from within the container: `firebase login --no-localhost`

## Rust Development

Available at: `ghcr.io/scrumdojo/dev-rust:v2`

- Based on `ghcr.io/scrumdojo/dev-node:v2`
- [Rust](https://rust-lang.org/) development stack

## How to use
Example compose file to create a dev container locally:

```yaml
services:
    dev-container:
        # one of the above images
        image: ghcr.io/scrumdojo/dev-node:v2
        container_name: dev-container
        # hostname is displayed in Oh My Posh powerline
        hostname: dev-container
        environment:
            - TZ=
            - GIT_USER_NAME=
            - GIT_USER_EMAIL=
            - GITHUB_TOKEN=
        command: sleep infinity
        volumes:
            - workspace:/home/dev/workspace

volumes:
    # workspace for your repos and worktrees
    # npm and pnpm global packages, and pnpm store are in the workspace, too
    workspace:
```

Inside the container, run `~/init/git.sh` to initialize `~/.gitconfig` with your user name and email,
and login to GitHub using `gh` and provided `GITHUB_TOKEN`.
