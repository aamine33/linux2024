#!/bin/bash

afficher_informations_machine() {
    echo "Nom de la machine :"
    hostnamectl | grep "Operating System" | cut -d ' ' -f5-

    echo "Nom de l'OS de la machine :"
    if [ -f /etc/redhat-release ]; then
        cat /etc/redhat-release
    elif [ -f /etc/os-release ]; then
        source /etc/os-release
        echo $PRETTY_NAME
    else
        echo "OS non reconnu"
    fi

    echo "Version du noyau Linux :"
    uname -r

    echo "Adresse IP de la machine :"
    ip addr show | grep -Po 'inet \K[\d.]+'

    echo "État de la RAM :"
    free -h | grep "Mem:"

    echo "Espace restant sur le disque dur :"
    df -h / | awk 'NR==2 {print $4}'

    echo "Top 5 des processus qui utilisent le plus de RAM :"
    ps -eo pid,comm,%mem --sort=-%mem | head -6 | awk 'NR>1 {print $2, $3}'

    echo "Liste des ports en écoute :"
    ss -lntu | awk 'NR>1 {print $1, $5}'

    echo "Dossiers disponibles dans la variable PATH :"
    echo $PATH | tr ':' '\n'
}

afficher_chat_terminal() {
    image_url=$(curl -s "https://api.thecatapi.com/v1/images/search" | jq -r '.[0].url')
    curl -s $image_url | display - && echo
}
afficher_informations_machine
afficher_chat_terminal

--------------------------------------
Code pour le bonus 1:
#!/bin/bash

DEFAULT_TOKEN="live_gxXl7Z0PjPMFVDdIM77T2c6beemFCHy8KRimDi0BGwZVOIqwCHbksr2Bva8VWUUV"
afficher_informations_machine() {
    echo "Nom de la machine :"
    hostnamectl | grep "Operating System" | cut -d ' ' -f5-

    echo "Nom de l'OS de la machine :"
    if [ -f /etc/redhat-release ]; then
        cat /etc/redhat-release
    elif [ -f /etc/os-release ]; then
        source /etc/os-release
        echo $PRETTY_NAME
    else
        echo "OS non reconnu"
    fi

    echo "Version du noyau Linux :"
    uname -r

    echo "Adresse IP de la machine :"
    ip addr show | grep -Po 'inet \K[\d.]+'

    echo "État de la RAM :"
    free -h | grep "Mem:"

    echo "Espace restant sur le disque dur :"
    df -h / | awk 'NR==2 {print $4}'

    echo "Top 5 des processus qui utilisent le plus de RAM :"
    ps -eo pid,comm,%mem --sort=-%mem | head -6 | awk 'NR>1 {print $2, $3}'

    echo "Liste des ports en écoute :"
    ss -lntu | awk 'NR>1 {print $1, $5}'

    echo "Dossiers disponibles dans la variable PATH :"
    echo $PATH | tr ':' '\n'
}
afficher_chat_terminal() {
    local token="$1"
    local image_url
    if [ -z "$token" ]; then
        echo "Aucun token spécifié, en utilisant le token par défaut."
        token="$DEFAULT_TOKEN"
    fi
    image_url=$(curl -s "https://api.thecatapi.com/v1/images/search?api_key=$token" | jq -r '.[0].url')
    curl -s $image_url --output /tmp/cat_image.jpg
    display /tmp/cat_image.jpg && echo
}
afficher_informations_machine
afficher_chat_terminal "$1"
----------------------------------------------
code pour le bonus 2 


#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    echo "Ce script doit être exécuté en tant que root."
    exit 1
fi

DEFAULT_TOKEN="live_gxXl7Z0PjPMFVDdIM77T2c6beemFCHy8KRimDi0BGwZVOIqwCHbksr2Bva8VWUUV"
afficher_informations_machine() {
    echo "Nom de la machine :"
    hostnamectl | grep "Operating System" | cut -d ' ' -f5-

    echo "Nom de l'OS de la machine :"
    if [ -f /etc/redhat-release ]; then
        cat /etc/redhat-release
    elif [ -f /etc/os-release ]; then
        source /etc/os-release
        echo $PRETTY_NAME
    else
        echo "OS non reconnu"
    fi

    echo "Version du noyau Linux :"
    uname -r

    echo "Adresse IP de la machine :"
    ip addr show | grep -Po 'inet \K[\d.]+'

    echo "État de la RAM :"
    free -h | grep "Mem:"

    echo "Espace restant sur le disque dur :"
    df -h / | awk 'NR==2 {print $4}'

    echo "Top 5 des processus qui utilisent le plus de RAM :"
    ps -eo pid,comm,%mem --sort=-%mem | head -6 | awk 'NR>1 {print $2, $3}'

    echo "Liste des ports en écoute :"
    ss -lntu | awk 'NR>1 {print $1, $5}'

    echo "Dossiers disponibles dans la variable PATH :"
    echo $PATH | tr ':' '\n'
}
afficher_chat_terminal() {
    local token="$1"
    local image_url
    if [ -z "$token" ]; then
        echo "Aucun token spécifié, en utilisant le token par défaut."
        token="$DEFAULT_TOKEN"
    fi
    image_url=$(curl -s "https://api.thecatapi.com/v1/images/search?api_key=$token" | jq -r '.[0].url')
    curl -s $image_url --output /tmp/cat_image.jpg
    display /tmp/cat_image.jpg && echo
}
afficher_informations_machine
afficher_chat_terminal "$1"
---------------------------------------------------
pour le code du bonus 3 
#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    echo "Ce script doit être exécuté en tant que root."
    exit 1
