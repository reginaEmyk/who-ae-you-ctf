FROM node:22-bullseye-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        vsftpd && \
    rm -rf /var/lib/apt/lists/*

# Caddy v2.11.4
RUN curl -L \
    https://github.com/caddyserver/caddy/releases/download/v2.11.4/caddy_2.11.4_linux_amd64.tar.gz \
    -o /tmp/caddy.tar.gz && \
    tar -xzf /tmp/caddy.tar.gz -C /usr/local/bin caddy && \
    chmod +x /usr/local/bin/caddy && \
    rm -f /tmp/caddy.tar.gz

# users
RUN useradd -m supernova && \
    useradd -m armageddon && \
    useradd -m aespa && \
    echo "aespa:cooper" | chpasswd

USER supernova
WORKDIR /home/supernova

ENV NPM_CONFIG_PREFIX=/home/supernova/.npm-global
ENV PATH=/home/supernova/.npm-global/bin:$PATH

RUN mkdir -p /home/supernova/.npm-global && \
    npm install -g n8n@1.121.0 && \
    npm cache clean --force

USER root

COPY ftp/ /home/aespa/ftp/

RUN chown -R aespa:aespa /home/aespa/ftp

WORKDIR /app
COPY app /app

COPY Caddyfile /etc/caddy/Caddyfile
COPY vsftpd.conf /etc/vsftpd.conf
COPY entry.sh /entry.sh

RUN chmod +x /entry.sh

EXPOSE 80
EXPOSE 21
EXPOSE 30000-30010
EXPOSE 1110
EXPOSE 5678

CMD ["/entry.sh"]