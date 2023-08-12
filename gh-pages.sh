#!/usr/bin/env bash

if [ -f ".env" ]; then
	source .env

  #git worktree add "$DIST" "$GH_PAGES_BRANCH"
  #./generate.sh
  (cd "$DIST"; git add .)
  (cd "$DIST"; git commit -m "Built at $(date -R)")
  git push origin "$GH_PAGES_BRANCH"
fi


