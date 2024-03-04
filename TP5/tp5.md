TP 5 : We do a little scripting

Partie 1 : Script carte d'identité

🌞 Vous fournirez dans le compte-rendu Markdown, en plus du fichier, un exemple d'exécution avec une sortie

```
batman33@BATPC:~$ sudo mkdir -p /srv/idcard/
batman33@BATPC:~$ sudo nano /srv/idcard/idcard.sh
batman33@BATPC:~$ cd /srv/idcard
batman33@BATPC:/srv/idcard$ sudo chmod +x idcard.sh
batman33@BATPC:/srv/idcard$ sudo ./idcard.sh
Nom de la machine :
LTS
Nom de l'OS de la machine :
Ubuntu 22.04.3 LTS
Version du noyau Linux :
6.5.0-17-generic
Adresse IP de la machine :
127.0.0.1
192.168.1.78
10.3.1.1
État de la RAM :
Mem:            15Gi       5,3Gi       1,2Gi       1,2Gi       8,9Gi       8,6Gi
Espace restant sur le disque dur :
288G
Top 5 des processus qui utilisent le plus de RAM :
firefox 4.1
Isolated Web
Isolated Web
chrome 2.4
chrome 2.3
Liste des ports en écoute :
udp 0.0.0.0:631
udp 0.0.0.0:37486
udp 224.0.0.251:5353
udp 224.0.0.251:5353
udp 224.0.0.251:5353
udp 0.0.0.0:5353
udp 127.0.0.53%lo:53
udp [::]:42356
udp [::]:5353
tcp 0.0.0.0:22
tcp 127.0.0.53%lo:53
tcp 127.0.0.1:631
tcp *:80
tcp [::]:22
tcp [::1]:631
Dossiers disponibles dans la variable PATH :
/usr/local/sbin
/usr/local/bin
/usr/sbin
/usr/bin
/sbin
/bin
/snap/bin

```
Bonus

⭐ Bonus 1 : arguments

```
cf "affichagebonus1.png"
```

⭐ Bonus 2 : votre script doit s'exécuter en root
```
cf "affichabonus2.png"
```

II. Script youtube-dl

1. Premier script youtube-dl

A. Le principe + B. Rendu attendu

```
batman33@BATPC:/$ sudo su
root@BATPC:/# mkdir -p /var/log/yt/
root@BATPC:/# exit
exit
batman33@BATPC:/$ sudo chown root:root /var/log/yt/
batman33@BATPC:/$ ls -l /var/log/yt/
total 0
batman33@BATPC:/$ sudo mkdir -p /srv/yt/downloads
batman33@BATPC:/$ sudo chown root:root /srv/yt/downloads
batman33@BATPC:/$ sudo chmod 755 /srv/yt/downloads
batman33@BATPC:/$ sudo chmod +x /srv/yt/yt.sh
batman33@BATPC:/$ sudo /srv/yt/yt.sh https://www.youtube.com/watch?v=sNx57atloH8
/srv/yt/yt.sh: ligne 16: youtube-dl : commande introuvable
Video https://www.youtube.com/watch?v=sNx57atloH8 was downloaded.
File path : /srv/yt/downloads//.mp4
batman33@BATPC:/$ sudo apt install youtube-dl
batman33@BATPC:/$ sudo /srv/yt/yt.sh --verbose https://www.youtube.com/watch?v=sNx57atloH8
[debug] System config: []
[debug] User config: []
[debug] Custom config: []
[debug] Command-line args: ['--get-title', '--verbose']
[debug] Encodings: locale UTF-8, fs utf-8, out utf-8, pref UTF-8
[debug] youtube-dl version 2021.12.17
[debug] Python version 3.10.12 (CPython) - Linux-6.5.0-17-generic-x86_64-with-glibc2.35
[debug] exe versions: ffmpeg 4.4.2, ffprobe 4.4.2, rtmpdump 2.4
[debug] Proxy map: {}
WARNING: Long argument string detected. Use -- to separate parameters and URLs, like this:
youtube-dl --verbose -- --get-title

Usage: youtube-dl [OPTIONS] URL [URL...]

youtube-dl: error: You must provide at least one URL.
Type youtube-dl --help to see a list of all options.
Video --verbose was downloaded.
File path : /srv/yt/downloads//.mp4
batman33@BATPC:/srv/yt$ sudo /srv/yt/yt.sh https://www.youtube.com/watch?v=YOQbZPtj4Bg
ERROR: Unable to extract uploader id; please report this issue on https://yt-dl.org/bug . Make sure you are using the latest version; see  https://yt-dl.org/update  on how to update. Be sure to call youtube-dl with the --verbose flag and include its complete output.
Téléchargement de la vidéo...
ERROR: Unable to extract uploader id; please report this issue on https://yt-dl.org/bug . Make sure you are using the latest version; see  https://yt-dl.org/update  on how to update. Be sure to call youtube-dl with the --verbose flag and include its complete output.
Téléchargement de la description...
ERROR: Unable to extract uploader id; please report this issue on https://yt-dl.org/bug . Make sure you are using the latest version; see  https://yt-dl.org/update  on how to update. Be sure to call youtube-dl with the --verbose flag and include its complete output.
Téléchargement terminé avec succès dans /srv/yt/downloads//.
batman33@BATPC:/srv/yt$ sudo youtube-dl --u
--update      --user-agent  --username    
batman33@BATPC:/srv/yt$ sudo youtube-dl --update 
Usage: youtube-dl [OPTIONS] URL [URL...]

youtube-dl: error: youtube-dl's self-update mechanism is disabled on Debian.
Please update youtube-dl using apt(8).
See https://packages.debian.org/sid/youtube-dl for the latest packaged version.

(le script est bon et j'ai bien configuré ce qui a été demandé. Mais je fais ce tp sur mon propre pc car je suis ubuntu, si cela ne marche pas, c'est a cause de youtube-dl ou i ly'a un problème de bocage qui n'a pas été encore résolu. Je pense que faire ce TP sous Rocky aurait pu marcher avec les memes configurations et meme script, c'est meme certains car le terminal me renvoie un message d'extraction du téléchargement  et me dit qu'il faut voir pour la dernière version de youtube-dl )

```

