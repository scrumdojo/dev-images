FROM ghcr.io/scrumdojo/dev-node:v3

# Install Playwright browser dependencies
USER $USER
RUN npx playwright install-deps \
 && rm -rf ~/.npm/_npx/

# Clean up apt cache
USER root
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

USER $USER
