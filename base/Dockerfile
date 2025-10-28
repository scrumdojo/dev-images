FROM debian:trixie

ENV USER=dev

ENV DEBIAN_FRONTEND=noninteractive

# Update package list and install packages
RUN apt-get update \
 && apt-get install -y \
        curl \
        git \
        gh \
        nano \
        openssh-server \
        sudo \
        unzip \
        locales \
        wget \
        zstd \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Generate SSH host keys
RUN ssh-keygen -A

# Install MS Edit
ARG MSEDIT_INSTALL=/root/msedit_install.sh
COPY --chmod=755 sh/msedit_install.sh $MSEDIT_INSTALL
RUN $MSEDIT_INSTALL

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

# Install oh-my-posh
ARG OMP_INSTALL=/home/$USER/oh_my_posh_install.sh
COPY --chown=$USER:$USER --chmod=755 sh/oh_my_posh_install.sh $OMP_INSTALL
RUN $OMP_INSTALL && \
    rm $OMP_INSTALL

# Download oh-my-posh theme
ARG OMP_THEME=/home/$USER/.oh-my-posh/oh_my_posh_theme.sh
COPY --chown=$USER:$USER --chmod=755 sh/oh_my_posh_theme.sh $OMP_THEME
RUN $OMP_THEME

# Install AI CLI tools script
COPY --chown=$USER:$USER --chmod=755 sh/ai_cli_install.sh /home/$USER/ai_cli_install.sh

# Create SSH key for remote git host
COPY --chown=$USER:$USER --chmod=755 sh/create_ssh_key.sh /home/$USER/create_ssh_key.sh

# Entry point script
COPY --chown=$USER:$USER --chmod=755 sh/entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]
