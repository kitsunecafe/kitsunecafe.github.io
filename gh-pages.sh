#!/usr/bin/env bash

if [ -f ".env" ]; then
	source .env

  git subtree push --prefix dist origin gh-pages
	curl -u $GIT_USER:$GIT_TOKEN -X POST https://api.github.com/repos/$GIT_USER/$GIT_REPO/pages/builds
fi


