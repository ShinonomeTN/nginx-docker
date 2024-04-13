FROM debian:latest

LABEL maintainer="CattenLinger"

RUN apt update && apt install -y nginx-extras && rm -rf /etc/sites-* && apt clean

COPY nginx.conf /etc/nginx/nginx.conf

CMD nginx -g "daemon off;"
