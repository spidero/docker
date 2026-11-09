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

## How joining works

- `rabbitmq1` has a healthcheck (`rabbitmq-diagnostics ping`); `rabbitmq2` and `rabbitmq3` start only when it is healthy (`depends_on: condition: service_healthy`).
- Their command (shared YAML anchor `x-join-cluster`) starts `rabbitmq-server -detached`, waits with `rabbitmqctl await_startup`, then runs `stop_app` → `reset` → `join_cluster --ram rabbit@rabbitmq1` → `start_app` and keeps the container alive with `tail -f /dev/null`.
- The cluster is complete about 1–2 minutes after `docker compose up -d`. A single `Error: unable to perform an operation on node` line at the start of the `rabbitmq2`/`rabbitmq3` logs comes from the CLI being called while the node is still booting and can be ignored.

## Notes

- Because RabbitMQ runs detached in `rabbitmq2`/`rabbitmq3`, the container's main process is `tail`; Docker will not notice if RabbitMQ itself stops.
- `RABBITMQ_ERLANG_COOKIE` as an environment variable is deprecated in newer RabbitMQ versions (a cookie file is preferred).
- RabbitMQ 3.8 is end-of-life – see [`../rabbit-4-cluster`](../rabbit-4-cluster) for the RabbitMQ 4 version with persistent volumes.
