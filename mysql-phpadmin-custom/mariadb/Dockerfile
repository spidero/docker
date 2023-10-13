FROM mariadb:latest

COPY ./custom.sql /docker-entrypoint-initdb.d

CMD ["mariadbd"]