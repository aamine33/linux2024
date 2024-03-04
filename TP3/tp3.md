TP 3

Partie 1 : service SSH

I. Service SSH

1. Analyse du service

🌞 S'assurer que le service sshd est démarré

``````
- avec une commande systemctl status
[amine@localhost ~]$ systemctl status
● localhost.localdomain
    State: running
    Units: 276 loaded (incl. loaded aliases)
     Jobs: 0 queued
   Failed: 0 units
    Since: Mon 2024-01-29 09:59:22 CET; 6min ago
  systemd: 252-18.el9
   CGroup: /
           ├─init.scope
           │ └─1 /usr/lib/systemd/systemd --switched-root --system --deserializ>
           ├─system.slice
           │ ├─NetworkManager.service
           │ │ └─692 /usr/sbin/NetworkManager --no-daemon
           │ ├─auditd.service
           │ │ └─658 /sbin/auditd
           │ ├─chronyd.service
           │ │ └─688 /usr/sbin/chronyd -F 2
           │ ├─crond.service
           │ │ └─735 /usr/sbin/crond -n
           │ ├─dbus-broker.service
           │ │ ├─679 /usr/bin/dbus-broker-launch --scope system --audit
           │ │ └─680 dbus-broker --log 4 --controller 9 --machine-id d9841ed5cd>
           │ ├─firewalld.service
           │ │ └─683 /usr/bin/python3 -s /usr/sbin/firewalld --nofork --nopid
           │ ├─irqbalance.service
           │ │ └─684 /usr/sbin/irqbalance --foreground
           │ ├─rsyslog.service
           │ │ └─796 /usr/sbin/rsyslogd -n
           │ ├─sshd.service
           │ │ └─722 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"
           │ ├─systemd-journald.service
           │ │ └─564 /usr/lib/systemd/systemd-journald
           │ ├─systemd-logind.service
           │ │ └─686 /usr/lib/systemd/systemd-logind
           │ └─systemd-udevd.service
           │   └─udev
(la liste s'étend sur encore plusieurs ligne en continuant l'exécution)
``````
🌞 Analyser les processus liés au service SSH
``````
- afficher les processus liés au service sshd
[amine@localhost ~]$ ps aux | grep sshd
root         722  0.0  0.2  15844  9156 ?        Ss   09:59   0:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root        1287  0.0  0.3  18992 11528 ?        Ss   10:00   0:00 sshd: amine [priv]
amine       1291  0.0  0.1  18992  7220 ?        S    10:00   0:00 sshd: amine@pts/0
amine       1566  0.0  0.0   3876  2028 pts/0    S+   10:24   0:00 grep --color=auto sshd
``````
🌞 Déterminer le port sur lequel écoute le service SSH
``````
[amine@localhost ~]$ systemctl status sshd
● sshd.service - OpenSSH server daemon
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; preset: ena>
     Active: active (running) since Mon 2024-01-29 09:59:24 CET; 29min ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 722 (sshd)
      Tasks: 1 (limit: 23080)
     Memory: 5.0M
        CPU: 281ms
     CGroup: /system.slice/sshd.service
             └─722 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"

[amine@localhost ~]$ ss -tnlp
State    Recv-Q   Send-Q     Local Address:Port     Peer Address:Port  Process  
LISTEN   0        128              0.0.0.0:22            0.0.0.0:*              
LISTEN   0        128                 [::]:22               [::]:*              
[amine@localhost ~]$ ss -tnlp | grep :22
LISTEN 0      128          0.0.0.0:22        0.0.0.0:*          
LISTEN 0      128             [::]:22           [::]:*          
``````
🌞 Consulter les logs du service SSH
``````
- les logs du service sont consultables avec une commande journalctl :

[amine@localhost ~]$ journalctl -u sshd
Jan 30 09:02:35 localhost.localdomain systemd[1]: Starting OpenSSH server daemon...
Jan 30 09:02:35 localhost.localdomain sshd[688]: Server listening on 0.0.0.0 port 22.
Jan 30 09:02:35 localhost.localdomain sshd[688]: Server listening on :: port 22.
Jan 30 09:02:35 localhost.localdomain systemd[1]: Started OpenSSH server daemon.
Jan 30 10:12:24 localhost.localdomain sshd[1498]: Invalid user batman33 from 10.3.1.1 port 49712
Jan 30 10:12:25 localhost.localdomain sshd[1498]: Connection closed by invalid user batman33 10.3.>
Jan 30 10:35:12 localhost.localdomain sshd[1535]: Invalid user batman33 from 10.3.1.1 port 46558
Jan 30 10:35:15 localhost.localdomain sshd[1535]: Connection closed by invalid user batman33 10.3.>
Jan 30 10:35:26 localhost.localdomain sshd[1537]: Accepted password for amine from 10.3.1.1 port 5>
Jan 30 10:35:26 localhost.localdomain sshd[1537]: pam_unix(sshd:session): session opened for user >

- il existe un fichier de log, dans lequel le service SSH enregistre toutes les tentatives de connexion

