FROM ghcr.io/scrumdojo/dev-playwright:v5

USER root

# Install Java JRE headless
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        default-jre-headless \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

USER $USER
