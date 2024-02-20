TP4 : Real services

Partie 1 : Partitionnement du serveur de stockage

🌞 Partitionner le disque à l'aide de LVM
```
- créer un physical volume (PV) :

[amine@localhost ~]$ lsblk
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda           8:0    0   20G  0 disk 
├─sda1        8:1    0    1G  0 part /boot
└─sda2        8:2    0   19G  0 part 
  ├─rl-root 253:0    0   17G  0 lvm  /
  └─rl-swap 253:1    0    2G  0 lvm  [SWAP]
sdb           8:16   0    2G  0 disk 
sdc           8:32   0    2G  0 disk 
sr0          11:0    1 1024M  0 rom  
[amine@localhost ~]$ sudo pvcreate /dev/sdb
[sudo] password for amine: 
  Physical volume "/dev/sdb" successfully created.
[amine@localhost ~]$ sudo pvcreate /dev/sdc
  Physical volume "/dev/sdc" successfully created.
[amine@localhost ~]$ sudo pvs
  Devices file sys_wwid t10.ATA_VBOX_HARDDISK_VBa67d81f8-f04b7a06 PVID 0Kg7nvJBxcz5ke1cjktlzlhRrYpLHA2F last seen on /dev/sda2 not found.
  PV         VG   Fmt  Attr PSize  PFree 
  /dev/sdb   data lvm2 a--  <2.00g <2.00g
  /dev/sdc        lvm2 ---   2.00g  2.00g


- créer un nouveau volume (VG) :
[amine@localhost ~]$ sudo vgcreate data /dev/sdb
  Volume group "data" successfully created
[amine@localhost ~]$ sudo vgcreate data /dev/sdc
  A volume group called data already exists.
[amine@localhost ~]$ sudo vgs
  Devices file sys_wwid t10.ATA_VBOX_HARDDISK_VBa67d81f8-f04b7a06 PVID 0Kg7nvJBxcz5ke1cjktlzlhRrYpLHA2F last seen on /dev/sda2 not found.
  VG   #PV #LV #SN Attr   VSize  VFree 
  data   1   0   0 wz--n- <2.00g <2.00g
[amine@localhost ~]$ sudo vgextend data /dev/sdc
  Volume group "data" successfully extended


- créer un nouveau logical volume (LV) : ce sera la partition utilisable :

[amine@localhost ~]$ sudo lvcreate -l 100%FREE data -n  amine
  Logical volume "amine" created.
[amine@localhost ~]$ sudo lvs
[sudo] password for amine: 
  Devices file sys_wwid t10.ATA_VBOX_HARDDISK_VBa67d81f8-f04b7a06 PVID 0Kg7nvJBxcz5ke1cjktlzlhRrYpLHA2F last seen on /dev/sda2 not found.
  LV    VG   Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  amine data -wi-a----- <2.00g  

```

🌞 Formater la partition

```
- vous formaterez la partition en ext4(avec une commande mkfs)

[amine@localhost ~]$ sudo mkfs -t ext4 /dev/data/amine
mke2fs 1.46.5 (30-Dec-2021)
Creating filesystem with 523264 4k blocks and 130816 inodes
Filesystem UUID: fe2288b3-85c9-49fd-800c-478ab17dd03a
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376, 294912

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done 


```

