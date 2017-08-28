#!/bin/bash

if [ -f /.first_run ]; then
        exit 0
fi

FILE_ENCODING="${FILE_ENCODING:-UTF-8}"
LIBRARY_PORT="${LIBRARY_PORT:-2202}"
ADMIN_PORT="${ADMIN_PORT:-2502}"

# Define Ubooquity version
APP_VERSION="${UBOOQUITY_VERSION:-$(curl -s http://vaemendis.net/ubooquity/static2/download | grep Version | awk -F\& '{print $1}' | awk '{print $NF}')}"

wget http://vaemendis.net/ubooquity/downloads/Ubooquity-${APP_VERSION}.zip -O /tmp/${APP_VERSION}.zip && \
unzip /tmp/${APP_VERSION}.zip -d /ubooquity && \
rm /tmp/${APP_VERSION}.zip

java -Dfile.encoding=$FILE_ENCODING -jar -Xmx512m /ubooquity/Ubooquity.jar -workdir /config -headless -libraryport $LIBRARY_PORT -adminport $ADMIN_PORT -remoteadmin

touch /.first_run
