# install_packages

Example of installing system packages while building an image: Fedora 26 with `openssh-server`, `openssh-clients` and `sudo` installed by `yum`. The package cache is cleaned in the same `RUN` layer to keep the image small.

## Usage

```bash
docker build -t fedora-ssh .
docker run --rm -it fedora-ssh bash
```

## Files

| File | Purpose |
|---|---|
| `Dockerfile` | `FROM fedora:26`, `yum -y update` + package install + `yum clean all`, `EXPOSE 22 8022` |

## Notes

- The image only **installs** the SSH server – it does not generate host keys or start `sshd`, and `EXPOSE` does not publish anything. To actually use SSH you would need e.g. `ssh-keygen -A` and `CMD ["/usr/sbin/sshd", "-D"]`, then `docker run -p 8022:22 …`.
- Fedora 26 is end-of-life; its package mirrors are archived, so `yum update` may fail. For a working build switch to a current release (e.g. `fedora:latest` with `dnf`).
