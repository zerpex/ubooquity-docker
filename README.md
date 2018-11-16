![Ubooquity Logo](http://i.imgur.com/InPPMtr.png)  
[![Docker Build Statu](https://img.shields.io/docker/build/zerpex/ubooquity-docker.svg)](https://hub.docker.com/r/zerpex/ubooquity-docker/) [![Docker Stars](https://img.shields.io/docker/stars/zerpex/ubooquity-docker.svg?label=docker%20%E2%98%85)](https://hub.docker.com/r/zerpex/ubooquity-docker/) [![Docker Pulls](https://img.shields.io/docker/pulls/zerpex/ubooquity-docker.svg)](https://hub.docker.com/r/zerpex/ubooquity-docker/) [![Docker Size](https://img.shields.io/imagelayers/image-size/zerpex/ubooquity-docker/latest.svg)](https://hub.docker.com/r/zerpex/ubooquity-docker/) [![Docker Layers](https://img.shields.io/imagelayers/layers/zerpex/ubooquity-docker/latest.svg)](https://hub.docker.com/r/zerpex/ubooquity-docker/) [![Github Stars](https://img.shields.io/github/stars/zerpex/ubooquity-docker.svg?label=github%20%E2%98%85)](https://github.com/zerpex/ubooquity-docker/stargazers) [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/zerpex/ubooquity-docker/master/LICENSE)

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

Run the following command line :

```
docker run --restart=always -d \
  -v /PATH/TO/UBOOQUITY/DATA:/config \
  -v /PATH/TO/COMICSANDBOOKS:/media \
  -p 2202:2202 \
  -p 2502:2502 \
  zerpex/ubooquity-docker
  
```

## Docker-compose

### Simple compose:

Use the following docker-compose.yml and adapt it to your configuration :

```
version: '2.4'

services:
  ubooquity:
    restart: always
    image: zerpex/ubooquity-docker
    container_name: ubooquity
      - /PATH/TO/UBOOQUITY/CONFIG:/config
      - /PATH/TO/YOUR/COMICS:/media
      - /etc/localtime:/etc/localtime:ro
    ports:
      - 2202:2202
      - 2502:2502
```

### Full compose with reverse proxy:

First, create a .env file with the following content and set the variables according to your needs:  

```
# Mail address used by let's encrypt:
LE_MAIL=you@mail.tld

# Path where you store appplication files:
PATH_APP=/opt

# Path of your media files:
PATH_MEDIA=/data/library

# Ubooquity urls:
UBOOQUITY_URL=ubooquity.domain.tld
UBOOQUITY_ADMIN_URL=ubooquityadmin.domain.tld

# Name docker's proxy network:
PROXY=traefik

```

Second, create a docker-compose.yml file with the following content:  

```
version: '2.4'

services:
#################
# Reverse Proxy #
#################
  traefik:
    restart: unless-stopped
    image: traefik:alpine
    container_name: proxy_traefik
    hostname: traefik
    command: 
      --defaultEntryPoints='http,https'
      --web
      --web.address=:8080
      --entryPoints='Name:http Address::80  Redirect.EntryPoint:https' 
      --entryPoints='Name:https Address::443 TLS' 
      --acme
      --acme.email=${LE_MAIL}
      --acme.storage=/certs/acme.json 
      --acme.entryPoint=https 
      --acme.ondemand=false
      --acme.onhostrule=true
      --acme.httpChallenge.entryPoint=http
      --docker
      --docker.domain=traefik
      --docker.watch
      --docker.exposedbydefault=false
    ports:
      - "80:80"
      - "443:443"
#      - "8080:8080" # Statut page
    volumes:
      - ${PATH_APP}/letsencrypt/certs:/certs:rw
      - /etc/localtime:/etc/localtime:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro  
    networks:
      - proxy

#############
# Ubooquity #
#############
  ubooquity:
    restart: always
    image: zerpex/ubooquity-docker
    container_name: stream-book_Ubooquity
    hostname: library
    labels:
      - traefik.enable=true
      - traefik.app.frontend.rule=Host:${UBOOQUITY_URL}
      - traefik.app.port=2202
      - traefik.admin.frontend.rule=Host:${UBOOQUITY_ADMIN_URL}
      - traefik.admin.port=2502
      - traefik.docker.network=${PROXY}
    volumes:
      - ${PATH_APP}/ubooquity/conf:/config:rw
      - ${PATH_MEDIA}/comics:/media:rw
      - /etc/localtime:/etc/localtime:ro
    networks:
      - proxy

networks:
  proxy:
    external:
      name: ${PROXY}
```

Third, execute the following command:  
`docker-compose up -d `  

## Notes

Once the container is up:  
- go to http://{YOUR_IP_ADDRESS}:2502/admin and do your configuration according to the [ubooquity documentation](https://vaemendis.github.io/ubooquity-doc/).  
- Then, you can access Ubooquity through http://{YOUR_IP_ADDRESS}:2202
- In order to keep your containers up to date automatically, I recommand you to use [Watchtower](https://github.com/v2tec/watchtower) that will do the job for you :)

# License

Code released under the [MIT license](./LICENSE).
