#!/bin/bash

if [ "$TRAVIS_BRANCH" = "master" -a "$TRAVIS_EVENT_TYPE" = "push" ]; then
  echo -n "export DYNAWO_BUILD_TYPE=TestCoverage;export DYNAWO_RESULTS_SHOW="false";cd dynawo;export DYNAWO_THIRD_PARTY_INSTALL_DIR=/opt/dynawo/3rParty;/opt/sonar/build-wrapper-linux-x86/build-wrapper-linux-x86-64 --out-dir bw-output ./util/envDynawo.sh build-tests-coverage;RETURN_CODE=\$?;if [ \${RETURN_CODE} -ne 0 ]; then exit \${RETURN_CODE}; fi;/opt/sonar/sonar-scanner-3.3.0.1492-linux/bin/sonar-scanner;RETURN_CODE=\$?;if [ \${RETURN_CODE} -ne 0 ]; then exit \${RETURN_CODE}; fi;util/envDynawo.sh build-dynawo-models;"
elif [ "$TRAVIS_EVENT_TYPE" = "push" ]; then
  echo -n "cd dynawo;util/envDynawo.sh build-3rd-party;RETURN_CODE=\$?;if [ \${RETURN_CODE} -ne 0 ]; then exit \${RETURN_CODE}; fi;util/envDynawo.sh build-dynawo;"
elif [ "$TRAVIS_EVENT_TYPE" = "pull_request" ]; then
  PULL_REQUEST_NUM=$TRAVIS_PULL_REQUEST;
  SONAR_OPTIONS="-Dsonar.pullrequest.key=$PULL_REQUEST_NUM -Dsonar.pullrequest.branch=$TRAVIS_PULL_REQUEST_BRANCH -Dsonar.pullrequest.base=master -Donar.pullrequest.provider=GitHub -Dsonar.pullrequest.github.repository=dynawo/dynawo -Dsonar.pullrequest.github.endpoint=https://api.github.com/ -Dsonar.pullrequest.github.token.secured=$GITHUB_ACCESS_TOKEN"
  echo -n "export DYNAWO_RESULTS_SHOW="false";cd dynawo;/opt/sonar/build-wrapper-linux-x86/build-wrapper-linux-x86-64 --out-dir bw-output ./util/envDynawo.sh build-tests-coverage;RETURN_CODE=\$?;if [ \${RETURN_CODE} -ne 0 ]; then exit \${RETURN_CODE}; fi;/opt/sonar/sonar-scanner-3.3.0.1492-linux/bin/sonar-scanner $SONAR_OPTIONS;"
else
  echo -n "exit 1"
fi
