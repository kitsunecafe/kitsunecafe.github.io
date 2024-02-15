#!/usr/bin/env bash

if [ -f ".env" ]; then
	source .env

  rm -rf "$OUT"
  git worktree add "$OUT" "$GH_PAGES_BRANCH"
  ./generate.sh
  (cd "$OUT"; git add -f .)
  (cd "$OUT"; git commit -m "Built from $(git log '--format=format:%H' main -1)")
  git push origin "$GH_PAGES_BRANCH"
  git worktree remove "$OUT"
fi


