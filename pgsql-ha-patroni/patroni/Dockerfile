FROM postgres:16-alpine

# Instalacja niezbędnych narzędzi i bibliotek dla Pythona oraz Patroni
RUN apk add --no-cache \
    python3 \
    py3-pip \
    py3-psycopg2 \
    py3-yaml \
    curl \
    gcc \
    python3-dev \
    musl-dev \
    libpq-dev \
    linux-headers

# Instalacja Patroni wraz z obsługą etcd3 oraz opcjonalnym cdiff przez pip
RUN pip install --no-cache-dir --break-system-packages "patroni[etcd3]" cdiff

# Przygotowanie katalogów i uprawnień
RUN mkdir -p /etc/patroni /var/lib/postgresql/data && \
    chown -R postgres:postgres /etc/patroni /var/lib/postgresql/data

USER postgres

EXPOSE 5432 8008

CMD ["patroni", "/etc/patroni/patroni.yml"]