[amine@localhost ~]$ cat /var/log/secure
cat: /var/log/secure: Permission denied
[amine@localhost ~]$ sudo cat /var/log/secure
Jan 29 20:49:18 localhost sshd[1282]: Server listening on 0.0.0.0 port 22.
Jan 29 20:49:18 localhost sshd[1282]: Server listening on :: port 22.
Jan 29 20:54:17 localhost systemd[4213]: pam_unix(systemd-user:session): session opened for user amine(uid=1000) by (uid=0)
Jan 29 20:54:17 localhost login[716]: pam_unix(login:session): session opened for user amine(uid=1000) by LOGIN(uid=0)
Jan 29 20:54:17 localhost login[716]: LOGIN ON tty1 BY amine
Jan 29 20:59:59 localhost sudo[4294]:   amine : TTY=tty1 ; PWD=/etc/sysconfig/network-scripts ; USER=root ; COMMAND=/bin/dnf update -y
Jan 29 20:59:59 localhost sudo[4294]: pam_unix(sudo:session): session opened for user root(uid=0) by amine(uid=1000)
Jan 29 21:06:54 localhost sudo[4294]: pam_unix(sudo:session): session closed for user root
Jan 29 21:07:16 localhost sudo[44859]:   amine : TTY=tty1 ; PWD=/etc/sysconfig/network-scripts ; USER=root ; COMMAND=/bin/dnf install nano -y
Jan 29 21:07:16 localhost sudo[44859]: pam_unix(sudo:session): session opened for user root(uid=0) by amine(uid=1000)
Jan 29 21:07:19 localhost sudo[44859]: pam_unix(sudo:session): session closed for user root
Jan 29 21:07:44 localhost sudo[44985]:   amine : TTY=tty1 ; PWD=/etc/sysconfig/network-scripts ; USER=root ; COMMAND=/bin/nano readme-ifcfg-rh.txt
Jan 29 21:07:44 localhost sudo[44985]: pam_unix(sudo:session): session opened for user root(uid=0) by amine(uid=1000)
Jan 29 21:07:54 localhost sudo[44985]: pam_unix(sudo:session): session closed for user root
Jan 29 21:09:00 localhost sudo[44993]:   amine : TTY=tty1 ; PWD=/etc/sysconfig/network-scripts ; USER=root ; COMMAND=/bin/nano ifcfg-enp0s9
Jan 29 21:09:00 localhost sudo[44993]: pam_unix(sudo:session): session opened for user root(uid=0) by amine(uid=1000)
Jan 29 21:09:08 localhost sudo[44993]: pam_unix(sudo:session): session closed for user root
Jan 29 21:09:12 localhost sudo[44997]:   amine : TTY=tty1 ; PWD=/etc/sysconfig/network-scripts ; USER=root ; COMMAND=/bin/nano ifcfg-enp0s8
Jan 29 21:09:12 localhost sudo[44997]: pam_unix(sudo:session): session opened for user root(uid=0) by amine(uid=1000)
Jan 29 21:23:12 localhost sudo[44997]: pam_unix(sudo:session): session closed for user root
Jan 29 21:24:25 localhost unix_chkpwd[45036]: password check failed for user (amine)
Jan 29 21:24:25 localhost sudo[45034]: pam_unix(sudo:auth): authentication failure; logname=amine uid=1000 euid=0 tty=/dev/tty1 ruser=amine rhost=  user=amine
Jan 29 21:25:06 localhost unix_chkpwd[45040]: password check failed for user (amine)
Jan 29 21:25:10 localhost sudo[45034]: pam_unix(sudo:auth): conversation failed
Jan 29 21:25:10 localhost sudo[45034]: pam_unix(sudo:auth): auth could not identify password for [amine]
Jan 29 21:25:10 localhost sudo[45034]:   amine : 2 incorrect password attempts ; TTY=tty1 ; PWD=/etc/sysconfig/network-scripts ; USER=root ; COMMAND=/bin/systemctl restart
Jan 29 21:25:25 localhost sudo[45044]:   amine : TTY=tty1 ; PWD=/etc/sysconfig/network-scripts ; USER=root ; COMMAND=/bin/systemctl restart NetworkManager
Jan 29 21:25:25 localhost sudo[45044]: pam_unix(sudo:session): session opened for user root(uid=0) by amine(uid=1000)
Jan 29 21:25:26 localhost sudo[45044]: pam_unix(sudo:session): session closed for user root
Jan 29 21:26:55 localhost sudo[45108]:   amine : TTY=tty1 ; PWD=/etc/sysconfig/network-scripts ; USER=root ; COMMAND=/bin/nmcli con reload
Jan 29 21:26:55 localhost sudo[45108]: pam_unix(sudo:session): session opened for user root(uid=0) by amine(uid=1000)
Jan 29 21:26:55 localhost sudo[45108]: pam_unix(sudo:session): session closed for user root
Jan 29 21:27:24 localhost sudo[45115]:   amine : TTY=tty1 ; PWD=/etc/sysconfig/network-scripts ; USER=root ; COMMAND=/bin/nmcli con up System enp0s8
Jan 29 21:27:24 localhost sudo[45115]: pam_unix(sudo:session): session opened for user root(uid=0) by amine(uid=1000)
Jan 29 21:27:24 localhost sudo[45115]: pam_unix(sudo:session): session closed for user root
Jan 29 21:28:12 localhost sudo[45122]:   amine : TTY=tty1 ; PWD=/etc/sysconfig/network-scripts ; USER=root ; COMMAND=/bin/systemctl restart NetworkManager
Jan 29 21:28:12 localhost sudo[45122]: pam_unix(sudo:session): session opened for user root(uid=0) by amine(uid=1000)
Jan 29 21:28:13 localhost sudo[45122]: pam_unix(sudo:session): session closed for user root
Jan 29 21:39:57 localhost sshd[688]: Server listening on 0.0.0.0 port 22.
Jan 29 21:39:57 localhost sshd[688]: Server listening on :: port 22.
Jan 29 21:40:38 localhost login[697]: pam_unix(login:auth): check pass; user unknown
Jan 29 21:40:38 localhost login[697]: pam_unix(login:auth): authentication failure; logname=LOGIN uid=0 euid=0 tty=/dev/tty1 ruser= rhost=
Jan 29 21:40:40 localhost login[697]: FAILED LOGIN 1 FROM tty1 FOR amine , Authentication failure
Jan 29 21:40:46 localhost systemd[4149]: pam_unix(systemd-user:session): session opened for user amine(uid=1000) by (uid=0)
Jan 29 21:40:46 localhost login[697]: pam_unix(login:session): session opened for user amine(uid=1000) by LOGIN(uid=0)
Jan 29 21:40:46 localhost login[697]: LOGIN ON tty1 BY amine
Jan 29 22:10:23 localhost sshd[688]: Server listening on 0.0.0.0 port 22.
Jan 29 22:10:23 localhost sshd[688]: Server listening on :: port 22.
Jan 29 22:10:50 localhost systemd[1205]: pam_unix(systemd-user:session): session opened for user amine(uid=1000) by (uid=0)
Jan 29 22:10:50 localhost login[700]: pam_unix(login:session): session opened for user amine(uid=1000) by LOGIN(uid=0)
Jan 29 22:10:50 localhost login[700]: LOGIN ON tty1 BY amine
Jan 29 22:10:58 localhost sudo[1240]:   amine : TTY=tty1 ; PWD=/home/amine ; USER=root ; COMMAND=/bin/dnf install
Jan 29 22:10:58 localhost sudo[1240]: pam_unix(sudo:session): session opened for user root(uid=0) by amine(uid=1000)
Jan 29 22:10:59 localhost sudo[1240]: pam_unix(sudo:session): session closed for user root
Jan 30 09:02:35 localhost sshd[688]: Server listening on 0.0.0.0 port 22.
Jan 30 09:02:35 localhost sshd[688]: Server listening on :: port 22.
Jan 30 09:02:43 localhost unix_chkpwd[1203]: password check failed for user (amine)
Jan 30 09:02:43 localhost login[700]: pam_unix(login:auth): authentication failure; logname=LOGIN uid=0 euid=0 tty=/dev/tty1 ruser= rhost=  user=amine
Jan 30 09:02:45 localhost login[700]: FAILED LOGIN 1 FROM tty1 FOR amine, Authentication failure
Jan 30 09:02:48 localhost systemd[1208]: pam_unix(systemd-user:session): session opened for user amine(uid=1000) by (uid=0)
Jan 30 09:02:49 localhost login[700]: pam_unix(login:session): session opened for user amine(uid=1000) by LOGIN(uid=0)
Jan 30 09:02:49 localhost login[700]: LOGIN ON tty1 BY amine
Jan 30 10:12:24 localhost sshd[1498]: Invalid user batman33 from 10.3.1.1 port 49712
Jan 30 10:12:25 localhost sshd[1498]: Connection closed by invalid user batman33 10.3.1.1 port 49712 [preauth]
Jan 30 10:35:12 localhost sshd[1535]: Invalid user batman33 from 10.3.1.1 port 46558
Jan 30 10:35:15 localhost sshd[1535]: Connection closed by invalid user batman33 10.3.1.1 port 46558 [preauth]
Jan 30 10:35:26 localhost sshd[1537]: Accepted password for amine from 10.3.1.1 port 51352 ssh2
Jan 30 10:35:26 localhost sshd[1537]: pam_unix(sshd:session): session opened for user amine(uid=1000) by (uid=0)
Jan 30 10:39:59 localhost sudo[1570]:   amine : TTY=pts/0 ; PWD=/home/amine ; USER=root ; COMMAND=/bin/cat /var/log.auth.log
Jan 30 10:39:59 localhost sudo[1570]: pam_unix(sudo:session): session opened for user root(uid=0) by amine(uid=1000)
Jan 30 10:39:59 localhost sudo[1570]: pam_unix(sudo:session): session closed for user root
Jan 30 10:40:15 localhost sudo[1575]:   amine : TTY=pts/0 ; PWD=/home/amine ; USER=root ; COMMAND=/bin/cat /var/log/auth.log
Jan 30 10:40:15 localhost sudo[1575]: pam_unix(sudo:session): session opened for user root(uid=0) by amine(uid=1000)
Jan 30 10:40:15 localhost sudo[1575]: pam_unix(sudo:session): session closed for user root
Jan 30 10:40:42 localhost sudo[1578]:   amine : TTY=pts/0 ; PWD=/home/amine ; USER=root ; COMMAND=/bin/less /var/log/auth.log
Jan 30 10:40:42 localhost sudo[1578]: pam_unix(sudo:session): session opened for user root(uid=0) by amine(uid=1000)
Jan 30 10:40:42 localhost sudo[1578]: pam_unix(sudo:session): session closed for user root
Jan 30 10:41:02 localhost sudo[1584]:   amine : TTY=pts/0 ; PWD=/home/amine ; USER=root ; COMMAND=/bin/cat /var/log/auth.log
Jan 30 10:41:02 localhost sudo[1584]: pam_unix(sudo:session): session opened for user root(uid=0) by amine(uid=1000)
Jan 30 10:41:02 localhost sudo[1584]: pam_unix(sudo:session): session closed for user root
Jan 30 10:44:02 localhost sudo[1589]:   amine : TTY=pts/0 ; PWD=/home/amine ; USER=root ; COMMAND=/bin/less /var/log/auth.log
Jan 30 10:44:02 localhost sudo[1589]: pam_unix(sudo:session): session opened for user root(uid=0) by amine(uid=1000)
Jan 30 10:44:02 localhost sudo[1589]: pam_unix(sudo:session): session closed for user root

