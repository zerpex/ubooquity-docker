#!/bin/bash
if [ ! -f /.first_run ]; then
        /first_run.sh
fi

FILE_ENCODING="${FILE_ENCODING:-UTF-8}"
LIBRARY_PORT="${LIBRARY_PORT:-2202}"
ADMIN_PORT="${ADMIN_PORT:-2502}"

java -Dfile.encoding=$FILE_ENCODING -jar -Xmx512m /ubooquity/Ubooquity.jar -workdir /config -headless -libraryport $LIBRARY_PORT -adminport $ADMIN_PORT -remoteadmin
