# Partie 3 : Poupée russe

Pour finir de vous exercer avec le terminal, je vous ai préparé une poupée russe :D

➜ **De mon côté, pour préparer l'exercice :**

- j'ai créé un dossier `dawa/`, qui a plein de sous-dossiers, sous-fichiers, etc
  - y'a des fichiers particuliers, les autres c'est juste du random
- je l'ai archivé/compressé plusieurs fois
- j'ai volontairement supprimé les extensions des fichiers compressés
  - comme ça tu peux pas savoir à l'aide du nom si c'est un `.zip` ou un autre format

➜ **Le but de l'exercice pour vous :**

- je vous file le fichier que j'ai compressé/archivé plusieurs fois, que vous téléchargez dans la VM
- vous devez :
  - déterminer le type du fichier
  - renommer le fichier correctement (si c'est une archive zip, il faut ajouter `.zip` à son nom)
  - extraire l'archive
  - répéter l'opération (car j'ai mis une archive, dans une archive, dans une archive... meow)
- bien sûr que c'est stupide
  - mais c'est pour vous faire pratiquer le terminal, et voir des commandes usuelles
- une fois que vous avez trouvé le dossier `dawa/`, vous avez fini le jeu de poupées russes
- vous allez devoir trouver les fichiers spécifiques que je vous demande à l'intérieur de ce dossier

🌞 **Récupérer le fichier `meow`**

- [il est dispo là](./meow) (juste à côté de ce README.md)
- téléchargez-le à l'aide d'une commande

🌞 **Trouver le dossier `dawa/`**

- le fichier `meow` récupéré est une archive compressée
- utilisez la commande `file /path/vers/le/fichier` pour déterminer le type du fichier
- renommez-le fichier correctement (si c'est une archive compressée ZIP, il faut ajouter `.zip` à son nom)
- extraire l'archive avec une commande
- répétez ces opérations jusqu'à trouver le dossier `dawa/`

> *Dans les OS Linux, le format d'archivage/compression qu'on voit le plus c'est `.tar.gz` (archivage tar avec une compression gz) et moins de `.zip`.*

🌞 **Dans le dossier `dawa/`, déterminer le chemin vers**

- le seul fichier de 15Mo
- le seul fichier qui ne contient que des `7`
- le seul fichier qui est nommé `cookie`
- le seul fichier caché (un fichier caché c'est juste un fichier dont le nom commence par un `.`)
- le seul fichier qui date de 2014
- le seul fichier qui a 5 dossiers-parents
  - je pense que vous avez vu que la structure c'est 50 `folderX`, chacun contient 50 dossiers `X`, et chacun contient 50 `fileX`
  - bon bah là y'a un fichier qui est contenu dans `folderX/X/X/X/X/` et c'est le seul qui 5 dossiers parents comme ça

![Matryoshka](./img/dolls.png)