``````
2. Modification du service

🌞 Identifier le fichier de configuration du serveur SSH
``````
[amine@localhost ~]$ sudo cat /etc/ssh/sshd_config
#	$OpenBSD: sshd_config,v 1.104 2021/07/02 05:11:21 dtucker Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

# To modify the system-wide sshd configuration, create a  *.conf  file under
#  /etc/ssh/sshd_config.d/  which will be automatically included below
Include /etc/ssh/sshd_config.d/*.conf

# If you want to change the port on a SELinux system, you have to tell
# SELinux about this change.
# semanage port -a -t ssh_port_t -p tcp #PORTNUMBER
#
#Port 22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

#HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_ecdsa_key
#HostKey /etc/ssh/ssh_host_ed25519_key

# Ciphers and keying
#RekeyLimit default none

# Logging
#SyslogFacility AUTH
#LogLevel INFO

# Authentication:

#LoginGraceTime 2m
#PermitRootLogin prohibit-password
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10

#PubkeyAuthentication yes

# The default is to check both .ssh/authorized_keys and .ssh/authorized_keys2
# but this is overridden so installations will only check .ssh/authorized_keys
AuthorizedKeysFile	.ssh/authorized_keys

#AuthorizedPrincipalsFile none

#AuthorizedKeysCommand none
#AuthorizedKeysCommandUser nobody

# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes

# To disable tunneled clear text passwords, change to no here!
#PasswordAuthentication yes
#PermitEmptyPasswords no

# Change to no to disable s/key passwords
#KbdInteractiveAuthentication yes

# Kerberos options
#KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no
#KerberosUseKuserok yes

# GSSAPI options
#GSSAPIAuthentication no
#GSSAPICleanupCredentials yes
#GSSAPIStrictAcceptorCheck yes
#GSSAPIKeyExchange no
#GSSAPIEnablek5users no

# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the KbdInteractiveAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via KbdInteractiveAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and KbdInteractiveAuthentication to 'no'.
# WARNING: 'UsePAM no' is not supported in RHEL and may cause several
# problems.
#UsePAM no

#AllowAgentForwarding yes
#AllowTcpForwarding yes
#GatewayPorts no
#X11Forwarding no
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
#PrintMotd yes
#PrintLastLog yes
#TCPKeepAlive yes
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#UseDNS no
#PidFile /var/run/sshd.pid
#MaxStartups 10:30:100
#PermitTunnel no
#ChrootDirectory none
#VersionAddendum none

# no default banner path
#Banner none

# override default of no subsystems
Subsystem	sftp	/usr/libexec/openssh/sftp-server

# Example of overriding settings on a per-user basis
#Match User anoncvs
#	X11Forwarding no
#	AllowTcpForwarding no
#	PermitTTY no
#	ForceCommand cvs server


[amine@localhost ~]$ sudo nano /etc/ssh/sshd_config
(je pense pas nécessaire de copier coller le contenu...)

[amine@localhost ~]$ sudo find / -name sshd_config 2>/dev/null
/etc/ssh/sshd_config

``````
🌞 Modifier le fichier de conf
``````
- exécutez un echo $RANDOM pour demander à votre shell de vous fournir un nombre aléatoire

[amine@localhost ~]$ echo $((RANDOM % 65535 + 1))
30575


- changez le port d'écoute du serveur SSH pour qu'il écoute sur ce numéro de port
il faut modifier le fichier avec nano ou vim par exemple
dans le compte-rendu je veux un cat du fichier de conf
filtré par un | grep pour mettre en évidence la ligne que vous avez modifié

[amine@localhost ~]$sudo nano /etc/ssh/sshd_config
on tape cette commande pour trouver le Port 22 et le Port 12345 pour vérifier.

[amine@localhost ~]$ sudo cat /etc/ssh/sshd_config | grep Port
#Port 22
#GatewayPorts no

[amine@localhost ~]$ sudo systemctl restart sshd

- gérer le firewall, fermer l'ancien port
ouvrir le nouveau port
vérifier avec un firewall-cmd --list-all que le port est bien ouvert
vous filtrerez la sortie de la commande avec un | grep TEXTE

[amine@localhost ~]$ sudo firewall-cmd --remove-port=22/tcp --permanent
Warning: NOT_ENABLED: 22:tcp
success

[amine@localhost ~]$ sudo firewall-cmd --add-port=NouveauPort/tcp --permanent
Error: INVALID_PORT: NouveauPort

[amine@localhost ~]$ sudo firewall-cmd --reload
success


[amine@localhost ~]$ sudo firewall-cmd --list-all | grep "NouveauPort"

``````
🌞 Redémarrer le service
``````
[amine@localhost ~]$ sudo systemctl restart firewalld 
``````
🌞 Effectuer une connexion SSH sur le nouveau port
``````
[amine@localhost ~]$ ssh -p 12345 amine@10.3.1.11

``````
✨ Bonus : affiner la conf du serveur SSH
``````
[amine@localhost ~]$ ssh-keygen -t rsa -b 4096
Generating public/private rsa key pair.
Enter file in which to save the key (/home/amine/.ssh/id_rsa): amine1818@
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in amine1818@
Your public key has been saved in amine1818@.pub
The key fingerprint is:
SHA256:6RepqcQbCp2QWkaEQLVpZ6HGVQ1Zk7uTmmMe+9fNtXg amine@localhost.localdomain
The key's randomart image is:
+---[RSA 4096]----+
|+oo. o.o=o.      |
|... = .. o.      |
|  .B o    .      |
| .o.o    o .     |
|  =     S =      |
| + o o . * .    .|
|. . o +.* o . + o|
|   . o Oo. . o E |
|    . =oo..   .  |
+----[SHA256]-----+
[amine@localhost ~]$ sudo nano /etc/ssh/sshd_config
PermitRootLogin no
AllowUsers amine
Ciphers aes256-ctr
MACs hmac-sha2-512
KexAlgorithms ecdh-sha2-nistp521
LogLevel VERBOSE

[amine@localhost ~]$ sudo systemctl restart sshd

``````
Partie 2 : service Web

1. Mise en place
🌞 Installer le serveur NGINX
``````
[amine@localhost ~]$ sudo yum install nginx

``````
🌞 Démarrer le service NGINX
``````
[amine@localhost ~]$ sudo systemctl start nginx
[amine@localhost ~]$ sudo systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; preset: disabled)
     Active: active (running) since Tue 2024-01-30 11:30:08 CET; 2min 35s ago
    Process: 2072 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
    Process: 2073 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
    Process: 2074 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
   Main PID: 2075 (nginx)
      Tasks: 2 (limit: 23098)
     Memory: 1.9M
        CPU: 28ms
     CGroup: /system.slice/nginx.service
             ├─2075 "nginx: master process /usr/sbin/nginx"
             └─2076 "nginx: worker process"

Jan 30 11:30:08 localhost.localdomain systemd[1]: Starting The nginx HTTP and reverse proxy server.>
Jan 30 11:30:08 localhost.localdomain nginx[2073]: nginx: the configuration file /etc/nginx/nginx.c>
Jan 30 11:30:08 localhost.localdomain nginx[2073]: nginx: configuration file /etc/nginx/nginx.conf >
Jan 30 11:30:08 localhost.localdomain systemd[1]: Started The nginx HTTP and reverse proxy server.
``````

🌞 Déterminer sur quel port tourne NGINX
``````
[amine@localhost ~]$ ss -tnlp | grep nginx

[amine@localhost ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success

[amine@localhost ~]$ sudo firewall-cmd --reload
success

``````
🌞 Déterminer les processus liés au service NGINX
``````
- vous devez filtrer la sortie de la commande utilisée pour n'afficher que les lignes demandées

[amine@localhost ~]$ ps aux | grep nginx
root        2075  0.0  0.0  10112   956 ?        Ss   11:30   0:00 nginx: master process /usr/sbin/nginx
nginx       2076  0.0  0.1  13912  4928 ?        S    11:30   0:00 nginx: worker process
amine       2098  0.0  0.0   3876  2008 pts/0    S+   11:34   0:00 grep --color=auto nginx

``````

🌞 Déterminer le nom de l'utilisateur qui lance NGINX
``````
[amine@localhost ~]$ cat /etc/passwd | grep amine
amine:x:1000:1000:amine:/home/amine:/bin/bash

``````
🌞 Test !

``````
[amine@localhost ~]$ curl http://10.3.1.11:80 | head -n 7
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
100  7620  100  7620    0     0   531k      0 --:--:-- --:--:-- --:--:--  531k
curl: (23) Failed writing body
``````
2. Analyser la conf de NGINX


🌞 Déterminer le path du fichier de configuration de NGINX

````
[amine@localhost ~]$ ls -al /etc/nginx/nginx.conf
-rw-r--r--. 1 root root 2334 Oct 16 20:00 /etc/nginx/nginx.conf


````
🌞 Trouver dans le fichier de conf

``````
[amine@localhost ~]$ cat /etc/nginx/nginx.conf | grep "server {" -A 10
    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
--
#    server {
#        listen       443 ssl http2;
#        listen       [::]:443 ssl http2;
#        server_name  _;
#        root         /usr/share/nginx/html;
#
#        ssl_certificate "/etc/pki/nginx/server.crt";
#        ssl_certificate_key "/etc/pki/nginx/private/server.key";
#        ssl_session_cache shared:SSL:1m;
#        ssl_session_timeout  10m;
#        ssl_ciphers PROFILE=SYSTEM;

[amine@localhost ~]$ cat /etc/nginx/nginx.conf | grep "^include "
include /usr/share/nginx/modules/*.conf;

``````

3. Déployer un nouveau site web
🌞 Créer un site web

`````
[amine@localhost ~]$ sudo mkdir /var/tp2_linux

[amine@localhost ~]$ echo "<h1>MEOW mon premier serveur web</h1>" | sudo tee /var/tp2_linux/index.html
<h1>MEOW mon premier serveur web</h1>

`````
🌞 Gérer les permissions
```
[amine@localhost ~]$ sudo chown -R nginx:nginx /var/tp2_linux

```

🌞 Adapter la conf NGINX
```
[amine@localhost ~]$ sudo nano /etc/nginx/nginx.conf
on supprime dans le nano le coté serveur
[amine@localhost ~]$ sudo systemctl restart nginx

[amine@localhost ~]$ echo "server {
  listen <PORT>;
  root /var/tp2_linux;
}" | sudo tee /etc/nginx/conf.d/tp2_linux.conf
server {
  listen <PORT>;
  root /var/tp2_linux;
}


```

🌞 Visitez votre super site web

```
[amine@localhost ~]$ curl http://10.3.1.11:80
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
      /*<![CDATA[*/
      
      html {
        height: 100%;
        width: 100%;
      }  
        body {
  background: rgb(20,72,50);
  background: -moz-linear-gradient(180deg, rgba(23,43,70,1) 30%, rgba(0,0,0,1) 90%)  ;
  background: -webkit-linear-gradient(180deg, rgba(23,43,70,1) 30%, rgba(0,0,0,1) 90%) ;
  background: linear-gradient(180deg, rgba(23,43,70,1) 30%, rgba(0,0,0,1) 90%);
  background-repeat: no-repeat;
  background-attachment: fixed;
  filter: progid:DXImageTransform.Microsoft.gradient(startColorstr="#3c6eb4",endColorstr="#3c95b4",GradientType=1); 
        color: white;
        font-size: 0.9em;
        font-weight: 400;
        font-family: 'Montserrat', sans-serif;
        margin: 0;
        padding: 10em 6em 10em 6em;
        box-sizing: border-box;      
        
      }

   
  h1 {
    text-align: center;
    margin: 0;
    padding: 0.6em 2em 0.4em;
    color: #fff;
    font-weight: bold;
    font-family: 'Montserrat', sans-serif;
    font-size: 2em;
  }
  h1 strong {
    font-weight: bolder;
    font-family: 'Montserrat', sans-serif;
  }
  h2 {
    font-size: 1.5em;
    font-weight:bold;
  }
  
  .title {
    border: 1px solid black;
    font-weight: bold;
    position: relative;
    float: right;
    width: 150px;
    text-align: center;
    padding: 10px 0 10px 0;
    margin-top: 0;
  }
  
  .description {
    padding: 45px 10px 5px 10px;
    clear: right;
    padding: 15px;
  }
  
  .section {
    padding-left: 3%;
   margin-bottom: 10px;
  }
  
  img {
  
    padding: 2px;
    margin: 2px;
  }
  a:hover img {
    padding: 2px;
    margin: 2px;
  }

  :link {
    color: rgb(199, 252, 77);
    text-shadow:
  }
  :visited {
    color: rgb(122, 206, 255);
  }
  a:hover {
    color: rgb(16, 44, 122);
  }
  .row {
    width: 100%;
    padding: 0 10px 0 10px;
  }
  
  footer {
    padding-top: 6em;
    margin-bottom: 6em;
    text-align: center;
    font-size: xx-small;
    overflow:hidden;
    clear: both;
  }
 
  .summary {
    font-size: 140%;
    text-align: center;
  }

  #rocky-poweredby img {
    margin-left: -10px;
  }

  #logos img {
    vertical-align: top;
  }
  
  /* Desktop  View Options */
 
  @media (min-width: 768px)  {
  
    body {
      padding: 10em 20% !important;
    }
    
    .col-md-1, .col-md-2, .col-md-3, .col-md-4, .col-md-5, .col-md-6,
    .col-md-7, .col-md-8, .col-md-9, .col-md-10, .col-md-11, .col-md-12 {
      float: left;
    }
  
    .col-md-1 {
      width: 8.33%;
    }
    .col-md-2 {
      width: 16.66%;
    }
    .col-md-3 {
      width: 25%;
    }
    .col-md-4 {
      width: 33%;
    }
    .col-md-5 {
      width: 41.66%;
    }
    .col-md-6 {
      border-left:3px ;
      width: 50%;
      

    }
    .col-md-7 {
      width: 58.33%;
    }
    .col-md-8 {
      width: 66.66%;
    }
    .col-md-9 {
      width: 74.99%;
    }
    .col-md-10 {
      width: 83.33%;
    }
    .col-md-11 {
      width: 91.66%;
    }
    .col-md-12 {
      width: 100%;
    }
  }
  
  /* Mobile View Options */
  @media (max-width: 767px) {
    .col-sm-1, .col-sm-2, .col-sm-3, .col-sm-4, .col-sm-5, .col-sm-6,
    .col-sm-7, .col-sm-8, .col-sm-9, .col-sm-10, .col-sm-11, .col-sm-12 {
      float: left;
    }
  
    .col-sm-1 {
      width: 8.33%;
    }
    .col-sm-2 {
      width: 16.66%;
    }
    .col-sm-3 {
      width: 25%;
    }
    .col-sm-4 {
      width: 33%;
    }
    .col-sm-5 {
      width: 41.66%;
    }
    .col-sm-6 {
      width: 50%;
    }
    .col-sm-7 {
      width: 58.33%;
    }
    .col-sm-8 {
      width: 66.66%;
    }
    .col-sm-9 {
      width: 74.99%;
    }
    .col-sm-10 {
      width: 83.33%;
    }
    .col-sm-11 {
      width: 91.66%;
    }
    .col-sm-12 {
      width: 100%;
    }
    h1 {
      padding: 0 !important;
    }
  }
        
  
  </style>
  </head>
  <body>
    <h1>HTTP Server <strong>Test Page</strong></h1>

    <div class='row'>
    
      <div class='col-sm-12 col-md-6 col-md-6 '></div>
          <p class="summary">This page is used to test the proper operation of
            an HTTP server after it has been installed on a Rocky Linux system.
            If you can read this page, it means that the software is working
            correctly.</p>
      </div>
      
      <div class='col-sm-12 col-md-6 col-md-6 col-md-offset-12'>
     
       
        <div class='section'>
          <h2>Just visiting?</h2>

          <p>This website you are visiting is either experiencing problems or
          could be going through maintenance.</p>

          <p>If you would like the let the administrators of this website know
          that you've seen this page instead of the page you've expected, you
          should send them an email. In general, mail sent to the name
          "webmaster" and directed to the website's domain should reach the
          appropriate person.</p>

          <p>The most common email address to send to is:
          <strong>"webmaster@example.com"</strong></p>
    
          <h2>Note:</h2>
          <p>The Rocky Linux distribution is a stable and reproduceable platform
          based on the sources of Red Hat Enterprise Linux (RHEL). With this in
          mind, please understand that:

        <ul>
          <li>Neither the <strong>Rocky Linux Project</strong> nor the
          <strong>Rocky Enterprise Software Foundation</strong> have anything to
          do with this website or its content.</li>
          <li>The Rocky Linux Project nor the <strong>RESF</strong> have
          "hacked" this webserver: This test page is included with the
          distribution.</li>
        </ul>
        <p>For more information about Rocky Linux, please visit the
          <a href="https://rockylinux.org/"><strong>Rocky Linux
          website</strong></a>.
        </p>
        </div>
      </div>
      <div class='col-sm-12 col-md-6 col-md-6 col-md-offset-12'>
        <div class='section'>
         
          <h2>I am the admin, what do I do?</h2>

        <p>You may now add content to the webroot directory for your
        software.</p>

        <p><strong>For systems using the
        <a href="https://httpd.apache.org/">Apache Webserver</strong></a>:
        You can add content to the directory <code>/var/www/html/</code>.
        Until you do so, people visiting your website will see this page. If
        you would like this page to not be shown, follow the instructions in:
        <code>/etc/httpd/conf.d/welcome.conf</code>.</p>

        <p><strong>For systems using
        <a href="https://nginx.org">Nginx</strong></a>:
        You can add your content in a location of your
        choice and edit the <code>root</code> configuration directive
        in <code>/etc/nginx/nginx.conf</code>.</p>
        
        <div id="logos">
          <a href="https://rockylinux.org/" id="rocky-poweredby"><img src="icons/poweredby.png" alt="[ Powered by Rocky Linux ]" /></a> <!-- Rocky -->
          <img src="poweredby.png" /> <!-- webserver -->
        </div>       
      </div>
      </div>
      
      <footer class="col-sm-12">
      <a href="https://apache.org">Apache&trade;</a> is a registered trademark of <a href="https://apache.org">the Apache Software Foundation</a> in the United States and/or other countries.<br />
      <a href="https://nginx.org">NGINX&trade;</a> is a registered trademark of <a href="https://">F5 Networks, Inc.</a>.
      </footer>
      
  </body>
