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

- **The compose file does not validate as it is.** Its first line `// sonar default login, pass: admin` is not a YAML comment; `docker compose config` fails with `additional properties '// sonar default login, pass' not allowed`. Change `//` to `#` before running.
- The database variables use the old `SONARQUBE_JDBC_*` names. Current images expect `SONAR_JDBC_URL`, `SONAR_JDBC_USERNAME` and `SONAR_JDBC_PASSWORD`; with the old names SonarQube may ignore PostgreSQL and fall back to its embedded test database (check the startup log).
- The database credentials (`sonar` / `sonar`) are for local testing only.
