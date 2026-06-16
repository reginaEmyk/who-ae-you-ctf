# ---------- Frontend build ----------
FROM node:22-alpine AS frontend

WORKDIR /frontend

COPY frontend/package*.json ./

RUN npm install

COPY frontend/ .

RUN npm run build


# ---------- Vulnerable machine ----------
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /opt/whoareyou

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    openssh-server \
    vsftpd \
    sqlite3 \
    sudo \
    curl \
    net-tools \
    procps && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/sshd

RUN python3 -m venv /opt/venv

COPY requirements.txt .

RUN /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install -r requirements.txt

COPY app ./app
COPY ftp ./ftp
COPY setup ./setup
COPY flags ./flags

COPY --from=frontend /frontend/dist ./app/static

COPY entrypoint.sh .

RUN chmod +x entrypoint.sh && \
    chmod +x setup/users.sh

RUN ./setup/users.sh

EXPOSE 21 22 8080

CMD ["./entrypoint.sh"]