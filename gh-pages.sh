#!/usr/bin/env bash

if [ -f ".env" ]; then
	source .env

  (cd "$DIST"; git add .)
  (cd "$DIST"; git commit -m "Built from $(git log '--format=format:%H' main -1)")
  git push origin "$GH_PAGES_BRANCH"
fi


