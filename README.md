# Docker examples

Examples of Dockerfiles and Docker Compose setups – from a one-line "hello world" to highly available PostgreSQL and RabbitMQ clusters. Every directory is self-contained and has its own README with usage details.

## Contents

### Basics

| Directory | Description |
|---|---|
| [`hello_world`](hello_world) | Smallest possible image: `busybox` printing a message |
| [`install_packages`](install_packages) | Installing system packages during a build: Fedora 44 + OpenSSH server, sudo |
| [`ansible`](ansible) | Alpine 3.18 image with Ansible |
| [`xeyes-gui-app`](xeyes-gui-app) | Running an X11 GUI application (`xeyes`) from a container |

### Web applications and load balancing

| Directory | Description | Ports |
|---|---|---|
| [`simple-php-app`](simple-php-app) | PHP + Apache showing hostname and `phpinfo()`, CPU load test script | 8080 |
| [`simple-docker-app-with-lb`](simple-docker-app-with-lb) | App with Redis cache behind a round-robin load balancer | 4000 |
| [`nginx-compose-build`](nginx-compose-build) | HAProxy balancing two Apache + PHP servers (built with compose) | 80, 9000 |

### Databases

| Directory | Description | Ports |
|---|---|---|
| [`mysql-phpadmin`](mysql-phpadmin) | MariaDB + phpMyAdmin | standard ports + 1 |
| [`mysql-phpadmin-custom`](mysql-phpadmin-custom) | MariaDB + phpMyAdmin with a custom user and database | standard ports + 1 |
| [`pgsql-ha-patroni`](pgsql-ha-patroni) | PostgreSQL 16 HA on one host: 2 × Patroni, etcd, HAProxy | 5432 write, 5433 read, 7000 stats |
| [`pgsql-ha-patroni-3nodes`](pgsql-ha-patroni-3nodes) | PostgreSQL 16 HA on 3 VMs (etcd + Patroni each) + HAProxy VM | 5432, 5433, 7000 |

### Messaging

| Directory | Description | Ports |
|---|---|---|
| [`rabbit-cluster`](rabbit-cluster) | RabbitMQ 3.8 three-node cluster with management UI | 5672–5674, 15672–15674 |
| [`rabbit-4-cluster`](rabbit-4-cluster) | RabbitMQ 4 three-node cluster with persistent volumes and a join script | 5672–5674, 15672–15674 |

### Monitoring and code quality

| Directory | Description | Ports |
|---|---|---|
| [`grafana-influxdb`](grafana-influxdb) | Grafana + InfluxDB stack (work in progress) | 3000, 8086 |
| [`sonarqube`](sonarqube) | SonarQube 10 Community + PostgreSQL 15 | 9000 |

### Other

| Directory | Description | Ports |
|---|---|---|
| [`ELM327-emulator`](ELM327-emulator) | ELM327 (OBD-II) car emulator + terminal dashboard with live charts and CSV recording | 35000 |

## Usage

Most examples are started from their directory:

```bash
cd <directory>
docker compose up -d        # start
docker compose logs -f      # follow logs
docker compose down         # stop (add -v to remove volumes)
```

Directories with only a `Dockerfile` are built and run directly:

```bash
docker build -t <name> .
docker run --rm <name>
```

Several examples publish the same host ports (e.g. `5432`, `5672`, `15672`, `9000`), so run them one at a time or change the port mappings.

## Notes

- The examples are meant for learning and local testing. Passwords and other credentials in the files are demo values – do not reuse them in production.
- GitHub Actions (`.github/workflows/docker-image.yml`) validates every compose file (`docker-compose.yml`/`.yaml`, `compose.yml`/`.yaml`) with `docker compose config` on each push to `master`, on pull requests and on manual run. It checks syntax and structure only – images are not built or started.

## License

GNU Lesser General Public License v3.0 – see [LICENSE](LICENSE).
