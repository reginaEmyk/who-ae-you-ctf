# Build & run 
```
docker compose build --no-cache
docker compose up -d
```

# CTF
index: credenciais ftp base64  
    da pra ver que puxa um script de /scene1 , encontravel pelo burpsuite 
ftp na porta 10101 portal pra n8n 
ftp tem foto com algo necessario p acessar n8n
n8n CVE RCE autenticado PORTA proxy or smt (burpsuite?)
    bruteforce user winter, password flowers
PE
    path hijack 


string base 64
echo "SGkgYWVzcGEuIEkgZG9uJ3Qga25vdyBpZiB5b3UncmUgdGhlIHJlYWwsIHRoZSBmYWtlLCB0aGUgQUkgYWVzcGEgb3Igd2hhdGV2ZXIsIEknbGwgbGV0IHlvdSBsaXZlIGlmIHlvdSBjYW4gbWFrZSB0aHJvdWdoIHRoaXMgY2hhbGxlbmdlLg==" >> app/media/Welcome.png 


scene1.html, video: username (artista) e password (comentario) do ftp, exiftool
scene1.html, gif : SALT da password pkbmc2. usado p criptografia: https://8gwifi.org/pbkdf.jsp
ftp: user aespa password cooper
n8n vulneravel CVE-2026-1470, 

# TODO
ftp: binwalk na imagem leva a um login 
bruteforce no login (user winter password flowers ) leva ao n8n
n8n vulneravel CVE-2026-1470, atacante upload rev shell = foothold
PE (path hijack, SUID?) todo, poucas ideias de como fazer

# Problemas
imagem enorme , 2.22GB
cuidado pra nao usar nginx, ou qqr csa q introduz unauthenticated RCE 


ps flower e cooper estao na rockyou.txt