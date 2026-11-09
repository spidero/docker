# rabbit-4-cluster

Three-node RabbitMQ **4** cluster with the management plugin and persistent volumes, on one host. `rabbitmq1` is the seed node; `rabbitmq2` and `rabbitmq3` join it using `join-cluster.sh`.

| Node | AMQP | Management UI | Volume |
|---|---|---|---|
| `rabbitmq1` | `5672` | <http://localhost:15672> | `rabbitmq1_data` |
| `rabbitmq2` | `5673` | <http://localhost:15673> | `rabbitmq2_data` |
| `rabbitmq3` | `5674` | <http://localhost:15674> | `rabbitmq3_data` |

Login: `user` / `password`. All nodes share the Erlang cookie `rabbitmq-cluster-cookie`.

## How joining works

`join-cluster.sh` is mounted into `rabbitmq2` and `rabbitmq3` and used as their entrypoint with the seed node name (`rabbit@rabbitmq1`) as argument:

1. wait 10 s for the seed node,
2. start `rabbitmq-server -detached`, wait 10 s,
3. `rabbitmqctl stop_app` → `rabbitmqctl join_cluster rabbit@rabbitmq1` → `rabbitmqctl start_app`,
4. `tail -f /dev/null` to keep the container running.

## Usage

```bash
docker compose up -d
sleep 30
docker exec rabbitmq1 rabbitmqctl cluster_status    # should list rabbit@rabbitmq1..3
```

Stop, keeping data / remove data as well:

```bash
docker compose down
docker compose down -v
```

## Notes

- The fixed `sleep` delays are a simple approach; on a slow machine the seed node may not be ready after 10 s – then restart the node (`docker compose restart rabbitmq2`).
- Because the entrypoint is replaced, RabbitMQ in `rabbitmq2`/`rabbitmq3` runs detached and the container's main process is `tail`; Docker will not notice if RabbitMQ itself stops.
- The top-level `version:` key is obsolete; `docker compose` prints a warning and ignores it.
- Credentials and cookie are for local testing only.