</html>

```

Partie 3 : service netcat fait maison

voir le 1

2. Analyse des services existants


🌞 Afficher le fichier de service SSH

````
[amine@localhost ~]$ systemctl status sshd
● sshd.service - OpenSSH server daemon
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; preset: enabled)
     Active: active (running) since Tue 2024-01-30 11:12:35 CET; 1h 7min ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 1751 (sshd)
      Tasks: 1 (limit: 23098)
     Memory: 1.4M
        CPU: 41ms
     CGroup: /system.slice/sshd.service
             └─1751 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"

Jan 30 11:12:35 localhost.localdomain systemd[1]: Starting OpenSSH server daemon...
Jan 30 11:12:35 localhost.localdomain sshd[1751]: Server listening on 0.0.0.0 port 22.
Jan 30 11:12:35 localhost.localdomain sshd[1751]: Server listening on :: port 22.
Jan 30 11:12:35 localhost.localdomain systemd[1]: Started OpenSSH server daemon.
Jan 30 11:21:29 localhost.localdomain sshd[1945]: error: kex_exchange_identification: client >
Jan 30 11:21:29 localhost.localdomain sshd[1945]: error: send_error: write: Broken pipe
Jan 30 11:21:29 localhost.localdomain sshd[1945]: banner exchange: Connection from 10.3.1.11 >
Jan 30 11:24:18 localhost.localdomain sshd[2053]: error: kex_exchange_identification: Connect>
Jan 30 11:24:18 localhost.localdomain sshd[2053]: Connection closed by 10.3.1.11 port 42418

[amine@localhost ~]$ systemctl show ssh --property=ExecStart

````

🌞 Afficher le fichier de service NGINX

```

