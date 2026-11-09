# pgsql-ha-patroni

PostgreSQL high availability on a single Docker host: two PostgreSQL 16 nodes managed by **Patroni**, cluster state in **etcd**, and **HAProxy** routing clients to the current primary (writes) or the replica (reads). A good lab for learning failover before the multi-host version in [`../pgsql-ha-patroni-3nodes`](../pgsql-ha-patroni-3nodes).

```text
             clients
   5432 (write)    5433 (read)    7000 (stats)
               \      |      /
                  HAProxy
       health check: GET :8008/primary | /replica
               /             \
        pg-node1             pg-node2         Patroni + PostgreSQL 16
               \             /
                    etcd1                     leader lock / cluster state
```

| Service | Image | Purpose |
|---|---|---|
| `etcd1` | `quay.io/coreos/etcd:v3.5.9` | single-member etcd (DCS) |
| `pg-node1`, `pg-node2` | built from `patroni/Dockerfile` (`postgres:16-alpine` + `patroni[etcd3]`) | PostgreSQL managed by Patroni, REST API on `8008` |
| `haproxy` | `haproxy:alpine` | `5432` → primary, `5433` → replicas, `7000` → stats page |

## Usage

```bash
docker compose up -d --build
docker exec pg-node1 patronictl -c /etc/patroni/patroni.yml list    # who is Leader / Replica
```

Connect through HAProxy (password from `patroni.yml`):

```bash
psql -h localhost -p 5432 -U postgres     # read-write, always the primary
psql -h localhost -p 5433 -U postgres     # read-only, a replica
```

HAProxy stats: <http://localhost:7000> (login `admin` / `pass`).

### Failover test

```bash
docker stop pg-node1                                                  # stop the current leader
docker exec pg-node2 patronictl -c /etc/patroni/patroni.yml list      # pg-node2 becomes Leader (~30 s TTL)
docker start pg-node1                                                 # rejoins as Replica (pg_rewind)
```

Planned switchover: `docker exec -it pg-node1 patronictl -c /etc/patroni/patroni.yml switchover`.

## Files

| File | Purpose |
|---|---|
| `docker-compose.yaml` | etcd, two Patroni nodes, HAProxy, volumes `pgdata1`/`pgdata2` |
| `patroni/Dockerfile` | PostgreSQL 16 Alpine + Python + Patroni with etcd3 support |
| `patroni.yml` | shared Patroni config: DCS `etcd1:2379`, replication settings, `pg_hba`, users |
| `haproxy.cfg` | TCP frontends `5432`/`5433` with HTTP health checks against Patroni (`/primary`, `/replica`) |

Each node's name and addresses come from the `PATRONI_NAME`, `PATRONI_RESTAPI_CONNECT_ADDRESS` and `PATRONI_POSTGRESQL_CONNECT_ADDRESS` environment variables, which override the values in the shared `patroni.yml`.

## Notes

- Single etcd member and two nodes on one host: fine for learning, not real HA.
- Passwords (`SuperPassword123`, `ReplicaPassword123`, HAProxy `admin:pass`) are in the repository and `pg_hba` allows `0.0.0.0/0` – local testing only.
- Remove the data volumes for a fresh cluster: `docker compose down -v`.
