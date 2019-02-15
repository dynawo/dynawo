#!/bin/bash

if [ "$TRAVIS_BRANCH" = "master" -a "$TRAVIS_EVENT_TYPE" = "push" ]; then
  echo -n "cd dynawo;/opt/sonar/build-wrapper-linux-x86/build-wrapper-linux-x86-64 --out-dir bw-output ./util/envDynawo.sh build-tests-coverage;/opt/sonar/sonar-scanner-3.3.0.1492-linux/bin/sonar-scanner;"
elif [ "$TRAVIS_EVENT_TYPE" = "push" ]; then
  echo -n "cd dynawo;util/envDynawo.sh build-3rd-party-version;util/envDynawo.sh build-dynawo;"
elif [ "$TRAVIS_EVENT_TYPE" = "pull_request" ]; then
  PULL_REQUEST_NUM=$TRAVIS_PULL_REQUEST;
  SONAR_OPTIONS="-Dsonar.pullrequest.key=$PULL_REQUEST_NUM -Dsonar.pullrequest.branch=$TRAVIS_PULL_REQUEST_BRANCH -Dsonar.pullrequest.base=master -Donar.pullrequest.provider=github -Dsonar.pullrequest.github.repository=https://github.com/dynawo/dynawo"
  echo -n "cd dynawo;/opt/sonar/build-wrapper-linux-x86/build-wrapper-linux-x86-64 --out-dir bw-output ./util/envDynawo.sh build-tests-coverage;/opt/sonar/sonar-scanner-3.3.0.1492-linux/bin/sonar-scanner $SONAR_OPTIONS;"
else
  echo -n "exit 1"
fi
