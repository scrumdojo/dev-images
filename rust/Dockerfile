FROM ghcr.io/scrumdojo/dev-node:v2

# Install basic native build tools and dependencies
USER root

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        build-essential \
        pkg-config \
        libssl-dev \
        ca-certificates \
        cmake \
 && update-ca-certificates \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install Rust
USER dev

RUN curl -sSf https://sh.rustup.rs | sh -s -- -y

RUN rustup component add rustfmt clippy
