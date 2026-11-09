# install_packages

Example of installing system packages while building an image: Fedora 44 with `openssh-server`, `openssh-clients` and `sudo` installed by `dnf`, running an SSH server.

- packages are installed and the `dnf` cache is cleaned in the same `RUN` layer, so the cache does not end up in the image,
- SSH host keys are generated at build time (`ssh-keygen -A`) – in a container there is no systemd to do it on first boot,
- `sshd` runs in the foreground (`-D`) and logs to stderr (`-e`), so `docker logs` shows its output.

## Usage

```bash
docker build -t fedora-ssh .
docker run -d --name fedora-ssh -p 8022:22 fedora-ssh
docker logs fedora-ssh                 # "Server listening on :: port 22."
ssh -p 8022 localhost                  # SSH banner: OpenSSH 10.x
docker rm -f fedora-ssh
```

## Files

| File | Purpose |
|---|---|
| `Dockerfile` | `FROM fedora:44`, `dnf upgrade` + package install + `dnf clean all`, host keys, `CMD sshd -D -e` |

## Notes

- There is no user with a password or an authorized key, so you can connect but not log in. For a test login add e.g. a user with a key:

  ```dockerfile
  RUN useradd -m -G wheel demo && mkdir -m 700 /home/demo/.ssh
  COPY id_ed25519.pub /home/demo/.ssh/authorized_keys
  RUN chown -R demo:demo /home/demo/.ssh
  ```

- Host keys are baked into the image, so every container from it has the same keys – fine for a demo, not for production.
