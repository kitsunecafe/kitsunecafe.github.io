#!/usr/bin/env bash

dist="./dist"
rm -rf "${dist}/*"
mkdir -p "${dist}/public/"
../roxy2/target/debug/roxy -o "${dist}" -t Flatron.tmTheme
cp -r ./static/* "${dist}/public/"
echo "kitsu.cafe" > "${dist}/CNAME"