🌞 Monter la partition
```
- montage de la partition (avec la commande mount) :

[amine@localhost ~]$ sudo mkdir /mnt/data1
[amine@localhost ~]$ sudo mount /dev/data/amine /mnt/data1

[amine@localhost dev]$ df -h
Filesystem              Size  Used Avail Use% Mounted on
devtmpfs                4.0M     0  4.0M   0% /dev
tmpfs                   1.8G     0  1.8G   0% /dev/shm
tmpfs                   730M  8.6M  722M   2% /run
/dev/mapper/rl-root      17G  1.4G   16G   8% /
/dev/sda1               960M  306M  655M  32% /boot
tmpfs                   365M     0  365M   0% /run/user/1000
/dev/mapper/data-amine  2.0G   24K  1.9G   1% /mnt/data1


-définir un montage automatique de la partition (fichier /etc/fstab) :

[amine@localhost ~]$ sudo nano /etc/fstab
[sudo] password for amine: 
(/dev/data/amine /mnt/data1 ext4 defaults 0 0)
[amine@localhost ~]$ sudo umount /mnt/data1
umount: /mnt/data1: not mounted.
[amine@localhost ~]$ sudo mount -av
/                        : ignored
/boot                    : already mounted
none                     : ignored

mount: /mnt/data1 does not contain SELinux labels.
       You just mounted a file system that supports labels which does not
       contain labels, onto an SELinux box. It is likely that confined
       applications will generate AVC messages and not be allowed access to
       this file system.  For more details see restorecon(8) and mount(8).
mount: (hint) your fstab has been modified, but systemd still uses
       the old version; use 'systemctl daemon-reload' to reload.
/mnt/data1               : successfully mounted


```
⭐BONUS
```
- utilisez une commande dd pour remplir complètement la nouvelle partition :

[amine@localhost dev]$ sudo dd if=/dev/zero of=/dev/data/amine bs=1M status=progress
1887436800 bytes (1.9 GB, 1.8 GiB) copied, 4 s, 472 MB/s
dd: error writing '/dev/data/amine': No space left on device
2045+0 records in
2044+0 records out
2143289344 bytes (2.1 GB, 2.0 GiB) copied, 4.62916 s, 463 MB/s

- prouvez que la partition est remplie avec une commande df :

[amine@localhost dev]$ df -h /mnt/data1
Filesystem              Size  Used Avail Use% Mounted on
/dev/mapper/data-amine   64Z   64Z  2.0G 100% /mnt/data1


- ajoutez un nouveau disque dur à la conf LVM :



- agrandissez la partition pleine à l'aide du nouveau disque :

- prouvez avec un df que la partition a bien été aggrandie :

```
Partie 2 : Serveur de partage de fichiers


🌞 Donnez les commandes réalisées sur le serveur NFS storage.tp4.linux

```
- contenu du fichier /etc/exports dans le compte-rendu notamment

[amine@localhost /]$ sudo yum install nfs-utils
[amine@localhost ~]$ sudo mkdir -p /storage/site_web_1
[amine@localhost ~]$ sudo mkdir -p /storage/site_web_2
[amine@localhost ~]$ sudo nano /etc/exports
(/storage/site_web_1 192.168.100.1(rw,sync,no_root_squash)
/storage/site_web_2 192.168.100.1rw,sync,no_root_squash)
)


```

🌞 Donnez les commandes réalisées sur le client NFS web.tp4.linux

```
- contenu du fichier /etc/fstab dans le compte-rendu notamment :
[amine@localhost /]$ sudo yum install nfs-utils
[amine@localhost ~]$ sudo mkdir -p /var/www/site_web_1
[sudo] password for amine: 
[amine@localhost ~]$ sudo mkdir -p /var/www/site_web_2
[amine@localhost ~]$ sudo nano /etc/fstab
(10.3.1.11:/storage/site_web_1 /var/www/site_web_1 nfs defaults 0 0
10.3.1.11:/storage/site_web_2 /var/www/site_web_2 nfs defaults 0 0
)
[amine@localhost ~]$ sudo mount -a
[amine@localhost ~]$ ls -ld /var/www/site_web_1 /var/www/site_web_2
drwxr-xr-x. 2 root root 6 Feb 19 20:44 /var/www/site_web_1
drwxr-xr-x. 2 root root 6 Feb 19 20:44 /var/www/site_web_2

```

Partie 3 : Serveur web

2. Install

🌞 Installez NGINX

```
[amine@localhost ~]$ sudo dnf install nginx

```

3. Analyse

🌞 Analysez le service NGINX

