FROM alpine:3.22

RUN apk add --no-cache \
    ca-certificates \
    curl \
    tar \
    vsftpd \
    shadow

RUN useradd -m supernova && \
    echo "supernova:sususu" | chpasswd && \
    useradd -m aespa && \
    echo "aespa:cooper" | chpasswd

RUN curl -L \
    https://github.com/filebrowser/filebrowser/releases/download/v2.63.0/linux-amd64-filebrowser.tar.gz \
    -o /tmp/fb.tar.gz && \
    tar -xzf /tmp/fb.tar.gz -C /usr/local/bin && \
    chmod +x /usr/local/bin/filebrowser && \
    rm -f /tmp/fb.tar.gz

RUN mkdir -p \
    /home/supernova/file-browser \
    /home/aespa/ftp

RUN chown -R supernova:supernova /home/supernova && \
    chown -R aespa:aespa /home/aespa

COPY file-browser/ /home/supernova/file-browser/
COPY entry.sh /entry.sh
COPY vsftpd.conf /etc/vsftpd/vsftpd.conf

RUN chmod +x /entry.sh

EXPOSE 80 21

CMD ["/entry.sh"]