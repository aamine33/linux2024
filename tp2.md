Partie : Files and users

I. Fichiers

1. Find me

🌞 Trouver le chemin vers le répertoire personnel de votre utilisateur
``````
batman33@BATPC:~$ pwd
/home/batman33
``````
🌞 Trouver le chemin du fichier de logs SSH
``````
batman33@BATPC:/$ cd /var
batman33@BATPC:/var$ ls
backups  cache  crash  lib  local  lock  log  mail  metrics  opt  run  snap  spool  tmp
atman33@BATPC:/var$ cd log
batman33@BATPC:/var/log$ ls
alternatives.log  auth.log       btmp          dmesg       dmesg.2.gz  dpkg.log  fontconfig.log   gpu-manager-switch.log  journal   openvpn            syslog                vbox-setup.log
apport.log        boot.log       cups          dmesg.0     dmesg.3.gz  faillog   gdm3             hp                      kern.log  private            ubuntu-advantage.log  wtmp
apt               bootstrap.log  dist-upgrade  dmesg.1.gz  dmesg.4.gz  firebird  gpu-manager.log  installer               lastlog   speech-dispatcher  unattended-upgrades
batman33@BATPC:/var/log$ nano auth.log
(je vois un historique de toutes les connexions dans ce fichier en nano)
``````
🌞 Trouver le chemin du fichier de configuration du serveur SSH
``````
atman33@BATPC:/var/log$ cd ..
batman33@BATPC:/var$ cd ..
batman33@BATPC:/$ cd /var
batman33@BATPC:/var$ ls
backups  crash  local  log   metrics  run   spool
cache    lib    lock   mail  opt      snap  tmp
batman33@BATPC:/var$ cd log
batman33@BATPC:/var/log$ ls
alternatives.log  dmesg       fontconfig.log          openvpn
apport.log        dmesg.0     gdm3                    private
apt               dmesg.1.gz  gpu-manager.log         speech-dispatcher
auth.log          dmesg.2.gz  gpu-manager-switch.log  syslog
boot.log          dmesg.3.gz  hp                      ubuntu-advantage.log
bootstrap.log     dmesg.4.gz  installer               unattended-upgrades
btmp              dpkg.log    journal                 vbox-setup.log
cups              faillog     kern.log                wtmp
dist-upgrade      firebird    lastlog
batman33@BATPC:/var/log$ nano fontconfig.log
``````
II. Users

1. Nouveau user
🌞 Créer un nouvel utilisateur
``````
(amine@Aminerog)-[~]$ : sudo useradd -m -d /home/papier_alu/marmotte marmotte
(amine@Aminerog)-[~]$ : sudo passwd marmotte 
(mettre le mot de passe 'chocolat')
``````
2. Infos enregistrées par le système
🌞 Prouver que cet utilisateur a été créé
``````
(amine@Aminerog)-[/home]$ : cat /etc/passwd | grep marmotte
(amine@Aminerog)-[/home]$ : marmotte:x:1001:1001::/home/papier_alu/marmotte:/bin/sh
``````
🌞 Déterminer le hash du password de l'utilisateur marmotte
````
(amine@Aminerog)-[/home]$ : sudo cat /etc/shadow | grep marmotte
(amine@Aminerog)-[/home]$ : marmotte:$y$j9T$TJLmx5v/Ke.ticrIDRn20$BAEt8r.TjrGZtVv0M3GTfKmufqnUtUjxLHfiPFNxfoB:19744:0:99999:7:::
````
3. Connexion sur le nouvel utilisateur

🌞 Tapez une commande pour vous déconnecter : fermer votre session utilisateur
``````
(amine@Aminerog)-[/home]$ : exit
``````
🌞 Assurez-vous que vous pouvez vous connecter en tant que l'utilisateur marmotte
``````
(amine@Aminerog)-[/home]$ : su - marmotte
Password : (chocolat)
$
``````
Partie 2 : Programmes et paquets

I. Programmes et processus

1. Run then kill

🌞 Lancer un processus sleep

``````
(dans le premier terminal):
(amine@Aminerog)-[~] : sleep 1000
(dans le deuxième terminal):
(amine@Aminerog)-[/home]$ : ps aux | grep sleep
amine  63898 0.0 0.0 5896 1536 pts/0 S+ 20:22 0:00 sleep 1000
amine  63984 0.0 0.0 6872 2176 pts/2 S+ 20:22 0.00 /usr/bin/grep slepp
``````
🌞 Terminez le processus sleep depuis le deuxième terminal

``````
(amine@Aminerog)-[/home/amine] : pgrep sleep
PS > 67472
(amine@Aminerog)-[/home/amine] : kill 67472 
(dans le premier terminal) :
(amine@Aminerog)-[~] : sleep 1000
zsh : terminated sleep 1000
``````

