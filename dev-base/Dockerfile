FROM dhi.io/debian-base:trixie

ENV DEVCONTAINER=true
ENV DEBIAN_FRONTEND=noninteractive

# Update package list and install packages
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        bat \
        curl \
        dnsutils \
        fzf \
        gh \
        git \
        gnupg2 \
        htop \
        iproute2 \
        jq \
        less \
        man-db \
        nano \
        procps \
        ripgrep \
        tree \
        unzip \
        wget \
        zstd \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Set the locale
ENV LANG=C.UTF-8
ENV LC_ALL=$LANG

# Truecolor terminal support
ENV TERM=xterm-256color
ENV COLORTERM=truecolor

# Non-root user setup
ENV USER=dev
ARG UID=1000
ARG GID=1000

# Note: There is no useradd in the Docker hardened Debian base image
RUN echo "$USER:x:$UID:$GID::/home/$USER:/bin/bash" >> /etc/passwd && \
    echo "$USER:x:$GID:" >> /etc/group && \
    mkdir -p /home/${USER} && \
    chown -R $UID:$GID /home/${USER}

# Default to the non-root user
USER $USER
WORKDIR /home/$USER

# Run the subsequent RUN commands in a login shell
SHELL ["/bin/bash", "-l", "-c"]

# Home directory setup
COPY --chown=$UID:$GID --chmod=755 home/ /home/$USER/

# Workspace setup
ARG WORKSPACE=/home/$USER/workspace
RUN mkdir -p $WORKSPACE

# Install fnm (Fast Node Manager)
RUN curl -fsSL https://fnm.vercel.app/install | bash

# Install Node.js LTS
RUN fnm install --lts

# Set npm global packages directory to workspace
ENV NPM_CONFIG_PREFIX=$WORKSPACE/.npm-global
