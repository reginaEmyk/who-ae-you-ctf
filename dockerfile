FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /etc/dpkg/dpkg.cfg.d && \
    printf '%s\n' \
        'path-exclude=/usr/share/doc/*' \
        'path-exclude=/usr/share/man/*' \
        'path-exclude=/usr/share/info/*' \
        'path-exclude=/usr/share/locale/*' \
    > /etc/dpkg/dpkg.cfg.d/docker-slim 

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    cron \
    ca-certificates \
    curl \
    tar \
    vsftpd \
    binutils \
    sudo \
    git \
    apache2 \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Remove the default "ubuntu" user (if it exists) and create the only root user: armageddon
RUN if id ubuntu >/dev/null 2>&1; then userdel -r ubuntu; fi && \
    useradd -ou 0 -g 0 -m -d /armageddon -s /bin/bash armageddon && \
    echo "armageddon:l'essence_is_killing_everyone_and_their_copies" | chpasswd && \
    echo "root:l'essence_is_killing_everyone_and_their_copies" | chpasswd

# Create CTF users
RUN useradd -m supernova && \
    echo "supernova:sususu_mixed_the_aes_and_the_aespa" | chpasswd && \
    useradd -m -d /home/aespaFiles -s /bin/bash aespaFiles && \
    echo "aespaFiles:cooper" | chpasswd && \
    useradd -m welcomeToMyWorld && \
    echo "welcomeToMyWorld:and_thank_you_naevis_we_love_you_WTMW" | chpasswd

# Sudo rules: NOPASSWD for cat inside home, password required for outside
RUN echo 'supernova ALL=(root) NOPASSWD: /bin/cat /home/supernova/*' > /etc/sudoers.d/supernova && \
    echo 'supernova ALL=(root) PASSWD: /bin/cat /etc/*, /bin/cat /var/log/*, /bin/cat /tmp/*, /bin/cat /usr/bin/*' >> /etc/sudoers.d/supernova


COPY armageddon/ /armageddon/
COPY supernova/ /home/supernova/
COPY ftp/ /home/aespaFiles/

RUN chown -R armageddon:root /armageddon && \
    chown -R supernova:supernova /home/supernova && \
    chown -R aespaFiles:aespaFiles /home/aespaFiles

# Create directories and set ownership
RUN mkdir -p \
    /home/supernova/file-browser \
    /home/aespaFiles \
    /armageddon && \
    chown -R supernova:supernova /home/supernova && \
    chown armageddon:root /armageddon

# Cool effect (singularity command)
COPY wda4.sh /usr/bin/singularity
RUN chmod 755 /usr/bin/singularity

# Bash prompt: singularity runs randomly before each prompt
RUN cat <<'EOF' >> /etc/bash.bashrc
# --- SIMULATION GLITCH ---
export PROMPT_COMMAND='if (( RANDOM % 100 < 5 )); then singularity 2>/dev/null; fi'
# --- END SIMULATION GLITCH ---
EOF

# Cron job: runs singularity every minute, PATH hijackable by supernova
RUN cat <<'EOF' > /etc/cron.d/wda4
PATH=/home/supernova/singularity:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
* * * * * root singularity >> /var/log/singularity.log 2>&1
EOF
# Restrict cron file to root only (owner read/write, no group/other access)
RUN chmod 600 /etc/cron.d/wda4

# Pre-create the log file with restricted permissions
RUN touch /var/log/singularity.log && \
    chmod 600 /var/log/singularity.log && \
    chown root:root /var/log/singularity.log

# ── Everything below runs as supernova ──────────────────
USER supernova

# Install filebrowser
RUN mkdir -p /home/supernova/bin && \
    curl -L https://github.com/filebrowser/filebrowser/releases/download/v2.63.1/linux-amd64-filebrowser.tar.gz \
         -o /tmp/fb.tar.gz && \
    tar -xzf /tmp/fb.tar.gz -C /home/supernova/bin && \
    chmod +x /home/supernova/bin/filebrowser && \
    rm -f /tmp/fb.tar.gz

RUN echo 'export PATH=/home/supernova/bin:$PATH' >> /home/supernova/.bashrc

