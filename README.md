![Ubooquity Logo](http://i.imgur.com/InPPMtr.png)  
[![Docker Build Statu](https://img.shields.io/docker/build/zerpex/ubooquity-docker.svg)](https://hub.docker.com/r/zerpex/ubooquity-docker/) [![Docker Stars](https://img.shields.io/docker/stars/zerpex/ubooquity-docker.svg?label=docker%20%E2%98%85)](https://hub.docker.com/r/zerpex/ubooquity-docker/) [![Docker Pulls](https://img.shields.io/docker/pulls/zerpex/ubooquity-docker.svg)](https://hub.docker.com/r/zerpex/ubooquity-docker/) [![Docker Size](https://img.shields.io/github/repo-size/zerpex/ubooquity-docker/)](https://hub.docker.com/r/zerpex/ubooquity-docker/) [![Github Stars](https://img.shields.io/github/stars/zerpex/ubooquity-docker.svg?label=github%20%E2%98%85)](https://github.com/zerpex/ubooquity-docker/stargazers) [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/zerpex/ubooquity-docker/master/LICENSE)

# Introduction

@cromignon has made an image for us in his [own repository](https://github.com/cromigon/ubooquity-docker), but doesn't seems to maintain it anymore.  
This image is built to be as lighweight and simple as possible. It is based on alpine and java 8.

I exported Ubooquity's installation to the container's build level. This will increase time of the build, but permit the user to control it's Ubooquity's version.

## About Ubooquity

Home server for comics and ebooks

Ubooquity is a free, lightweight and easy-to-use home server for your comics and ebooks. Use it to access your files from anywhere, with a tablet, an e-reader, a phone or a computer.

Main features
* Simple graphical interface to configure your server in a few minutes
* Web administration page available if you prefer to do everything through your browser
* User management with secured access, to decide who can see what
* Online comic reader to read your comics without downloading huge files
* Compatible with Calibre metadata, for better ebooks collection management
* Can be installed on any OS supporting Java (Windows, Linux, Mac OS...) and on a wide range of hardware (desktop computer, server, NAS...)
* Supports many types of files, with a preference for epub, cbz, cbr and PDF files

Copy-pasted from the Ubooquity homepage.

# Getting started

## Docker Installation

Please see the [Docker installation documentation](https://docs.docker.com/installation/) for details.

## Prerequisite

Ensure that you have folders created for the ubooquity config on the host.
It's generally recommended to have some e-books or comics to mount in :)

## Docker

### Environnement variables (with their default values if not specified) :  
* UBOOQUITY_VERSION=  
Empty for latest version. If you don't want latest version, specify the version number with this variable. See [all available versions here](http://vaemendis.net/ubooquity/downloads/).  
* FILE_ENCODING=UTF-8  
Default file encoding set to UTF-8.  
* LIBRARY_PORT=2202  
Default port for accessing the library.  
* ADMIN_PORT=2502  
Default port for the admin interface.

### Start the container :
Run the following command line :

```
docker run --restart=always -d \
  -v /PATH/TO/UBOOQUITY/DATA:/config \
  -v /PATH/TO/COMICSANDBOOKS:/media \
  -p 2202:2202 \
  -p 2502:2502 \
  -e UBOOQUITY_VERSION= \
  -e FILE_ENCODING=UTF-8 \
  -e LIBRARY_PORT=2202 \
  -e ADMIN_PORT=2502 \
  -e TZ=Europe/Paris \
  zerpex/ubooquity-docker
  
```

## Docker-compose

Use the following docker-compose.yml and adapt it to your configuration :

```
version: '2'

services:
  ubooquity:
    restart: always
    image: zerpex/ubooquity-docker
    container_name: ubooquity
      - /PATH/TO/UBOOQUITY/CONFIG:/config
      - /PATH/TO/YOUR/COMICS:/media
      - /etc/localtime:/etc/localtime:ro
    environment:
      - UBOOQUITY_VERSION=
      - FILE_ENCODING=UTF-8
      - LIBRARY_PORT=2202
      - ADMIN_PORT=2502
      - TZ=Europe/Paris
    ports:
      - 2202:2202
      - 2502:2502

volumes:
  files:
    driver: local
```

docker-compose with Watchtower :

```
version: '2'

services:
   ubooquity:
    restart: always
    image: zerpex/ubooquity-docker
    container_name: ubooquity
    volumes:
      - ./files/conf:/config
      - /library:/media
      - /etc/localtime:/etc/localtime:ro
    environment:
      - UBOOQUITY_VERSION=
      - FILE_ENCODING=UTF-8
      - LIBRARY_PORT=2202
      - ADMIN_PORT=2502
      - TZ=Europe/Paris
    ports:
      - 2202:2202
      - 2502:2502

   watchtower:
    restart: always
    image: v2tec/watchtower
    container_name: watchtower
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /etc/localtime:/etc/localtime:ro
    environment:
      - TZ=Europe/Paris

volumes:
  files:
    driver: local
```

## Notes

Once the container is up:  
- go to http://{YOUR_IP_ADDRESS}:2502/admin and do your configuration according to the [ubooquity documentation](https://vaemendis.github.io/ubooquity-doc/).  
- Then, you can access Ubooquity through http://{YOUR_IP_ADDRESS}:2202
- In order to keep your containers up to date automatically, I recommand you to use [Watchtower](https://github.com/v2tec/watchtower) that will do the job for you :)

# License

Code released under the [MIT license](./LICENSE).