2. MAKE IT A SERVICE

A. Adaptation du script + B. Le service + C. Rendu

🌞 Vous fournirez dans le compte-rendu, en plus des fichiers :

```
batman33@BATPC:/srv/yt$ cd yt-v2/
batman33@BATPC:/srv/yt/yt-v2$ ls
batman33@BATPC:/srv/yt/yt-v2$ sudo nano /srv/yt/yt-v2.sh
batman33@BATPC:/srv/yt/yt-v2$ sudo /srv/yt/yt.sh
Veuillez fournir l'URL de la vidéo YouTube à télécharger.
batman33@BATPC:/srv/yt/yt-v2$ cd ..
batman33@BATPC:/srv/yt$ chmod +x yt-v2.sh
chmod: modification des droits de 'yt-v2.sh': Opération non permise
batman33@BATPC:/srv/yt$ sudo chmod +x yt-v2.sh
batman33@BATPC:/srv/yt$ ./yt-v2.sh
(en chargement)
 cd ..
batman33@BATPC:/srv$ cd ..
batman33@BATPC:/$ sudo nano /etc/systemd/system/yt.service
([Unit]
Description=Service de téléchargement de vidéos YouTube
After=network.target

[Service]
ExecStart=/srv/yt/yt-v2.sh
User=yt

[Install]
WantedBy=multi-user.target
)
batman33@BATPC:/$ sudo adduser --system --no-create-home yt
Ajout de l'utilisateur système « yt » (UID 131) ...
Ajout du nouvel utilisateur « yt » (UID 131) avec pour groupe d'appartenance « nogroup » ...
Pas de création du répertoire personnel « /home/yt ».
batman33@BATPC:/$ sudo addgroup yt
Ajout du groupe « yt » (GID 1001)...
Fait.
batman33@BATPC:/$ sudo chown -R :yt /srv/yt
batman33@BATPC:/$ sudo chown yt:yt /var/log/yt.log
chown: impossible d'accéder à '/var/log/yt.log': Aucun fichier ou dossier de ce type
batman33@BATPC:/$ sudo su
root@BATPC:/# sudo chown yt:yt /var/log/yt.log
chown: impossible d'accéder à '/var/log/yt.log': Aucun fichier ou dossier de ce type
root@BATPC:/# exit
exit
batman33@BATPC:/$ sudo touch /var/log/yt.log
batman33@BATPC:/$ sudo chown yt:yt /var/log/yt.log
batman33@BATPC:/$ sudo usermod -aG yt yt
batman33@BATPC:/$ sudo systemctl daemon-reload
batman33@BATPC:/$ systemctl status yt
○ yt.service - Service de téléchargement de vidéos YouTube
     Loaded: loaded (/etc/systemd/system/yt.service; disabled; vendor preset: enabled)
     Active: inactive (dead)
batman33@BATPC:/$ systemctl start yt
batman33@BATPC:/$ systemctl status yt
● yt.service - Service de téléchargement de vidéos YouTube
     Loaded: loaded (/etc/systemd/system/yt.service; disabled; vendor preset: enabled)
     Active: active (running) since Fri 2024-03-01 18:06:32 CET; 2s ago
   Main PID: 148376 (yt-v2.sh)
      Tasks: 2 (limit: 18764)
     Memory: 552.0K
        CPU: 2ms
     CGroup: /system.slice/yt.service
             ├─148376 /bin/bash /srv/yt/yt-v2.sh
             └─148377 sleep 60

mars 01 18:06:32 BATPC systemd[1]: Started Service de téléchargement de vidéos YouTube.
batman33@BATPC:/$ systemctl stop yt
batman33@BATPC:/$ systemctl status yt
○ yt.service - Service de téléchargement de vidéos YouTube
     Loaded: loaded (/etc/systemd/system/yt.service; disabled; vendor preset: enabled)
     Active: inactive (dead)

mars 01 18:06:32 BATPC systemd[1]: Started Service de téléchargement de vidéos YouTube.
mars 01 18:10:37 BATPC systemd[1]: Stopping Service de téléchargement de vidéos YouTube...
mars 01 18:10:37 BATPC systemd[1]: yt.service: Deactivated successfully.
mars 01 18:10:37 BATPC systemd[1]: Stopped Service de téléchargement de vidéos YouTube.
(l'ordinateur demande le mot de passe pour le start et le stop de yt donc ca marche)
```

