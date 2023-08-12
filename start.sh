#!/usr/bin/env bash

terminate() {
  pkill -9 -P "$build" > /dev/null
}

if [ -f ".env" ]; then
  source .env
  trap terminate SIGHUP SIGINT SIGQUIT SIGTERM

  ./inotify.sh "./generate.sh" &
  build=$!
  ./generate.sh
  cd "$DIST"
  python3 -m http.server
fi

