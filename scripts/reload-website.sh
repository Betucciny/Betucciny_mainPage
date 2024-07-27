#!/usr/bin/env bash

git pull
BUILD_VERSION=$(git rev-parse HEAD)

echo "$(date --utc +%FT%TZ): Releasing new version $BUILD_VERSION"

echo "$(date --utc +%FT%TZ): Running build..."
docker-compose rm -f
docker-compose build

OLD_CONTAINER=$(docker ps -aqf "name=astro-app")
echo "$(date --utc +%FT%TZ): Scaling server up..."
BUILD_VERSION=$BUILD_VERSION docker-compose up -d --no-deps --scale astro-app=2 --no-recreate astro-app

sleep 30

echo "$(date --utc +%FT%TZ): Scaling server down..."
docker container rm -f $OLD_CONTAINER
docker-compose up -d --no-deps --scale astro-app=1 --no-recreate astro-app

echo "$(date --utc +%FT%TZ): Reloading caddy..."
CADDY_CONTAINER=$(docker ps -aqf "name=caddy")
docker exec $CADDY_CONTAINER caddy reload -c /etc/caddy/Caddyfile