```
 - avec une commande ps, déterminer sous quel utilisateur tourne le processus du service NGINX :

[amine@localhost ~]$ ps aux | grep nginx
root       12431  0.0  0.0  10112   956 ?        Ss   21:47   0:00 nginx: master process /usr/sbin/nginx
nginx      12432  0.0  0.1  13912  4960 ?        S    21:47   0:00 nginx: worker process
nginx      12433  0.0  0.1  13912  4960 ?        S    21:47   0:00 nginx: worker process
nginx      12434  0.0  0.1  13912  4960 ?        S    21:47   0:00 nginx: worker process
nginx      12435  0.0  0.1  13912  4960 ?        S    21:47   0:00 nginx: worker process
amine      12517  0.0  0.0   3876  2028 pts/0    S+   21:56   0:00 grep --color=auto nginx

- avec une commande ss, déterminer derrière quel port écoute actuellement le serveur web :
[amine@localhost ~]$ ss -tuln | grep nginx


- en regardant la conf, déterminer dans quel dossier se trouve la racine web :

[amine@localhost ~]$ grep -R "root" /etc/nginx/nginx.conf
        root         /usr/share/nginx/html;
#        root         /usr/share/nginx/html;
[amine@localhost ~]$ ls -l /usr/share/nginx/html
total 12
-rw-r--r--. 1 root root 3332 Oct 16 19:58 404.html
-rw-r--r--. 1 root root 3404 Oct 16 19:58 50x.html
drwxr-xr-x. 2 root root   27 Feb 19 21:46 icons
lrwxrwxrwx. 1 root root   25 Oct 16 20:00 index.html -> ../../testpage/index.html
-rw-r--r--. 1 root root  368 Oct 16 19:58 nginx-logo.png
lrwxrwxrwx. 1 root root   14 Oct 16 20:00 poweredby.png -> nginx-logo.png
lrwxrwxrwx. 1 root root   37 Oct 16 20:00 system_noindex_logo.png -> ../../pixmaps/system-noindex-logo.png

- inspectez les fichiers de la racine web, et vérifier qu'ils sont bien accessibles en lecture par l'utilisateur qui lance le processus :
[amine@localhost ~]$ ls -l /usr/share/nginx/html
total 12
-rw-r--r--. 1 root root 3332 Oct 16 19:58 404.html
-rw-r--r--. 1 root root 3404 Oct 16 19:58 50x.html
drwxr-xr-x. 2 root root   27 Feb 19 21:46 icons
lrwxrwxrwx. 1 root root   25 Oct 16 20:00 index.html -> ../../testpage/index.html
-rw-r--r--. 1 root root  368 Oct 16 19:58 nginx-logo.png
lrwxrwxrwx. 1 root root   14 Oct 16 20:00 poweredby.png -> nginx-logo.png
lrwxrwxrwx. 1 root root   37 Oct 16 20:00 system_noindex_logo.png -> ../../pixmaps/system-noindex-logo.png
```
4. Visite du service web

🌞 Configurez le firewall pour autoriser le trafic vers le service NGINX
```
[amine@localhost ~]$ sudo firewall-cmd --zone=public --add-port=80/tcp --permanent                  
[sudo] password for amine: 
success
[amine@localhost ~]$ sudo firewall-cmd --reload
success  
```

🌞 Accéder au site web

```
[amine@localhost ~]$ curl http://192.168.1.100

```
🌞 Vérifier les logs d'accès
```
[amine@localhost ~]$ tail -n 3 /var/log/nginx/access.log

```

5. Modif de la conf du serveur web

🌞 Changer le port d'écoute

