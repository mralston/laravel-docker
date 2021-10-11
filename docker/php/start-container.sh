#!/bin/bash

if [ "$CONTAINER_ROLE" = "php" ]; then
    php-fpm
elif [ "$CONTAINER_ROLE" = "queue" ]; then
    php artisan horizon
elif [ "$CONTAINER_ROLE" = "scheduler" ]; then
  while [ true ]
    do
      php artisan schedule:run --verbose --no-interaction &
      sleep 60
    done
else
    echo CONTAINER_ROLE not recognised!
    echo Check environment variable in docker-compose.yml.
fi
