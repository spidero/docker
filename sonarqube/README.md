# sonarqube

SonarQube 10 Community Edition (static code analysis) with a PostgreSQL 15 database.

| Service | Image | Port | Data |
|---|---|---|---|
| `sonarqube` | `sonarqube:10-community` | `9000` | volumes `sonarqube_data`, `sonarqube_extensions`, `sonarqube_logs` |
| `db` | `postgres:15` | internal only | volume `postgres_data` |

## Usage

```bash
docker compose up -d
docker compose logs -f sonarqube      # wait for "SonarQube is operational"
```

Open <http://localhost:9000> and log in with the default `admin` / `admin` (SonarQube asks you to change the password on first login).

SonarQube runs Elasticsearch, which on Linux usually requires a higher limit on the host:

```bash
sudo sysctl -w vm.max_map_count=524288
```

### Analysing a project

Create a project and a token in the web UI, then run the scanner from the project directory:

```bash
docker run --rm --network host -v "$PWD:/usr/src" sonarsource/sonar-scanner-cli \
  -Dsonar.projectKey=my-project -Dsonar.host.url=http://localhost:9000 -Dsonar.token=<token>
```

## Notes

- The database connection is configured with `SONAR_JDBC_URL`, `SONAR_JDBC_USERNAME` and `SONAR_JDBC_PASSWORD` (the older `SONARQUBE_JDBC_*` names are not used by current images).
- The database credentials (`sonar` / `sonar`) are for local testing only.
