#!/usr/bin/env bash

rm -rf ../kitsu.cafe/*
mkdir -p ../kitsu.cafe/public/
../roxy2/target/debug/roxy -o ../kitsu.cafe/ -t Flatron.tmTheme
cp -r ./static/* ../kitsu.cafe/public/

