FROM alpine:3.22

RUN apk add --no-cache \
    ca-certificates \
    curl \
    tar \
    vsftpd \
    shadow

#
# USERS (RESTORED EXACTLY AS YOU NEED)
#
RUN useradd -m supernova && \
    echo "supernova:sususu" | chpasswd && \
    useradd -m aespa && \
    echo "aespa:cooper" | chpasswd
    

# TODO CHANGE TO SUPERNOVA USER , KEEP ALL WEB STUFF IN SUPERNOVA AND OUT OF ROOT

#
# FILEBROWSER (only for supernova web layer)
#
RUN curl -L \
    https://github.com/filebrowser/filebrowser/releases/download/v2.63.0/linux-amd64-filebrowser.tar.gz \
    -o /tmp/fb.tar.gz && \
    tar -xzf /tmp/fb.tar.gz -C /usr/local/bin && \
    chmod +x /usr/local/bin/filebrowser && \
    rm -f /tmp/fb.tar.gz

RUN mkdir -p /srv/files

COPY app/ /srv/files/
COPY entry.sh /entry.sh
COPY vsftpd.conf /etc/vsftpd/vsftpd.conf

RUN chmod +x /entry.sh

EXPOSE 80 21

CMD ["/entry.sh"]