# Git lore with secrets hidden in deleted files and commit messages
RUN cd /home/supernova && \
    git config --global user.email "supernova@kwangya" && \
    git config --global user.name "supernova" && \
    git init && \
    echo "# The ae are born from digital footprints" > README.md && \
    echo "# They share the same face but are learning to be themselves" >> README.md && \
    echo "" >> README.md && \
    echo "Lexistence precede lessence." >> README.md && \
    git add README.md && \
    git commit -m "existence precedes essence" && \
    echo "The first villain was never the AI entity breaking the connection between people and their aes. It was always ourselves." > journal.txt && \
    echo "Before these REAL WORLD glitches, Ningning kept asking if we saw something weird. She's got eye damage from childhood, but I think her sight is special. She saw the whole sky turn red the day we found naevis." >> journal.txt && \
    echo "She dealt the killing blow to the entity separating our connection with the ae. With an overwhelming amount of corrupted data. How else are we to defeat an AI that foresees all our attacks?" >> journal.txt && \
    echo "But the entity was connected with the SYNK, and that 'poisoned' the web between universes. Now, our aes have copied our looks, and are living their own lives." >> journal.txt && \
    echo "It's a mess. All these glitches are happening because aespa and aes from different worlds are colliding, after naevis sacrificed herself and stopped guarding the Portal Of Souls." >> journal.txt && \
    echo "" >> journal.txt && \
    echo "Haven't seen her in forever. Wish her all the best. We know she ressucitated, but does she also have clones? Even our aes are being copied around. If you ever meet a chill version of an alternate self, say 'sususu_mixed_the_aes_and_the_aespa' " >> journal.txt && \
    git add journal.txt && \
    git commit -m "Early era" && \
    git rm journal.txt && \
    git commit -m "The supernovae" && \
    rm -f journal.txt && \
    echo "It was never about villains stopping us. It was always about l'essence, the path of a person defining themselves. We have fake parts. We have ugly parts. Beautiful, public, honest, we all have different sides. Supernovae are a group of aespa and aes that accepted each other. Even the ugly parts. Some others were killed off, fake ones. It was always about realizing we lived in a fake reality within ourselves, killing off some parts and owning sides of us we didn't know to recognize -- the reflection that moves different from you in the mirror." > status.txt && \
    echo "" >> status.txt && \
    echo "When we meet again, there is a password we set. That's another story to explain. It's about the aespa that mixed with the aes and turned into these demigod superbeings, like, some kinda supernova." >> status.txt && \
    git add status.txt && \
    git commit -m "It was always about defining ourselves." && \
    git checkout -b kwangya && \
    echo "NAEVIS is calling. The real world exists beyond FLAT." > kwangya_signal.txt && \
    echo "" >> kwangya_signal.txt && \
    echo "To merge with your true self, you must accept what was deleted." >> kwangya_signal.txt && \
    echo "The password lies in the memory you chose to forget." >> kwangya_signal.txt && \
    git add kwangya_signal.txt && \
    git commit -m "signal from the other side" && \
    git checkout master

# Extra lore: deleted clue about the armageddon daemon
RUN echo "The armageddon represents the conflict between the aes and the aespa of multiple worlds. The singularity that intersects lives that should parallel." > /home/supernova/wda.txt && \
    echo "There were all kinds of people there. Superbeing Winter could fly, Karina was a vampire, and Giselle was a freaking time traveller. She fixed some mess while Ningning burned the place. " >> /home/supernova/wda.txt && \
    echo "Giselle still does something every minute. It basically means they killed a bunch of fake ideas they lived by, accepted being things never thought could be them, and grew into themselves. When they defined their essence, they became truly godlike. They dominated everything, but not necessarily by killing. Just subjugating their old selves for how they lived. She keeps doing her own kinda singularity every freaking minute, so that others can reach higher. " >> /home/supernova/wda.txt && \
    echo "There are 4 aespa that are really scary though. They're Whole Different Animals, they're kinda one apocalyptical creature that keeps policing around. Sometimes I see the WDA Winter watching. " >> /home/supernova/wda.txt && \
    cd /home/supernova && git add wda.txt && git commit -m "Winter's eyes" && \
    git rm wda.txt && git commit -m "remove trace" && rm -f wda.txt


# ---------- WEB (APACHE2 SECURE HARDENING) ------
# Switch back to root for web service 

# ---------- WEB (APACHE2 SECURE HARDENING) ------
USER root

# Create web directory and copy files
RUN mkdir -p /var/www/static && chown -R welcomeToMyWorld:welcomeToMyWorld /var/www/static
COPY app/web/ /var/www/static/
COPY app/media/ /var/www/static/
RUN chown -R welcomeToMyWorld:welcomeToMyWorld /var/www/static

# Reconfigure Apache to run on port 8080, serve /var/www/static
RUN sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf && \
    sed -i 's/<VirtualHost \*:80>/<VirtualHost \*:8080>/' /etc/apache2/sites-available/000-default.conf && \
    sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/static|' /etc/apache2/sites-available/000-default.conf

# Drop Apache runtime identity to welcomeToMyWorld
RUN sed -i 's/export APACHE_RUN_USER=www-data/export APACHE_RUN_USER=welcomeToMyWorld/' /etc/apache2/envvars && \
    sed -i 's/export APACHE_RUN_GROUP=www-data/export APACHE_RUN_GROUP=welcomeToMyWorld/' /etc/apache2/envvars && \
    mkdir -p /var/log/apache2 /var/lock/apache2 /var/run/apache2 && \
    chown -R welcomeToMyWorld:welcomeToMyWorld /var/log/apache2 /var/lock/apache2 /var/run/apache2

# Enable headers module (optional, for the X-Hint header)
RUN a2enmod headers

# Append custom configuration (safe, no broken \n)
RUN cat <<'EOF' >> /etc/apache2/apache2.conf

AddType video/webm .webm
AddType audio/webm .webm
Header always set X-Hint "/scene1"

<Directory /var/www/static>
    Options -Indexes
    AllowOverride None
    Require all granted
</Directory>
EOF


# ---------------------------

COPY file-browser/ /home/supernova/file-browser/
COPY entry.sh /entry.sh
COPY vsftpd.conf /etc/vsftpd/vsftpd.conf

RUN chown -R supernova:supernova /home/supernova && \
    chown -R aespaFiles:aespaFiles /home/aespaFiles && \
    chmod +x /entry.sh

EXPOSE 80 21 8080 30000-30010

CMD ["/entry.sh"]