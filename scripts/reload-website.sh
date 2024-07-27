#!/usr/bin/env bash

git pull
BUILD_VERSION=$(git rev-parse HEAD)

echo "$(date --utc +%FT%TZ): Releasing new version $BUILD_VERSION"

echo "$(date --utc +%FT%TZ): Running build..."
sudo docker compose rm -f
sudo docker compose build

OLD_CONTAINER=$(sudo docker ps -aqf "name=astro-app")
echo "$(date --utc +%FT%TZ): Scaling server up..."
BUILD_VERSION=$BUILD_VERSION sudo docker compose up -d --no-deps --scale astro-app=2 --no-recreate astro-app

sleep 30

echo "$(date --utc +%FT%TZ): Scaling server down..."
sudo docker container rm -f $OLD_CONTAINER
sudo docker compose up -d --no-deps --scale astro-app=1 --no-recreate astro-app

echo "$(date --utc +%FT%TZ): Reloading caddy..."
CADDY_CONTAINER=$(sudo docker ps -aqf "name=caddy")
sudo                        docker exec $CADDY_CONTAINER caddy reload -c /etc/caddy/Caddyfile