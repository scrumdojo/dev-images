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
        gawk \
        gh \
        git \
        gnupg2 \
        htop \
        iproute2 \
        jq \
        less \
        lsd \
        man-db \
        nano \
        openssh-server \
        procps \
        ripgrep \
        stow \
        sudo \
        tmux \
        tree \
        unzip \
        wget \
        zsh \
        zstd \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && ldconfig

# Generate SSH host keys
RUN ssh-keygen -A

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
RUN echo "$USER:x:$UID:$GID::/home/$USER:/bin/zsh" >> /etc/passwd && \
    echo "$USER:x:$GID:" >> /etc/group && \
    mkdir -p /home/${USER} && \
    chown -R $UID:$GID /home/${USER}

# Add $USER to sudoers with no password for apt-get and ssh service management
RUN pam-auth-update --force \
 && echo "$USER ALL=(root) NOPASSWD: /usr/bin/apt-get, /usr/bin/sh -c apt-get*" > /etc/sudoers.d/$USER \
 && echo "$USER ALL=(root) NOPASSWD: /usr/sbin/service ssh*" >> /etc/sudoers.d/$USER \
 && chmod 0440 /etc/sudoers.d/$USER

# Default to the non-root user
USER $USER
WORKDIR /home/$USER

# Run the subsequent RUN commands in a login shell
SHELL ["/bin/zsh", "-l", "-c"]

# Home directory setup
COPY --chown=$UID:$GID home/ /home/$USER/
RUN mkdir -p ~/.local/bin

# Create ~/.ssh directory
RUN mkdir -p ~/.ssh \
 && chmod 700 ~/.ssh \
 && touch ~/.ssh/authorized_keys \
 && chmod 600 ~/.ssh/authorized_keys

# Workspace setup
ENV WORKSPACE=/home/$USER/workspace
RUN mkdir -p $WORKSPACE

# Install Oh My Posh
RUN curl -s https://ohmyposh.dev/install.sh | bash -s

# Install fnm (Fast Node Manager)
RUN curl -fsSL https://fnm.vercel.app/install | bash \
 && sed -i 's/fnm env/fnm env --use-on-cd/' ~/.zshrc

# Install Node.js LTS
RUN fnm install --lts

# Set npm global packages directory to workspace
ENV NPM_CONFIG_PREFIX=$WORKSPACE/.npm-global

# Install pnpm
RUN curl -fsSL https://get.pnpm.io/install.sh | bash

# Configure pnpm to use workspace directories
RUN pnpm config set store-dir $WORKSPACE/.pnpm-store \
 && pnpm config set global-dir $WORKSPACE/.pnpm-global \
 && pnpm config set global-bin-dir $WORKSPACE/.pnpm-global/bin

# Entrypoint script for optional service startup
ENTRYPOINT ["/home/dev/init/entrypoint.sh"]
CMD ["sleep", "infinity"]