2. Tâche de fond

🌞 Lancer un nouveau processus sleep, mais en tâche de fond

``````
(amine@Aminerog)-[~] : sleep 1000 &
[1] 71451
``````

🌞 Visualisez la commande en tâche de fond
``````
(amine@Aminerog)-[~] : jobs
[1] +running sleep 1000
``````
3. Find paths

🌞 Trouver le chemin où est stocké le programme sleep

``````
(amine@Aminerog)-[~] : which sleep (command -v sleep)
/usr/bin/sleep
(ls -al /bin | grep sleep)
``````
🌞 Tant qu'on est à chercher des chemins : trouver les chemins vers tous les fichiers qui s'appellent .bashrc
``````
(amine@Aminerog)-[/home/amine] : sudo find / -name *.bashrc
[sudo] password for amine :
/usr/share/kali-defaults/etc/skel/.bashrc
/usr/share/doc/adduser/examples/adduser.local.conf.examples/skel/dot.bashrc
/usr/share/doc/adduser/examples/adduser.local.conf.examples/bash.bashrc
/usr/share/base-files/doc.bashrc
find: '/run/user/1000/gvfs': Permission denied
/etc/skel/.bashrc
/etc/bash.bashrc
/root/.bashrc
/home/amine/.bashrc
/home/papier_alu/marmotte/.bashrc
``````
4. La variable PATH

🌞 Vérifier que

``````
- pour sleep :
(amine@Aminerog)-[/home/amine] : which sleep
/usr/bin/sleep

- pour ssh :
(amine@Aminerog)-[/home/amine] :  which ssh
/usr/bin/ssh

- pour ping :
(amine@Aminerog)-[/home/amine] : which ping
/usr/bin/ping
``````
II. Paquets

🌞 Installer le paquet firefox

``````
(amine@Aminerog)-[/home/amine] : sudo apt install firefox
``````
🌞 Utiliser une commande pour lancer Firefox
``````
(amine@Aminerog)-[/home/amine] : firefox
``````
🌞 Installer le paquet nginx
``````
(amine@Aminerog)-[/home/amine] : sudo apt install nginx
``````
🌞 Déterminer
``````
(le chemin vers le dossiers de logs de NGINX):

(amine@Aminerog)-[/home/amine] : sudo grep -R access_log /etc/nginx/
/etc/nginx/nginx.conf: access_log /var/log/nginx/access.log;

(amine@Aminerog)-[/home/amine] : sudo grep -R error_log /etc/nginx
/etc/nginx/nginx.conf:error_log /var/log/nginx/error_log;

(pour le chemin vers le dossier qui contient la configuration de NGINX)

(amine@Aminerog)-[/home/amine] : ls /etc/nginx/nginx.conf
/etc/nginx/nginx.conf

(amine@Aminerog)-[/home/amine] : ls /etc/nginx/sites-available
default

(amine@Aminerog)-[/home/amine] : ls /etc/nginx/sites-enabled
default
``````
🌞 Mais aussi déterminer...
``````
- l'adresse http ou https des serveurs où vous téléchargez des paquets :

(amine@Aminerog)-[/home/amine] : cat /etc/apt/sources.list
#see https://www.kali.org/docs/general-use/kali-linux-sources-list-repositories/ deb https://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware

# Additionnal line for source packages

# deb-src http://htpp.kali.org/kali kali-rolling main non-free non-free-firmware

- une commande apt install ou dnf install permet juste de faire un téléchargement HTTP :

(amine@Aminerog)-[/home/amine] : sudo apt-get download http
- ma question c'est donc : sur quel URL tu t'es connecté pour télécharger ce paquet :

Je me suis connecté avec le premier URL pour télécharger ce paquet

- il existe un dossier qui contient la liste des URLs consultées quand vous demandez un téléchargement de paquets: 

(amine@Aminerog)-[/home/amine] : /etc/apt/sources.list
``````

Partie 3 : Poupée russe

🌞 Récupérer le fichier meow
``````
┌──(amine㉿Aminerog)-[~] : wget "https://gitlab.com/it4lik/b1-linux-2023/-/blob/master/tp/2/meow"
``````

🌞 Trouver le dossier dawa/

``````
- utilisez la commande file /path/vers/le/fichier pour déterminer le type du fichier:

(amine@Aminerog)-[~] : file -v meow
file-5.45
magic file from /etc/magic:/usr/share/misc/magic

