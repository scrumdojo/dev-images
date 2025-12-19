FROM dhi.io/debian-base:trixie

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
