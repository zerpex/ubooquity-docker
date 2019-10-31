![Ubooquity Logo](http://i.imgur.com/InPPMtr.png)  
[![Docker Build Statu](https://img.shields.io/docker/build/zerpex/ubooquity-docker.svg)](https://hub.docker.com/r/zerpex/ubooquity-docker/) [![Docker Stars](https://img.shields.io/docker/stars/zerpex/ubooquity-docker.svg?label=docker%20%E2%98%85)](https://hub.docker.com/r/zerpex/ubooquity-docker/) [![Docker Pulls](https://img.shields.io/docker/pulls/zerpex/ubooquity-docker.svg)](https://hub.docker.com/r/zerpex/ubooquity-docker/) [![Github Stars](https://img.shields.io/github/stars/zerpex/ubooquity-docker.svg?label=github%20%E2%98%85)](https://github.com/zerpex/ubooquity-docker/stargazers) [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/zerpex/ubooquity-docker/master/LICENSE)

# Introduction

@cromignon has made an image for us in his [own repository](https://github.com/cromigon/ubooquity-docker), but doesn't seems to maintain it anymore.  
This image is built to be as lighweight and simple as possible. It is based on alpine and openjdk 8.  

- **Ubooquity version** : 2.1.2

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

### Manage configuration directory :  
In the following exemples, replace the volumes:
 - /PATH/TO/UBOOQUITY/CONFIG by the location where ubooquity's config files will be stored.
 - /PATH/TO/COMICSANDBOOKS by the location where your comics are stored.

/!\ IMPORTANT: As this image execute ubooquity as a non-root user, the following steps have to be done prior to start the container:
 - `mkdir /PATH/TO/UBOOQUITY/CONFIG`
 - `chown -R 1042:1042 /PATH/TO/UBOOQUITY/CONFIG`


### Start the container :
Run the following command line :

```
docker run --restart=always -d \
  -v /PATH/TO/UBOOQUITY/CONFIG:/config \
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
    volumes:
      - /PATH/TO/UBOOQUITY/CONFIG:/config
      - /PATH/TO/YOUR/COMICS:/media
      - /etc/localtime:/etc/localtime:ro
    environment:
      - TZ=Europe/Paris
    ports:
      - 2202:2202
      - 2502:2502
```

docker-compose with Watchtower :

```
version: '2.4'

services:
   ubooquity:
    restart: always
    image: zerpex/ubooquity-docker
    container_name: ubooquity
    volumes:
      - /PATH/TO/UBOOQUITY/CONFIG:/config
      - /PATH/TO/YOUR/COMICS:/media
      - /etc/localtime:/etc/localtime:ro
    environment:
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
```

## Notes

Once the container is up:  
- go to http://{YOUR_IP_ADDRESS}:2502/admin and do your configuration according to the [ubooquity documentation](https://vaemendis.github.io/ubooquity-doc/).  
- Then, you can access Ubooquity through http://{YOUR_IP_ADDRESS}:2202
- In order to keep your containers up to date automatically, I recommand you to use [Watchtower](https://github.com/v2tec/watchtower) that will do the job for you :)

# License

Code released under the [MIT license](./LICENSE).