- renommez-le fichier correctement (si c'est une archive compressée ZIP, il faut ajouter .zip à son nom) :

(amine㉿Aminerog)-[~]
└─$ cd Downloads    
(amine@Aminerog)-[~] : mv -i meow meow.zip
┌──(amine㉿Aminerog)-[~/Downloads]
└─$ ls
meow.zip
                
- extraire l'archive avec une commande :

(amine㉿Aminerog)-[~]
└─$ cd Downloads    
(amine@Aminerog)-[~] : ls
meow.zip
┌──(amine㉿Aminerog)-[~/Downloads]
└─$ ls  
meow.zip
(amine㉿Aminerog)-[~]
└─$ sudo unzip meow.zip
Archive: meow.zip
    inflating: meow

- répétez ces opérations jusqu'à trouver le dossier dawa/ :

┌──(amine㉿Aminerog)-[~/Downloads/dossier]
└─$ ls
meow
┌──(amine㉿Aminerog)-[~/Downloads/dossier]
└─$ file meow
meow: XZ compressed data, checksum CRC64┌──(amine㉿Aminerog)-[~/Downloads/dossier]
└─$ mv meow meow.xz
┌──(amine㉿Aminerog)-[~/Downloads/dossier]
└─$ file meow.xz
meow.xz: XZ compressed data, checksum CRC64
┌──(amine㉿Aminerog)-[~/Downloads/dossier]
└─$ xz -d meow.xz
┌──(amine㉿Aminerog)-[~/Downloads/dossier]
└─$ ls
meow
┌──(amine㉿Aminerog)-[~/Downloads/dossier]
└─$ file meow
meow: bzip2 compressed data, block size = 900k
┌──(amine㉿Aminerog)-[~/Downloads/dossier]
└─$ bunzip2 meow
┌──(amine㉿Aminerog)-[~/Downloads/dossier]
└─$ ls
meow.out      
┌──(amine㉿Aminerog)-[~/Downloads/dossier]
└─$ file meow.out
meow.out: RAR archive data, v5
┌──(amine㉿Aminerog)-[~/Downloads/dossier]
└─$ unrar meow.out
┌──(amine㉿Aminerog)-[~/Downloads/dossier]
└─$ mv meow.out meow.rar
┌──(amine㉿Aminerog)-[~/Downloads/dossier]
└─$ ls
meow.rar
┌──(amine㉿Aminerog)-[~/Downloads/dossier]
└─$ unrar x meow.rar

UNRAR 7.00 beta 2 freeware      Copyright (c) 1993-2023 Alexander Roshal


Extracting from meow.rar

Extracting  meow                                                      OK
All OK
┌──(amine㉿Aminerog)-[~/Downloads/dossier]
└─$ file meow
meow: gzip compressed data, from Unix, original size modulo 2^32 145049600 gzip compressed data, reserved method, has CRC, extra field, has comment, from FAT filesystem (MS-DOS, OS/2, NT), original size modulo 2^32 145049600
┌──(amine㉿Aminerog)-[~/Downloads/dossier]
└─$ mv meow  meow.tar.gz
┌──(amine㉿Aminerog)-[~/Downloads/dossier]
└─$ tar -xvf meow.tar.gz
┌──(amine㉿Aminerog)-[~/Downloads/dossier]
└─$ ls
dawa  meow.rar  meow.tar.gz

``````
🌞 Dans le dossier dawa/, déterminer le chemin vers

``````
- le seul fichier de 15Mo
┌──(amine㉿Aminerog)-[~/Downloads/dossier/dawa]
└─$ find -type f -size 15M
./folder31/19/file39

- le seul fichier qui ne contient que des 7
┌──(amine㉿Aminerog)-[~/Downloads/dossier/dawa]
└─$ 

- le seul fichier qui est nommé cookie :

┌──(amine㉿Aminerog)-[~/Downloads/dossier/dawa]
└─$ find -type f -name "cookie"                           
./folder14/25/cookie
                         

- le seul fichier caché (un fichier caché c'est juste un fichier dont le nom commence par un .) :

┌──(amine㉿Aminerog)-[~/Downloads/dossier/dawa]
└─$ find -type f -name .* (ou find -type f -name .* -exec basename {};)  
./folder32/14/.hidden_file


- le seul fichier qui date de 2014 :

┌──(amine㉿Aminerog)-[~/Downloads/dossier/dawa]
└─$ find  -type f -newermt 2014-01-01 ! -newermt 2015-01-01 -exec stat --format="%Y %n" {} \; | sort -n | head -n 1 

1390312815 ./folder36/40/file43

- le seul fichier qui a 5 dossiers-parents :



je pense que vous avez vu que la structure c'est 50 folderX, chacun contient 50 dossiers X, et chacun contient 50 fileX

bon bah là y'a un fichier qui est contenu dans folderX/X/X/X/X/ et c'est le seul qui 5 dossiers parents comme ça