[amine@localhost ~]$ systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; preset: disabled)
     Active: active (running) since Thu 2024-02-01 09:58:36 CET; 1h 12min ago
   Main PID: 1738 (nginx)
      Tasks: 2 (limit: 23098)
     Memory: 2.0M
        CPU: 23ms
     CGroup: /system.slice/nginx.service
             ├─1738 "nginx: master process /usr/sbin/nginx"
             └─1739 "nginx: worker process"

Feb 01 09:58:36 localhost.localdomain systemd[1]: nginx.service: Deactivated successfully.
Feb 01 09:58:36 localhost.localdomain systemd[1]: Stopped The nginx HTTP and reverse prox>
Feb 01 09:58:36 localhost.localdomain systemd[1]: Starting The nginx HTTP and reverse pro>
Feb 01 09:58:36 localhost.localdomain nginx[1736]: nginx: the configuration file /etc/ngi>
Feb 01 09:58:36 localhost.localdomain nginx[1736]: nginx: configuration file /etc/nginx/n>
Feb 01 09:58:36 localhost.localdomain systemd[1]: Started The nginx HTTP and reverse prox>

cat /etc/systemd/system/nginx.service | grep ExecStart

```

3. Création de service

🌞 Créez le fichier /etc/systemd/system/tp2_nc.service
````
[amine@localhost ~]$ sudo nano /etc/systemd/system/tp3_nc.service
[sudo] password for amine: 
[Unit]
Description=Super netcat tout fou

[Service]
ExecStart=/usr/bin/nc -l 80 -k

````
🌞 Indiquer au système qu'on a modifié les fichiers de service

```
[amine@localhost ~]$ sudo systemctl daemon-reload