fi

if [ ! -d "/srv/cats/" ]; then
    echo "Le dossier /srv/cats/ n'existe pas."
    exit 1
fi

if [ "$(stat -c %U /srv/cats/)" != "id" ]; then
    echo "Le dossier /srv/cats/ n'appartient pas à l'utilisateur 'id'."
    exit 1
fi

if [ ! -w "/srv/cats/" ]; then
    echo "Le dossier /srv/cats/ n'est pas accessible en écriture pour l'utilisateur 'id'."
    exit 1
fi

DEFAULT_TOKEN="live_gxXl7Z0PjPMFVDdIM77T2c6beemFCHy8KRimDi0BGwZVOIqwCHbksr2Bva8VWUUV"

afficher_informations_machine() {
    echo "Nom de la machine :"
    hostnamectl | grep "Operating System" | cut -d ' ' -f5-

    echo "Nom de l'OS de la machine :"
    if [ -f /etc/redhat-release ]; then
        cat /etc/redhat-release
    elif [ -f /etc/os-release ]; then
        source /etc/os-release
        echo $PRETTY_NAME
    else
        echo "OS non reconnu"
    fi

    echo "Version du noyau Linux :"
    uname -r

    echo "Adresse IP de la machine :"
    ip addr show | grep -Po 'inet \K[\d.]+'

    echo "État de la RAM :"
    free -h | grep "Mem:"

    echo "Espace restant sur le disque dur :"
    df -h / | awk 'NR==2 {print $4}'

    echo "Top 5 des processus qui utilisent le plus de RAM :"
    ps -eo pid,comm,%mem --sort=-%mem | head -6 | awk 'NR>1 {print $2, $3}'

    echo "Liste des ports en écoute :"
    ss -lntu | awk 'NR>1 {print $1, $5}'

    echo "Dossiers disponibles dans la variable PATH :"
    echo $PATH | tr ':' '\n'
}
afficher_chat_terminal() {
    local token="$1"
    local image_url
    if [ -z "$token" ]; then
        echo "Aucun token spécifié, en utilisant le token par défaut."
        token="$DEFAULT_TOKEN"
    fi
    image_url=$(curl -s "https://api.thecatapi.com/v1/images/search?api_key=$token" | jq -r '.[0].url')
    local image_file="/srv/cats/$(next_image_id).jpg"
    curl -s $image_url --output "$image_file"
    display "$image_file" && echo
}
next_image_id() {
    local id=1
    while [ -f "/srv/cats/$id.jpg" ]; do
        ((id++))
    done
    echo "$id"
}
afficher_informations_machine
afficher_chat_terminal "$1"
-------------------------------------------------
#!/bin/bash

if [ -z "$1" ]; then
    echo "Veuillez fournir l'URL de la vidéo YouTube à télécharger."
    exit 1
fi

download_folder="/srv/yt/downloads/"
if [ ! -d "$download_folder" ]; then
    echo "Le dossier de destination $download_folder n'existe pas."
    exit 1
fi

video_name=$(youtube-dl --get-filename -o "%(title)s" "$1")
video_folder="$download_folder/$video_name"

mkdir -p "$video_folder"

echo "Téléchargement de la vidéo..."
youtube-dl -o "$video_folder/$video_name.mp4" "$1" > /dev/null

echo "Téléchargement de la description..."
youtube-dl --write-description -o "$video_folder/description" "$1" > /dev/null

echo "Téléchargement terminé avec succès dans $video_folder."
-------------------------------
#!/bin/bash

url_file="/srv/yt/urls.txt"

download_folder="/srv/yt/downloads/"

if [ ! -d "$download_folder" ]; then
    echo "Le dossier de destination $download_folder n'existe pas."
    exit 1
fi

while true; do
    if [ -s "$url_file" ]; then
        while IFS= read -r url; do
            if [[ $url == *"youtube.com"* ]]; then
                video_name=$(youtube-dl --get-filename -o "%(title)s" "$url")
                video_folder="$download_folder/$video_name"
                mkdir -p "$video_folder"
                
                echo "Téléchargement de la vidéo : $video_name..."
                youtube-dl -o "$video_folder/$video_name.mp4" "$url" > /dev/null
                
                echo "Téléchargement de la description..."
                youtube-dl --write-description -o "$video_folder/description" "$url" > /dev/null
                sed -i '1d' "$url_file"

                echo "Téléchargement terminé avec succès dans $video_folder."
            else
                sed -i '1d' "$url_file"
                echo "URL non valide : $url. La ligne a été supprimée du fichier."
            fi
        done < "$url_file"
    fi
        sleep 60
done
----------------------------------------
#!/bin/bash

quality="default"
output="/srv/yt/downloads/"

usage() {
    echo "Usage: $0 [-q quality] [-o output_folder] [-h]"
    echo "Options:"
    echo "  -q : Spécifie la qualité des vidéos téléchargées."
    echo "       Exemple: $0 -q 720p"
    echo "  -o : Spécifie le dossier de sortie pour les vidéos téléchargées."
    echo "       Par défaut: /srv/yt/downloads/"
    echo "  -h : Affiche cet usage."
}
while getopts ":q:o:h" opt; do
  case $opt in
    q)
      quality="$OPTARG"
      ;;
    o)
      output="$OPTARG"
      ;;
    h)
      usage
      exit 0
      ;;
    \?)
      echo "Option invalide: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "L'option -$OPTARG nécessite un argument." >&2
      exit 1
      ;;
  esac
done
