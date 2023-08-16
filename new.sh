#!/usr/bin/env bash

function to_slug() {
  echo "$1" \
  | iconv -t ascii//TRANSLIT \
  | sed -r s/[^a-zA-Z0-9]+/-/g \
  | sed -r s/^-+\|-+$//g \
  | tr A-Z a-z
}

function count_posts() {
  dir_count=$(find $(echo "$1/*") -maxdepth 0 -type d | wc -l)
  md_count=$(find $(echo "$1/*.md") -maxdepth 0 -type f | wc -l)
  echo "$(($dir_count + $md_count))"
}

CONTENT_DIR="${1:-.}"
POST_COUNT=$(count_posts "$CONTENT_DIR")
DEFAULT_TITLE=$"New post ${POST_COUNT}"
TITLE="${2:-$DEFAULT_TITLE}"
SLUG=$(to_slug "$TITLE")
DATE=$(date +"%FT%H:%M:%S")

DIR="$CONTENT_DIR/$SLUG"
mkdir -p "$DIR"

cat << EOF |
title: $TITLE
date: $DATE
---
# $TITLE
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas malesuada tempus venenatis.

EOF
awk '{print}' > "$DIR/index.md"

echo "Created ${DIR}/index.md"

