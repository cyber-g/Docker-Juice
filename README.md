# Docker-Juice

Image Docker légère pour [Juice](https://github.com/Automattic/juice), qui intègre
le CSS directement dans le HTML. Base officielle `node:24-alpine`, exécution
sans privilèges (`node`) dans `/data`, Juice installé sans version épinglée.

## Utilisation

```bash
docker run --rm drdpham/juice:latest --help
printf '%s\n' '<style>p { color: red; }</style><p>Hello Juice</p>' \
  | docker run --rm -i drdpham/juice:latest - - > output.html
```

Pour un fichier local :

```bash
docker run --rm -v "$(pwd):/data:ro" drdpham/juice:latest input.html - > output.html
```

Le dossier et le fichier doivent être accessibles à l’utilisateur `node`.
Utiliser uniquement du HTML de confiance : Juice peut charger des ressources externes.

## Test local

```bash
docker build -t juice:test .
docker run --rm juice:test --version
printf '%s\n' '<style>p { color: red; }</style><p>Hello Juice</p>' \
  | docker run --rm -i juice:test - -
```

Résultat attendu : `<p style="color: red;">Hello Juice</p>`.

## Publication

GitHub Actions construit les pull requests sans publier. Les pushes sur `main`
et les lancements manuels depuis `main` publient
[`drdpham/juice:latest`](https://hub.docker.com/r/drdpham/juice).
Configurer les secrets `DOCKERHUB_USERNAME` et `DOCKERHUB_TOKEN` avec accès
en écriture au dépôt Docker Hub.

## Licence

Ce dépôt est distribué sous [GPL-3.0](LICENSE). Juice et l’image Node conservent
leurs licences respectives.
