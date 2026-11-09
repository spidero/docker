# rabbit-cluster

Three-node RabbitMQ **3.8** cluster with the management plugin, on one host. `rabbitmq1` is the seed node; `rabbitmq2` and `rabbitmq3` join it as **RAM nodes** (`join_cluster --ram`).

| Node | AMQP | Management UI |
|---|---|---|
| `rabbitmq1` | `5672` | <http://localhost:15672> |
| `rabbitmq2` | `5673` | <http://localhost:15673> |
| `rabbitmq3` | `5674` | <http://localhost:15674> |

Login: `admin` / `password` (from `RABBITMQ_DEFAULT_USER` / `RABBITMQ_DEFAULT_PASS`). All nodes share the same Erlang cookie, which is required for clustering.

## Usage

```bash
docker compose up -d
docker exec rabbitmq1 rabbitmqctl cluster_status    # should list all three nodes
docker compose down
```

## Notes

- **The join commands probably do not work as written.** `command:` on `rabbitmq2` and `rabbitmq3` replaces the image's default command, so `rabbitmq-server` is never started there; `rabbitmqctl stop_app` / `join_cluster` then have no node to talk to and the containers exit. The `rabbit-4-cluster` example solves this by starting `rabbitmq-server -detached` first (see `join-cluster.sh` there).
- `RABBITMQ_CLUSTERER_PARTITION_PREFIX` and `JOIN_CLUSTER_HOST` are not used by the official image.
- `RABBITMQ_ERLANG_COOKIE` as an environment variable is deprecated in newer RabbitMQ versions (a cookie file is preferred).
- RabbitMQ 3.8 is end-of-life – see [`../rabbit-4-cluster`](../rabbit-4-cluster) for the RabbitMQ 4 version with persistent volumes.
- The top-level `version:` key is obsolete; `docker compose` prints a warning and ignores it.
