#!/bin/bash
# Czekaj, aż główny węzeł RabbitMQ będzie dostępny
sleep 10

# Uruchom RabbitMQ w tle
rabbitmq-server -detached

# Poczekaj, aż RabbitMQ się uruchomi
sleep 10

# Zatrzymaj aplikację na tym węźle, aby dołączyć do klastra
rabbitmqctl stop_app

# Dołącz do klastra (argument $1 to nazwa węzła głównego)
rabbitmqctl join_cluster $1

# Ponownie uruchom aplikację RabbitMQ na tym węźle
rabbitmqctl start_app

# Trzymaj kontener aktywnym
tail -f /dev/null

