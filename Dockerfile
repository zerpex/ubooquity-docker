# Pull base image.
FROM openjdk:8-jre-alpine

# Define variables
ENV \
  APP_VERSION=2.1.2 \
  UID=1042 \
  GID=1042 \
  USER=ubooquity \
  GROUP=ubooquity

# Create a non-root user ubooquity & Install Ubooquity
RUN \
  addgroup -g ${GID} ${GROUP} && \
  adduser -D -u ${UID} -G ${GROUP} ${USER} && \
  apk --no-cache add \
     unzip \
     curl \
     wget && \
  mkdir -p \
     /config \
     /media \
     /ubooquity && \
  wget http://vaemendis.net/ubooquity/downloads/Ubooquity-${APP_VERSION}.zip -O /tmp/${APP_VERSION}.zip && \
  unzip /tmp/${APP_VERSION}.zip -d /ubooquity && \
  chown -R ${UID}:${GID} \
     /config \
     /media \
     /ubooquity && \
  rm /tmp/${APP_VERSION}.zip

# Define working directory.
WORKDIR /ubooquity

# Expose Ubooquity ports
EXPOSE 2202 2502

# Declare volumes
VOLUME \
  /config \
  /media

# Test if service is ok
HEALTHCHECK \
  --interval=30s \
  --timeout=3s \
  --retries=3 \
  --start-period=1m \
  CMD curl -f http://127.0.0.1:2202/ || exit 1

# Change user to ubooquity
USER ${USER}

# Define default command
ENTRYPOINT ["java", "-Duser.home=$HOME", "-Dfile.encoding=UTF-8", "-jar", "-Xmx1024m", "/ubooquity/Ubooquity.jar", "-workdir", "/config", "-headless", "-libraryport", "2202", "-adminport", "2502", "-remoteadmin"]

# Maintainer
LABEL maintainer="zer <zerpex@gmail.com>"