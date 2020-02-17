FROM ubuntu

LABEL maintainer "piotr@zawadzki.dev"

WORKDIR /

SHELL ["/bin/bash", "-c"]

RUN apt update && apt install -y openjdk-8-jdk git vim unzip libglu1 libpulse-dev libasound2 libc6  libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxi6  libxtst6 libnss3 wget

ARG GRADLE_VERSION=5.6.1
ARG ANDROID_API_LEVEL=29
ARG ANDROID_BUILD_TOOLS_LEVEL=29.0.3

RUN wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -P /tmp \
 && unzip -d /opt/gradle /tmp/gradle-${GRADLE_VERSION}-bin.zip \
 && mkdir /opt/gradlew \
 && /opt/gradle/gradle-${GRADLE_VERSION}/bin/gradle wrapper --gradle-version ${GRADLE_VERSION} --distribution-type all -p /opt/gradlew  \
 && /opt/gradle/gradle-${GRADLE_VERSION}/bin/gradle wrapper -p /opt/gradlew \
 && /opt/gradlew/gradlew --version

RUN wget 'https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip' -P /tmp \
 && unzip -d /opt/android /tmp/sdk-tools-linux-4333796.zip \
 && yes Y | /opt/android/tools/bin/sdkmanager --install "platform-tools" "system-images;android-${ANDROID_API_LEVEL};google_apis;x86" "platforms;android-${ANDROID_API_LEVEL}" "build-tools;${ANDROID_BUILD_TOOLS_LEVEL}" \
 && yes Y | /opt/android/tools/bin/sdkmanager --licenses

ENV GRADLE_HOME=/opt/gradle/gradle-$GRADLE_VERSION \
    ANDROID_HOME=/opt/android
ENV PATH "$PATH:$GRADLE_HOME/bin:/opt/gradlew:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"

ADD start.sh /
RUN chmod +x start.sh
