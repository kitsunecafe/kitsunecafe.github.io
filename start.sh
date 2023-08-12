#!/usr/bin/env bash

terminate() {
  pkill -9 -P "$build" > /dev/null
}

trap terminate SIGHUP SIGINT SIGQUIT SIGTERM

./inotify.sh "./generate.sh" &
build=$!
./generate.sh
cd ../kitsu.cafe/
python3 -m http.server

