TP1 : Casser avant de construire
2. Fichier
🌞 Supprimer des fichiers
``````
[amine@localhost ~]$ cd /var
[amine@localhost var]$ ls
adm    crash  empty  games     lib    lock  mail  opt       run    tmp
cache  db     ftp    kerberos  local  log   nis   preserve  spool  yp
[amine@localhost var]$ cd tmp
[amine@localhost tmp]$ cd ..
[amine@localhost var]$ sudo rm -r tmp
[sudo] password for amine:
[amine@localhost var]$ sudo reboot
[amine@localhost var]$ Connection to 10.3.1.11 closed by remote host.
Connection to 10.3.1.11 closed.
```````

3. Utilisateurs
🌞 Mots de passe
``````
[amine@localhost ~]$ cd /var
[amine@localhost var]$ ls
adm  cache  crash  db  empty  ftp  games  kerberos  lib  local  lock  log  mail  nis  opt  preserve  run  spool  tmp  yp
[amine@localhost var]$ sudo rm /etc/shadow
[sudo] password for amine:
[amine@localhost var]$ sudo reboot
sudo: PAM account management error: Authentication service cannot retrieve authentication info
sudo: a password is required
[amine@localhost var]$
``````
- trouvez donc un moyen de lister les utilisateurs, et trouver ceux qui ont déjà un mot de passe

```
[root@localhost var]# cat /etc/shadow
root:$6$6F3DhRG7zYil4.q2$WYGqkoLuGQOXWB4z9VDCehjQu4btqVXAkKQGBizx.t89KuLwLATuAWeBriOvcVk2SPS5GQa9MVhlGifKQm6yq/::0:99999:7:::
bin:*:19469:0:99999:7:::
daemon:*:19469:0:99999:7:::
adm:*:19469:0:99999:7:::
lp:*:19469:0:99999:7:::
sync:*:19469:0:99999:7:::
shutdown:*:19469:0:99999:7:::
halt:*:19469:0:99999:7:::
mail:*:19469:0:99999:7:::
operator:*:19469:0:99999:7:::
games:*:19469:0:99999:7:::
ftp:*:19469:0:99999:7:::
nobody:*:19469:0:99999:7:::
systemd-coredump:!!:19653::::::
dbus:!!:19653::::::
tss:!!:19653::::::
sssd:!!:19653::::::
sshd:!!:19653::::::
chrony:!!:19653::::::
systemd-oom:!*:19653::::::
amine:$6$xLrijJdXIlnYX3NO$ylb471lXbrgDiFDjImduEqYmr8/BH9rKNLxWb2LeLexh5QcS6CIH2QVLXMKRMFEiARf.FHxQC7GraEFKhxGkr/::0:99999:7:::
tcpdump:!!:19653::::::
```

4. Disques
- 🌞 Effacer le contenu du disque dur
``````
[amine@localhost ~]$ sudo dd if=/dev/zero of=/dev/sda bs=4M status=progress
[sudo] password for amine:
Sorry, try again.
[sudo] password for amine:
8011120640 bytes (8.0 GB, 7.5 GiB) copied, 10 s, 801 MB/s
8602517504 bytes (8.6 GB, 8.0 GiB) copied, 11 s, 782 MB/s
9579790336 bytes (9.6 GB, 8.9 GiB) copied, 12 s, 798 MB/s
21248344064 bytes (21 GB, 20 GiB) copied, 25 s, 850 MB/s
dd: error writing '/dev/sda': No space left on device
5121+0 records in2
5120+0 records out
21474836480 bytes (21 GB, 20 GiB) copied, 25.2349 s, 851 MB/s
``````

5. Malware
🌞 Reboot automatique

- faites en sorte que si un utilisateur se connecte, ça déclenche un reboot automatique de la machine

``````
touch lol.sh

nano lol.sh:
 sudo shutdown -r now
chmod +x lol.sh

sudo EDITOR=nano crontab -e:
  @reboot /root/lol.sh

sudo reboot
``````
6. You own way
🌞 Trouvez 4 autres façons de détuire la machine

- On va créer un fichier bash contenant une fork bomb en le plaçant dans le dossier profile.d qui l’exécutera ensuite à chaque connexion de l’utilisateur.

``````
cd /etc/profile.d/

touch lol.sh

nano lol.sh:
   :(){:|:&};:
chmod +x lol.sh

``````
- en créant un emplacement dans le système, nous pouvons déplacer les données utiles vers un trou noir, cela revient à les détruire 
``````
mv ~ /dev/null
```````
- Effacer les fichier par un nouveau système de fichiers, donc les formater
``````
mkfs.ext4 /dev/sda1
``````
- tout supprimer
``````
rm -rf /
``````