#!/usr/bin/env bash

echo "$(date --utc +%FT%TZ): Fetching remote repository..."
git fetch

UPSTREAM=${1:-'@{u}'}
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse "$UPSTREAM")
BASE=$(git merge-base @ "$UPSTREAM")

if [ $LOCAL = $REMOTE ]; then
    echo "$(date --utc +%FT%TZ): Up-to-date"
elif [ $LOCAL = $BASE ]; then
    echo "$(date --utc +%FT%TZ): Changes detected, deploying new version..."
    ./reload-website.sh
elif [ $REMOTE = $BASE ]; then
    echo "$(date --utc +%FT%TZ): Local changes detected, stashing..."
    git stash
    ./reload-Website.sh
else
    echo "$(date --utc +%FT%TZ): Git is diverged, aborting..."
fi