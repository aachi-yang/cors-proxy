# Docker Image for Nginx Proxy

Setup a pair of Nginx proxy/web server to handle CORS process.

This document is based on: [tiangolo/uwsgi-nginx-flask](https://hub.docker.com/r/tiangolo/uwsgi-nginx-flask/).

Also, refer to this one: [Nginx configuration for CORS-enabled HTTPS proxy with origin white-list defined by a simple regex](https://gist.github.com/pauloricardomg/7084524)

## Container

- debian:stretch
- Nginx
- Python3 (with python-extras)
- uWSGI
- app (Flask sample app)

## Files

```bash
.
├── Dockerfile
├── README.md
├── app
│   ├── main.py
│   ├── static
│   │   └── index.html
│   └── uwsgi.ini (application uwsgi ini file)
├── entrypoint.sh (will generate nginx.conf in conf.d)
├── nginx
│   ├── conf.d
│   │   └── proxy.conf (cors handling and to forward request to port 8080)
│   └── nginx.conf
├── supervisor
│   └── supervisord.conf (run both uwsgi and nginx)
├── update.sh (easy of update container files)
└── uwsgi
    └── uwsgi.ini (update to /etc/uwsgi in container)
```


## Build/Rebulld Docker Image

> docker build -t cors-proxy .

## Run and Test

In host command windows:

```bash
docker run -d --name cors-proxy cors-proxy
```

Browse link "localhost" or "localhost:8080", it will show:

> Docker Running ! Hello World from static HTML

Browse link "localhost/hello" or "localhost:8080/hello", it will show:
> Hello World from Flask

It can open another host comand windows and run the below command to check log:

```bash
docker logs -f cors
```

In addition, it can run the bash of container to do what you want, like install additional packages, etc.

```bash
docker exec -i -t cors-proxy /bin/bash
```

```bash
root@c19867aff7dc:/app# ls
__pycache__  main.py  static  uwsgi.ini
root@c19867aff7dc:/app#
```

# Reference

## Run Docker Image

```bash
docker run -d --name cors-proxy cors-proxy

or 
# redirect aceess from localhost:8080 to container:80
docker run -d --name cors-proxy -p 8080:80 cors-proxy

```

## Start/Restart/Stop Container

```bash
docker start cors
docker restart cors
docker stop cors
```

## Debug Program Running in Container 

### Run bash inside container

```bash
# exec bash in container
sudo docker exec -i -t cors-proxy /bin/bash

```
### Display logs

```bash
# show Nginx logs
docker logs -f cors
```

### copy file from container to host

```bash
# docker cp <containerId>:/file/path/within/container /host/path/target
docker cp nginxpx:/etc/nginx/nginx.conf .
```
### Remove Container

```bash
docker rm -f cors

# remove all containers
docker rm -f $(docker ps -aq)  
```

### Remove images
```bash
docker rmi 
```


