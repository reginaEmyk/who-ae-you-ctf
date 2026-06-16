Build and run
docker compose up --build
Scan it
nmap -sV localhost -p 21,22,8080

Expected output:

21/tcp   open  ftp
22/tcp   open  ssh
8080/tcp open  http
SSH test
ssh winter@localhost -p 2222

Password:

winter
ssh guy@localhost -p 2222

Password:

guy


TO install Docker 

https://docs.docker.com/desktop/setup/install