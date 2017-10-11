#FROM python:3
FROM debian:stretch

#MAINTAINER Edward Yang <ed.yang.123456@gmail.com>

# nginx
RUN apt-get -y update && apt-get -y install \
  nginx \
  nginx-extras \
  ca-certificates \
  supervisor

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log


# python3
RUN apt-get install python3 python3-dev python3-pip -y
RUN pip3 install flask

# uwsgi (don't use pip3 install uwsgi)
RUN apt-get install uwsgi uwsgi-plugin-python3 -y
#RUN pip3 install uwsgi

# By default, allow unlimited file sizes, modify it to limit the file sizes
# To have a maximum of 1 MB (Nginx's default) change the line to:
# ENV NGINX_MAX_UPLOAD 1m
ENV NGINX_MAX_UPLOAD 0

# Which uWSGI .ini file should be used, to make it customizable
# Use environment variable to pass config to uWSGI (provided by uWSGI)
ENV UWSGI_INI /app/uwsgi.ini

# URL under which static (not modified by Python) files will be requested
# They will be served by Nginx directly, without being handled by uWSGI
ENV STATIC_URL /static
# Absolute path in where the static files wil be
ENV STATIC_PATH /app/static

# If STATIC_INDEX is 1, serve / with /static/index.html directly (or the static URL configured)
# ENV STATIC_INDEX 1
ENV STATIC_INDEX 0

# update conf.d
COPY ./nginx/conf.d/* /etc/nginx/conf.d/

# update main nginx.conf
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

# uwsgi
RUN mkdir -p /etc/uwsgi
COPY ./uwsgi/uwsgi.ini /etc/uwsgi/uwsgi.ini

# supervisor
COPY ./supervisor/supervisord.conf /etc/supervisor/conf.d/

# Copy the entrypoint that will generate Nginx additional configs
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

# Add demo app
RUN groupadd nginx
RUN useradd -m -g nginx nginx

COPY ./app /app
WORKDIR /app

RUN chown -R nginx:nginx /app

EXPOSE 80

CMD ["/usr/bin/supervisord"]

