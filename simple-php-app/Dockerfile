FROM php:apache

RUN apt-get update && apt-get upgrade -y && \
    apt-get autoremove -y && apt-get clean

COPY index.php /var/www/html/

USER www-data

EXPOSE 80

