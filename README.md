# Docker-Juice

Lightweight Docker image for [Juice](https://github.com/Automattic/juice), which
inlines CSS into HTML. Based on the official `node:24-alpine` image, running as
the unprivileged `node` user in `/data`, with an unpinned Juice installation.

## Usage

```bash
docker run --rm drdpham/juice:latest --help
printf '%s\n' '<style>p { color: red; }</style><p>Hello Juice</p>' \
  | docker run --rm -i drdpham/juice:latest - - > output.html
```

For a local file:

```bash
docker run --rm -v "$(pwd):/data:ro" drdpham/juice:latest input.html - > output.html
```

The directory and file must be accessible to the `node` user.
Only process trusted HTML: Juice can load external resources.

## Local test

```bash
docker build -t juice:test .
docker run --rm juice:test --version
printf '%s\n' '<style>p { color: red; }</style><p>Hello Juice</p>' \
  | docker run --rm -i juice:test - -
```

Expected output: `<p style="color: red;">Hello Juice</p>`.

## Publishing

GitHub Actions builds pull requests without publishing. Pushes to `main`
and manual runs from `main` publish
[`drdpham/juice:latest`](https://hub.docker.com/r/drdpham/juice) by default.
Under **Settings → Secrets and variables → Actions**, configure:

- **Variable:** `DOCKERHUB_IMAGE` — destination repository without a tag
  (defaults to `drdpham/juice` when unset).
- **Secrets:** `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN`, with write access
  to the destination Docker Hub repository.

## License

This repository is licensed under [GPL-3.0](LICENSE). Juice and the Node image
retain their respective licenses.
