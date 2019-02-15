#!/bin/bash

if [ "$TRAVIS_PULL_REQUEST" = "false" ]; then
  BRANCH=$TRAVIS_BRANCH;
  GIT_COMMAND="git clone --depth=50 --branch=$BRANCH https://github.com/dynawo/dynawo.git dynawo"
  echo -n $GIT_COMMAND
else
  PULL_REQUEST_NUM=$TRAVIS_PULL_REQUEST;
  GIT_COMMAND="git clone --depth=50 https://github.com/dynawo/dynawo.git dynawo;cd dynawo;git fetch origin +refs/pull/$PULL_REQUEST_NUM/merge:;git checkout -qf FETCH_HEAD;"
  echo -n $GIT_COMMAND
fi
