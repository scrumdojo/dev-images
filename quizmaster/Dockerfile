FROM ghcr.io/scrumdojo/dev-playwright:v4

USER root

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        ca-certificates \
        ca-certificates-java \
        openjdk-21-jdk-headless \
 && rm -f /etc/ssl/certs/java/cacerts \
 && update-ca-certificates -f \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

USER $USER