```
[amine@localhost ~]$ sudo nano /etc/nginx/nginx.conf
(on modifie le 80 par le 8080)
[amine@localhost ~]$ sudo systemctl restart nginx
[amine@localhost ~]$ systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; preset: disabled)
     Active: active (running) since Mon 2024-02-19 22:22:21 CET; 4s ago
    Process: 12667 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
    Process: 12668 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
    Process: 12669 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
   Main PID: 12670 (nginx)
      Tasks: 5 (limit: 23080)
     Memory: 4.7M
        CPU: 25ms
     CGroup: /system.slice/nginx.service
             ├─12670 "nginx: master process /usr/sbin/nginx"
             ├─12671 "nginx: worker process"
             ├─12672 "nginx: worker process"
             ├─12673 "nginx: worker process"
             └─12674 "nginx: worker process"

Feb 19 22:22:21 localhost.localdomain systemd[1]: Starting The nginx HTTP and reverse proxy server...
Feb 19 22:22:21 localhost.localdomain nginx[12668]: nginx: the configuration file /etc/nginx/nginx.conf >
Feb 19 22:22:21 localhost.localdomain nginx[12668]: nginx: configuration file /etc/nginx/nginx.conf test>
Feb 19 22:22:21 localhost.localdomain systemd[1]: Started The nginx HTTP and reverse proxy server.

[amine@localhost ~]$ ss -tuln | grep 8080
tcp   LISTEN 0      511          0.0.0.0:8080      0.0.0.0:*          
tcp   LISTEN 0      511             [::]:8080         [::]:*          
[amine@localhost ~]$ curl http://192.168.100.1:8080


```

🌞 Changer l'utilisateur qui lance le service

```
[amine@localhost ~]$ sudo useradd -m -d /home/web -s /bin/bash web
[sudo] password for amine: 
[amine@localhost ~]$ sudo passwd web*
passwd: Unknown user name 'web*'.
[amine@localhost ~]$ sudo passwd web
Changing password for user web.
New password: 
BAD PASSWORD: The password is shorter than 8 characters
Retype new password: 
Sorry, passwords do not match.
New password: 
Retype new password: 
passwd: all authentication tokens updated successfully.
[amine@localhost ~]$ sudo nano /etc/nginx/nginx.conf
(on remplace le user nginx par user web)
[amine@localhost ~]$ sudo systemctl restart nginx
[amine@localhost ~]$ ps aux | grep nginx
root       12736  0.0  0.0  10112   956 ?        Ss   22:34   0:00 nginx: master process /usr/sbin/nginx
web        12737  0.0  0.1  13912  4940 ?        S    22:34   0:00 nginx: worker process
web        12738  0.0  0.1  13912  4940 ?        S    22:34   0:00 nginx: worker process
web        12739  0.0  0.1  13912  4940 ?        S    22:34   0:00 nginx: worker process
web        12740  0.0  0.1  13912  4940 ?        S    22:34   0:00 nginx: worker process
amine      12742  0.0  0.0   3876  2028 pts/0    S+   22:34   0:00 grep --color=auto nginx

```
🌞 Changer l'emplacement de la racine Web
```
[amine@localhost ~]$ sudo nano /mnt/storage/site_web_1/index.html
[amine@localhost ~]$ sudo nano /etc/nginx/sites-available/default
[amine@localhost ~]$ root /mnt/storage/site_web_1/;
[amine@localhost ~]$  sudo systemctl restart nginx
[amine@localhost ~]$ curl http:10.3.1.11:8080


```
6. Deux sites web sur un seul serveur

🌞 Repérez dans le fichier de conf
```
[amine@localhost ~]$ grep -R "include.*conf.d" /etc/nginx/nginx.conf
    include /etc/nginx/conf.d/*.conf;

```
🌞 Créez le fichier de configuration pour le premier site

```
[amine@localhost ~]$ echo "
server {
    listen 80;
    server_name site_web_1.com;

    root /var/www/site_web_1;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
" | sudo tee /etc/nginx/conf.d/site_web_1.conf

server {
    listen 80;
    server_name site_web_1.com;

    root /var/www/site_web_1;
    index index.html;

    location / {
        try_files  / =404;
    }
}

```
🌞 Créez le fichier de configuration pour le deuxième site
```
[amine@localhost ~]$ echo "
server {
    listen 8888;
    server_name site_web_2.com;

    root /var/www/site_web_2;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
" | sudo tee /etc/nginx/conf.d/site_web_2.conf

server {
    listen 8888;
    server_name site_web_2.com;

    root /var/www/site_web_2;
    index index.html;

    location / {
        try_files  / =404;
    }
}

```
🌞 Prouvez que les deux sites sont disponibles
```

```
