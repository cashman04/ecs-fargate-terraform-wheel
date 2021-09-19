FROM nginx

RUN apt-get update && \
    apt-get install -y git && \
    apt-get upgrade -y

ARG weatherapikey

COPY html /usr/share/nginx/html

RUN sed -i "s/weatherapikey/${weatherapikey}/g" /usr/share/nginx/html/index.html