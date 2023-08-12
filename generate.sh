#!/usr/bin/env bash

if [ -f ".env" ]; then
  source .env
  rm -rf "${DIST}/*"
  mkdir -p "${DIST}/public/"
  ../roxy2/target/debug/roxy -o "${DIST}" -t Flatron.tmTheme
  cp -r ./static/* "${DIST}/public/"
  echo "$CNAME" > "${DIST}/CNAME"
fi


