#!/usr/bin/env bash

if [ -f ".env" ]; then
  source .env
  rm -rf "${OUT}/*"
  ../roxy-cli/target/debug/roxy_cli ${IN} ${OUT}
  echo "$CNAME" > "${OUT}/CNAME"
fi


