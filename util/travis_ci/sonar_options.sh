#!/bin/bash

if [ "$TRAVIS_PULL_REQUEST" = "false" ]; then
  echo -n ""
else
  PULL_REQUEST_NUM=$TRAVIS_PULL_REQUEST;
  echo -n "-Dsonar.pullrequest.key=$PULL_REQUEST_NUM -Dsonar.pullrequest.branch=$TRAVIS_PULL_REQUEST_BRANCH"
fi