```

🌞 Démarrer notre service de ouf

````
[amine@localhost ~]$ sudo systemctl restart tp3_nc

````

🌞 Vérifier que ça fonctionne

```
[amine@localhost ~]$ sudo systemctl status tp3_nc.service
× tp3_nc.service
     Loaded: loaded (/etc/systemd/system/tp3_nc.service; static)
     Active: failed (Result: exit-code) since Thu 2024-02-01 11:45:24 CET; 2s ago
   Duration: 5ms
    Process: 2064 ExecStart=/usr/bin/nc -l 80 -k (code=exited, status=2)
   Main PID: 2064 (code=exited, status=2)
        CPU: 3ms

Feb 01 11:45:24 localhost.localdomain systemd[1]: Started tp3_nc.service.
Feb 01 11:45:24 localhost.localdomain nc[2064]: Ncat: bind to 0.0.0.0:80: Address already>
Feb 01 11:45:24 localhost.localdomain systemd[1]: tp3_nc.service: Main process exited, co>
Feb 01 11:45:24 localhost.localdomain systemd[1]: tp3_nc.service: Failed with result 'exi>
```

🌞 Les logs de votre service

```
[amine@localhost ~]$ sudo journalctl -xe -u tp3_nc
[sudo] password for amine: 
░░ 
░░ The unit tp3_nc.service has entered the 'failed' state with result 'exit-code'.
Feb 01 11:35:17 localhost.localdomain systemd[1]: /etc/systemd/system/tp3_nc.service:1: Unknow>
Feb 01 11:38:15 localhost.localdomain systemd[1]: Started tp3_nc.service.
░░ Subject: A start job for unit tp3_nc.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://wiki.rockylinux.org/rocky/support
░░ 
░░ A start job for unit tp3_nc.service has finished successfully.
░░ 
░░ The job identifier is 2148.
Feb 01 11:38:15 localhost.localdomain nc[2050]: Ncat: bind to 0.0.0.0:80: Address already in u>
Feb 01 11:38:15 localhost.localdomain systemd[1]: tp3_nc.service: Main process exited, code=ex>
░░ Subject: Unit process exited
░░ Defined-By: systemd
░░ Support: https://wiki.rockylinux.org/rocky/support
░░ 
░░ An ExecStart= process belonging to unit tp3_nc.service has exited.
░░ 
░░ The process' exit code is 'exited' and its exit status is 2.
Feb 01 11:38:15 localhost.localdomain systemd[1]: tp3_nc.service: Failed with result 'exit-cod>
░░ Subject: Unit failed
░░ Defined-By: systemd
░░ Support: https://wiki.rockylinux.org/rocky/support
░░ 
░░ The unit tp3_nc.service has entered the 'failed' state with result 'exit-code'.
Feb 01 11:45:24 localhost.localdomain systemd[1]: Started tp3_nc.service.
░░ Subject: A start job for unit tp3_nc.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://wiki.rockylinux.org/rocky/support
░░ 
░░ A start job for unit tp3_nc.service has finished successfully.
░░ 
░░ The job identifier is 2238.
Feb 01 11:45:24 localhost.localdomain nc[2064]: Ncat: bind to 0.0.0.0:80: Address already in u>
Feb 01 11:45:24 localhost.localdomain systemd[1]: tp3_nc.service: Main process exited, code=ex>
░░ Subject: Unit process exited
░░ Defined-By: systemd
░░ Support: https://wiki.rockylinux.org/rocky/support
░░ 
░░ An ExecStart= process belonging to unit tp3_nc.service has exited.
░░ 
░░ The process' exit code is 'exited' and its exit status is 2.
Feb 01 11:45:24 localhost.localdomain systemd[1]: tp3_nc.service: Failed with result 'exit-cod>
░░ Subject: Unit failed
░░ Defined-By: systemd
░░ Support: https://wiki.rockylinux.org/rocky/support
░░ 
░░ The unit tp3_nc.service has entered the 'failed' state with result 'exit-code'.

