FROM debian:stable-slim

LABEL maintainer="CattenLinger"

RUN set -x \
# Create nginx user
    && groupadd --system --gid 101 nginx \
    && useradd --system --gid nginx --no-create-home --home /nonexistent --comment "nginx user" --shell /bin/false --uid 101 nginx \
# Install the full-featured nginx, and a curl for test purpose.
    && apt update \
    && apt install -y nginx-extras curl --no-install-recommends \
    && apt clean \
# Make the default log output to stdout and stderr
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log 

# Entrypoint

COPY entrypoint/docker-entrypoint.sh /
COPY entrypoint/10-listen-on-ipv6-by-default.sh /docker-entrypoint.d/
COPY entrypoint/15-local-resolvers.envsh /docker-entrypoint.d/
COPY entrypoint/20-envsubst-on-templates.sh /docker-entrypoint.d/
COPY entrypoint/30-tune-worker-processes.sh /docker-entrypoint.d/
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]
