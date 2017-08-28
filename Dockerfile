# Pull base image.
FROM java:8u111-jre-alpine

# Install Ubooquity
RUN \
  apk --no-cache add \
     unzip \
     wget && \
  mkdir -p \
     /config \
     /media \
     /ubooquity 

# Define working directory.
WORKDIR /ubooquity

# Expose Ubooquity ports
EXPOSE 2202 2502

# Declare volumes
VOLUME \
  /config \
  /media

ADD first_run.sh /first_run.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh

CMD ["/run.sh"]

# Maintainer
LABEL maintainer="zer <zerpex@gmail.com>"
