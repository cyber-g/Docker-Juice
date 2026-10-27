# Docker-Juice

Image Docker légère pour [Juice](https://github.com/Automattic/juice), qui transforme
les règles CSS en styles directement intégrés aux éléments HTML (notamment pour
les e-mails).

- Image Docker Hub : [`drdpham/juice`](https://hub.docker.com/r/drdpham/juice)
- Base officielle : [`node:22-alpine`](https://github.com/nodejs/docker-node)
- Exécution sans privilèges avec l’utilisateur `node`, répertoire de travail `/data`.

La variante Alpine limite la taille de l’image, sans prétendre être la plus petite
possible. Juice est installé globalement sans version épinglée ; son cache npm
est nettoyé dans la même couche. La version npm vérifiée, Juice 12.2.1, exige
Node >=22.12.0, compatible avec la version actuelle de l’image officielle Node 22.
Les versions résolues peuvent donc évoluer lors des reconstructions.

## Utilisation

Prérequis : Docker.

```bash
docker pull drdpham/juice:latest
docker run --rm drdpham/juice:latest --help
docker run --rm drdpham/juice:latest --version
```

Sans argument, le conteneur affiche l’aide. Pour lire sur l’entrée standard et
écrire sur la sortie standard, utiliser `- -` et conserver l’option Docker `-i` :

```bash
printf '%s\n' '<style>p { color: red; }</style><p>Hello Juice</p>' \
  | docker run --rm -i drdpham/juice:latest - - > output.html
cat output.html
```

Le résultat contient `<p style="color: red;">Hello Juice</p>`.

Pour traiter un fichier local avec ses ressources relatives, monter le dossier
en lecture seule et rediriger la sortie depuis l’hôte :

```bash
docker run --rm -v "$(pwd):/data:ro" drdpham/juice:latest input.html - > output.html
```

Le fichier d’entrée doit être lisible par l’utilisateur `node`. La redirection
évite d’avoir à donner au conteneur des droits d’écriture sur le dossier hôte.
Ne traiter que des documents et ressources de confiance : Juice peut charger
les ressources référencées dans le HTML.

## Construction et tests locaux

Depuis la racine du dépôt :

```bash
docker build -t juice:test .
docker run --rm juice:test --help
docker run --rm juice:test --version
printf '%s\n' '<p>Hello Juice</p>' \
  | docker run --rm -i juice:test - - > output.html
cat output.html
grep -Eq '<p>Hello Juice</p>' output.html
printf '%s\n' '<style>p { color: red; }</style><p>Hello Juice</p>' \
  | docker run --rm -i juice:test - - > output.html
grep -Eq '<p style="color: red;">Hello Juice</p>' output.html
rm output.html
```

## Publication automatique

Le workflow GitHub Actions construit et teste l’image lors des pull requests
vers `main`, des pushes sur `main`, des tags `v*` et des lancements manuels.
Il publie dans `drdpham/juice` uniquement hors pull request, après les tests :

- `latest` pour la branche par défaut `main` ;
- le nom du tag Git pour les tags `v*` (par exemple `v1.0.0`) ;
- un tag `sha-…` pour identifier le commit.

Configurer les secrets du dépôt `DOCKERHUB_USERNAME` (compte disposant des droits
d’écriture sur `drdpham/juice`) et `DOCKERHUB_TOKEN` (jeton Docker Hub avec droit
d’écriture). Aucune authentification Docker Hub n’est nécessaire pour les tests
des pull requests. Aucun lancement ne fusionne une pull request.

## Licence

Ce dépôt est distribué sous [GPL-3.0](LICENSE). Juice et l’image Node conservent
leurs licences respectives.
