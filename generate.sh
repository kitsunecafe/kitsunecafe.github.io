#!/usr/bin/env bash

if [ -f ".env" ]; then
  source .env
  rm -rf "${DIST}/*"
  mkdir -p "${DIST}/"
  ../roxy/target/debug/roxy -o "${DIST}" -t Flatron.tmTheme
  cp -r ./static/* "${DIST}/"
  echo "$CNAME" > "${DIST}/CNAME"
fi


