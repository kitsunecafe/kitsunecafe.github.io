#!/usr/bin/env bash

if [ -f ".env" ]; then
  source .env

  if [ -z "$(which inotifywait)" ]; then
      echo "inotifywait not installed."
      echo "In most distros, it is available in the inotify-tools package."
      exit 1
  fi
   
  counter=0;
   
  function execute() {
      counter=$((counter+1))
      echo "Detected change n. $counter" 
      "$@"
  }
   
  inotifywait --recursive --monitor --format "%e %w%f" \
  --event modify,move,create,delete --exclude "$OUT" ./ \
  | while read changed; do
      echo $changed
      "$@"
  done
fi
