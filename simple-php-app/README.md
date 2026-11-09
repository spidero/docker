# simple-php-app

Minimal PHP + Apache application based on the official `php:apache` image. The page shows the container hostname followed by `phpinfo()` – handy for checking which container served a request (e.g. behind a load balancer).

## Usage

### docker compose (development)

```bash
docker compose up -d
```

Open <http://localhost:8080>. `index.php` and `cpu-load.php` are mounted as volumes, so edits are visible immediately without a rebuild.

### Dockerfile (self-contained image)

```bash
docker build -t simple-php-app .
docker run --rm -p 8080:80 simple-php-app
```

The image upgrades system packages, copies `index.php` and `cpu-load.php` into `/var/www/html/` and runs as the unprivileged `www-data` user.

## Files

| File | Purpose |
|---|---|
| `index.php` | prints `HOSTNAME` and `phpinfo()` |
| `cpu-load.php` | CPU stress test: 1 000 000 000 × `sqrt()`, prints the execution time |
| `Dockerfile` | self-contained image with both PHP files |
| `docker-compose.yaml` | `php:apache` on port `8080`, both PHP files mounted |

## Notes

- <http://localhost:8080/cpu-load.php> keeps one CPU core busy for a long time (tens of seconds or more) per request – good for testing autoscaling and monitoring, but do not expose it publicly.
- `phpinfo()` exposes configuration details – use only for testing.