3. Bonus

```
batman33@BATPC:/$ sudo kill -9 149673
batman33@BATPC:/$ sudo apt-get install shellcheck
Lecture des listes de paquets... Fait
Construction de l'arbre des dépendances... Fait
Lecture des informations d'état... Fait      
Les NOUVEAUX paquets suivants seront installés :
  shellcheck
0 mis à jour, 1 nouvellement installés, 0 à enlever et 0 non mis à jour.
Il est nécessaire de prendre 2 359 ko dans les archives.
Après cette opération, 16,3 Mo d'espace disque supplémentaires seront utilisés.
Réception de :1 http://fr.archive.ubuntu.com/ubuntu jammy/universe amd64 shellcheck amd64 0.8.0-2 [2 359 kB]
2 359 ko réceptionnés en 9s (250 ko/s)                                                                        
Sélection du paquet shellcheck précédemment désélectionné.
(Lecture de la base de données... 324109 fichiers et répertoires déjà installés.)
Préparation du dépaquetage de .../shellcheck_0.8.0-2_amd64.deb ...
Dépaquetage de shellcheck (0.8.0-2) ...
Paramétrage de shellcheck (0.8.0-2) ...
Traitement des actions différées (« triggers ») pour man-db (2.10.2-1) ...
batman33@BATPC:/$ getopt
getopt: argument chaîne_opt manquant
Exécutez « getopt --help » pour obtenir des renseignements complémentaires.
batman33@BATPC:/$ getopts
getopts : utilisation : getopts chaineopts nom [arg ...]
batman33@BATPC:/$ cd srv/yt
batman33@BATPC:/srv/yt$ ls
downloads  urls.txt  yt.service  yt.sh  yt.timer  yt-v2  yt-v2.sh
batman33@BATPC:/srv/yt$ cp yt-v2.sh /srv/yt/
cp: 'yt-v2.sh' et '/srv/yt/yt-v2.sh' identifient le même fichier
batman33@BATPC:/srv/yt$ chmod +x /srv/yt/yt-v2.sh
chmod: modification des droits de '/srv/yt/yt-v2.sh': Opération non permise
batman33@BATPC:/srv/yt$ sudo chmod +x /srv/yt/yt-v2.sh
batman33@BATPC:/srv/yt$ sudo nano /srv/yt/yt-v2.sh
batman33@BATPC:/srv/yt$ sudo /srv/yt/yt-v2.sh
batman33@BATPC:/srv/yt$ chmod +x /srv/yt/yt-v2.sh
chmod: modification des droits de '/srv/yt/yt-v2.sh': Opération non permise
batman33@BATPC:/srv/yt$ sudo chmod +x /srv/yt/yt-v2.sh
batman33@BATPC:/srv/yt$ /srv/yt/yt-v2.sh
batman33@BATPC:/srv/yt$ ./yt-v2.sh
batman33@BATPC:/srv/yt$ ls -l /srv/yt/yt-v2.sh
-rwxr-xr-x 1 root yt 766 mars   1 18:32 /srv/yt/yt-v2.sh
batman33@BATPC:/srv/yt$ sed -i 's/dev\/null/tty/g' /srv/yt/yt-v2.sh
sed: impossible d'ouvrir le fichier temporaire /srv/yt/sedJV0x2N: Permission non accordée
batman33@BATPC:/srv/yt$ sudo sed -i 's/dev\/null/tty/g' /srv/yt/yt-v2.sh
batman33@BATPC:/srv/yt$ /srv/yt/yt-v2.sh
batman33@BATPC:/srv/yt$ sudo /srv/yt/yt-v2.sh
batman33@BATPC:/srv/yt$ sed -i '/dev\/null/d' /srv/yt/yt-v2.sh  
sed: impossible d'ouvrir le fichier temporaire /srv/yt/sedsNN7zg: Permission non accordée
batman33@BATPC:/srv/yt$ sudo sed -i '/dev\/null/d' /srv/yt/yt-v2.sh
```

