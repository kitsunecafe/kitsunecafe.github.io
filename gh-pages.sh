#!/usr/bin/env bash

if [ -f ".env" ]; then
	source .env

  rm -rf "$DIST"
  git worktree add "$DIST" "$GH_PAGES_BRANCH"
  ./generate.sh
  (cd "$DIST"; git add -f .)
  (cd "$DIST"; git commit -m "Built from $(git log '--format=format:%H' main -1)")
  git push origin "$GH_PAGES_BRANCH"
  git worktree remove "$DIST"
fi


