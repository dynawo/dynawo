#!/bin/bash
#
# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain
# simulation tool for power systems.
#

error_exit() {
  RETURN_CODE=$?
  echo "${1:-"Unknown Error"}" 1>&2
  exit ${RETURN_CODE}
}

export_var_env() {
  var=$@
  name=${var%%=*}
  value=${var#*=}

  if eval "[ \$$name ]"; then
    eval "value=\${$name}"
    return
  fi
  export $name="$value"
}

usage="Usage: `basename $0` [option] -- program to deal with Dynawo

where [option] can be:
    jobs ([args])              call Dynawo's launcher with given arguments setting LD_LIBRARY_PATH correctly
    version                    show dynawo version
    help                       show this message"

set_environment() {
  export_var_env DYNAWO_INSTALL_DIR=$(dirname $(dirname $(python -c "import os; print(os.path.realpath('$0'))")))

  export LD_LIBRARY_PATH=$DYNAWO_INSTALL_DIR/lib:$LD_LIBRARY_PATH

  export_var_env DYNAWO_INSTALL_OPENMODELICA=$DYNAWO_INSTALL_DIR/OpenModelica
  omc_version=$($DYNAWO_INSTALL_OPENMODELICA/bin/omcDynawo --version | cut -d v -f 2)
  export_var_env DYNAWO_OPENMODELICA_VERSION=${omc_version//./_}

  export_var_env DYNAWO_ADEPT_INSTALL_DIR=$DYNAWO_INSTALL_DIR
  export_var_env DYNAWO_SUITESPARSE_INSTALL_DIR=$DYNAWO_INSTALL_DIR
  export_var_env DYNAWO_SUNDIALS_INSTALL_DIR=$DYNAWO_INSTALL_DIR
  export_var_env DYNAWO_LIBIIDM_INSTALL_DIR=$DYNAWO_INSTALL_DIR

  export_var_env DYNAWO_LOCALE=en_GB
  export_var_env DYNAWO_USE_XSD_VALIDATION=false

  export PATH=$DYNAWO_INSTALL_OPENMODELICA/bin:$PATH
  export PATH=$DYNAWO_INSTALL_DIR/sbin:$PATH
}

jobs() {
  set_environment

  # launch dynawo
  $DYNAWO_INSTALL_DIR/bin/launcher $@
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

if [ $# -eq 0 ]; then
  echo "$usage"
  exit 1
fi

while (($#)); do
  case $1 in
    jobs)
      shift
      jobs $@ || error_exit "Dynawo execution failed"
      break
      ;;
    version)
      jobs --version
      break
      ;;
    help)
      echo "$usage"
      break
      ;;
    *)
      echo "$1 is an invalid option"
      echo "$usage"
      break
      ;;
  esac
done
