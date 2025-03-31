#!/bin/bash
export DYNAWO_HOME=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# To launch in Jenkins without building OpenModelica each time
[ -z "$DYNAWO_SRC_OPENMODELICA" ] && export DYNAWO_SRC_OPENMODELICA=$DYNAWO_HOME/OpenModelica/Source.cvg
[ -z "$DYNAWO_INSTALL_OPENMODELICA" ] && export DYNAWO_INSTALL_OPENMODELICA=$DYNAWO_HOME/OpenModelica/Install.cvg

export DYNAWO_LOCALE=en_GB
export DYNAWO_RESULTS_SHOW=true
export DYNAWO_BROWSER=firefox

[ -z "$DYNAWO_NB_PROCESSORS_USED" ] && export DYNAWO_NB_PROCESSORS_USED=1

export DYNAWO_BUILD_TYPE=Release

export DYNAWO_BUILD_DIR=$DYNAWO_HOME/build/dynawo-interface/dynawo
export DYNAWO_INSTALL_DIR=$DYNAWO_HOME/install/dynawo-interface/dynawo
export DYNAWO_DEPLOY_DIR=$DYNAWO_HOME/deploy/dynawo-interface
export DYNAWO_THIRD_PARTY_BUILD_DIR=$DYNAWO_HOME/build/dynawo-interface/3rdParty
export DYNAWO_THIRD_PARTY_INSTALL_DIR=$DYNAWO_HOME/install/dynawo-interface/3rdParty

#export DYNAWO_BOOST_HOME=
#export DYNAWO_LIBARCHIVE_HOME=

$DYNAWO_HOME/util/envDynawo.sh $@
