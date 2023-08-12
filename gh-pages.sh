#!/usr/bin/env bash

if [ -f ".env" ]; then
	source .env

  
	git add -f $DIST
	git commit -m "updating gh-pages $(date)"
	git push
	curl -u $GIT_USER:$GIT_TOKEN -X POST https://api.github.com/repos/$GIT_USER/$GIT_REPO/pages/builds
fi