[amine@localhost ~]$ sudo journalctl -xe -u tp3_nc -f
Feb 01 11:34:43 localhost.localdomain systemd[1]: /etc/systemd/system/tp3_nc.service:1: Unknown section 'UNIT'. Ignoring.
Feb 01 11:34:43 localhost.localdomain systemd[1]: /etc/systemd/system/tp3_nc.service:1: Unknown section 'UNIT'. Ignoring.
Feb 01 11:35:12 localhost.localdomain systemd[1]: /etc/systemd/system/tp3_nc.service:1: Unknown section 'UNIT'. Ignoring.
Feb 01 11:35:12 localhost.localdomain systemd[1]: Started tp3_nc.service.
░░ Subject: A start job for unit tp3_nc.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://wiki.rockylinux.org/rocky/support
░░ 
░░ A start job for unit tp3_nc.service has finished successfully.
░░ 
░░ The job identifier is 2058.
Feb 01 11:35:12 localhost.localdomain nc[1968]: Ncat: bind to 0.0.0.0:80: Address already in use. QUITTING.
Feb 01 11:35:12 localhost.localdomain systemd[1]: tp3_nc.service: Main process exited, code=exited, status=2/INVALIDARGUMENT
░░ Subject: Unit process exited
░░ Defined-By: systemd
░░ Support: https://wiki.rockylinux.org/rocky/support
░░ 
░░ An ExecStart= process belonging to unit tp3_nc.service has exited.
░░ 
░░ The process' exit code is 'exited' and its exit status is 2.
Feb 01 11:35:12 localhost.localdomain systemd[1]: tp3_nc.service: Failed with result 'exit-code'.
░░ Subject: Unit failed
░░ Defined-By: systemd
░░ Support: https://wiki.rockylinux.org/rocky/support
░░ 
░░ The unit tp3_nc.service has entered the 'failed' state with result 'exit-code'.
Feb 01 11:35:17 localhost.localdomain systemd[1]: /etc/systemd/system/tp3_nc.service:1: Unknown section 'UNIT'. Ignoring.
Feb 01 11:38:15 localhost.localdomain systemd[1]: Started tp3_nc.service.
░░ Subject: A start job for unit tp3_nc.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://wiki.rockylinux.org/rocky/support
░░ 
░░ A start job for unit tp3_nc.service has finished successfully.
░░ 
░░ The job identifier is 2148.
Feb 01 11:38:15 localhost.localdomain nc[2050]: Ncat: bind to 0.0.0.0:80: Address already in use. QUITTING.
Feb 01 11:38:15 localhost.localdomain systemd[1]: tp3_nc.service: Main process exited, code=exited, status=2/INVALIDARGUMENT
░░ Subject: Unit process exited
░░ Defined-By: systemd
░░ Support: https://wiki.rockylinux.org/rocky/support
░░ 
░░ An ExecStart= process belonging to unit tp3_nc.service has exited.
░░ 
░░ The process' exit code is 'exited' and its exit status is 2.
Feb 01 11:38:15 localhost.localdomain systemd[1]: tp3_nc.service: Failed with result 'exit-code'.
░░ Subject: Unit failed
░░ Defined-By: systemd
░░ Support: https://wiki.rockylinux.org/rocky/support
░░ 
░░ The unit tp3_nc.service has entered the 'failed' state with result 'exit-code'.
Feb 01 11:45:24 localhost.localdomain systemd[1]: Started tp3_nc.service.
░░ Subject: A start job for unit tp3_nc.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://wiki.rockylinux.org/rocky/support
░░ 
░░ A start job for unit tp3_nc.service has finished successfully.
░░ 
░░ The job identifier is 2238.
Feb 01 11:45:24 localhost.localdomain nc[2064]: Ncat: bind to 0.0.0.0:80: Address already in use. QUITTING.
Feb 01 11:45:24 localhost.localdomain systemd[1]: tp3_nc.service: Main process exited, code=exited, status=2/INVALIDARGUMENT
░░ Subject: Unit process exited
░░ Defined-By: systemd
░░ Support: https://wiki.rockylinux.org/rocky/support
░░ 
░░ An ExecStart= process belonging to unit tp3_nc.service has exited.
░░ 
░░ The process' exit code is 'exited' and its exit status is 2.
Feb 01 11:45:24 localhost.localdomain systemd[1]: tp3_nc.service: Failed with result 'exit-code'.
░░ Subject: Unit failed
░░ Defined-By: systemd
░░ Support: https://wiki.rockylinux.org/rocky/support
░░ 
░░ The unit tp3_nc.service has entered the 'failed' state with result 'exit-code'.
^C


[amine@localhost ~]$ sudo journalctl -xe -u tp2_nc | grep "Started Super netcat tout fou"

[amine@localhost ~]$ sudo journalctl -xe -u tp2_nc | grep "Message received:"

[amine@localhost ~]$ sudo journalctl -xe -u tp2_nc | grep "Stopping Super netcat tout fou"

```
🌞 S'amuser à kill le processus
```
[amine@localhost ~]$ pgrep -f "nc -k -l -p 8080"

[amine@localhost ~]$ sudo kill 1234


```

🌞 Affiner la définition du service

```
[amine@localhost ~]$ sudo nano /etc/systemd/system/tp3_nc.service
  GNU nano 5.6.1                 /etc/systemd/system/tp3_nc.service                            
[UNIT]
Description=Super netcat tout fou

[Service]
ExecStart=/usr/bin/nc -k -l -p 8080
Restart=always

[Install]
WantedBy=multi-user.target

[amine@localhost ~]$ sudo systemctl daemon-reload


[amine@localhost ~]$ sudo systemctl restart tp3_nc

```