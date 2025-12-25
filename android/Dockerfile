FROM ghcr.io/scrumdojo/dev-node:v2

USER root

# Install Java JDK 21 LTS
RUN apt-get update \
 && apt-get install -y openjdk-21-jdk-headless openssh-server \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install Gradle
ARG GRADLE_VERSION=9.2.1

RUN cd /opt \
 && wget -q https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip \
 && unzip -q gradle-$GRADLE_VERSION-bin.zip \
 && rm gradle-$GRADLE_VERSION-bin.zip \
 && ln -s /opt/gradle-$GRADLE_VERSION/bin/gradle /usr/local/bin/gradle


ENV ANDROID_HOME=/opt/android-sdk

# Download and install Android Command Line Tools
ARG CMDLINE_VERSION=11076708
ARG CMDLINE_TOOLS_URL=https://dl.google.com/android/repository/commandlinetools-linux-${CMDLINE_VERSION}_latest.zip

RUN cd /tmp \
 && wget -q $CMDLINE_TOOLS_URL -O cmdline-tools.zip \
 && unzip -q cmdline-tools.zip \
 && rm cmdline-tools.zip \
 && mkdir -p $ANDROID_HOME/cmdline-tools \
 && mv cmdline-tools $ANDROID_HOME/cmdline-tools/latest \
 && chmod -R 755 $ANDROID_HOME \
 && chown -R $USER:$USER $ANDROID_HOME

# Switch to dev user for SDK setup
USER $USER
WORKDIR /home/$USER

# Create Android directory
RUN mkdir -p ~/.android \
 && touch ~/.android/repositories.cfg

# Accept all SDK licenses + Install platform-tools
ARG CMDLINE_TOOLS_BIN="$ANDROID_HOME/cmdline-tools/latest/bin"
RUN yes | "$CMDLINE_TOOLS_BIN/sdkmanager" --licenses
RUN "$CMDLINE_TOOLS_BIN/sdkmanager" --install "platform-tools"

# Add Android SDK to PATH in .bashrc
RUN echo "" >> ~/.bashrc \
 && echo "# Android SDK" >> ~/.bashrc \
 && echo "export ANDROID_HOME=$ANDROID_HOME" >> ~/.bashrc \
 && echo "export PATH=\$PATH:\$ANDROID_HOME/cmdline-tools/latest/bin:\$ANDROID_HOME/platform-tools" >> ~/.bashrc
