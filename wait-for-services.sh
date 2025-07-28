#!/bin/sh
set -e

echo "Waiting for MySQL to be ready..."
while ! nc -z mysql 3306; do
    sleep 1
done
echo "MySQL is ready!"

echo "Waiting for Redis to be ready..."
while ! nc -z redis 6379; do
    sleep 1
done
echo "Redis is ready!"

echo "Starting application..."
exec java org.springframework.boot.loader.launch.JarLauncher
