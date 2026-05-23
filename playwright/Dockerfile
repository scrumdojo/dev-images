FROM ghcr.io/scrumdojo/dev-node:v4.1

# Install Playwright browser dependencies
USER $USER
ARG PLAYWRIGHT_VERSION=1.60.0
RUN npx playwright@$PLAYWRIGHT_VERSION install-deps chromium firefox \
 && rm -rf ~/.npm/_npx/

# Clean up apt cache
USER root
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

USER $USER
