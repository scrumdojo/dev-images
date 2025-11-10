FROM debian:trixie

ENV USER=dev

ENV DEBIAN_FRONTEND=noninteractive

# Update package list and install packages
RUN apt-get update \
 && apt-get install -y \
        curl \
        git \
        gh \
        jq \
        nano \
        openssh-server \
        ripgrep \
        sudo \
        tree \
        unzip \
        locales \
        wget \
        zstd \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Generate SSH host keys
RUN ssh-keygen -A

# Set the locale
RUN sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen \
 && locale-gen en_US.UTF-8 \
 && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Create user with home dir and bash shell
RUN useradd --uid 1000 -U -m -s /bin/bash $USER

# Add the user to sudoers for passwordless sudo
RUN echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Default to the non-root user
USER $USER
WORKDIR /home/$USER
SHELL ["/bin/bash", "-l", "-c"]

# Create .ssh directory
RUN mkdir -p ~/.ssh \
 && chmod 700 ~/.ssh \
 && touch ~/.ssh/authorized_keys

# Install Volta and Node.js + pnpm
RUN curl https://get.volta.sh | bash && rm -rf /tmp/*

ENV VOLTA_FEATURE_PNPM=1

RUN volta install node \
 && volta install npm \
 && volta install pnpm

# Workspace setup
ENV WORKSPACE=/home/$USER/workspace
RUN mkdir -p $WORKSPACE \
 && pnpm config set store-dir $WORKSPACE/.pnpm-store

# Copy initialization scripts
COPY --chown=$USER:$USER --chmod=755 sh/init/ /home/$USER/init/

# Copy Claude Code statusline settings
COPY --chown=$USER:$USER --chmod=755 sh/.claude/ /home/$USER/.claude/

# Install oh-my-posh
RUN /home/$USER/init/install-oh-my-posh.sh
RUN /home/$USER/init/install-oh-my-posh-theme.sh

# Install MS Edit
RUN sudo /home/$USER/init/install-msedit.sh

# Entry point script
COPY --chown=$USER:$USER --chmod=755 sh/entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]
