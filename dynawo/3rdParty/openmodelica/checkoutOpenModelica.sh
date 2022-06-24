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
  echo "${1:-"Unknown Error"}" 1>&2
  exit 1
}

export_var_env() {
  var=$@
  name=${var%%=*}
  value=${var#*=}

  if eval "[ \$$name ]"; then
    eval "value=\${$name}"
    ##echo "Environment variable for $name already set : $value"
    return
  fi

  if [ "$value" = UNDEFINED ]; then
    error_exit "You must define the value of $name"
  fi
  export $name="$value"
}

# Default values
SRC_OPENMODELICA=""
OPENMODELICA_VERSION=""
export_var_env DYNAWO_OPENMODELICA_GIT_URL=https://github.com/OpenModelica/OpenModelica.git

while (($#)); do
  case $1 in
    --openmodelica-dir=*)
      SRC_OPENMODELICA=`echo $1 | sed -e 's/--openmodelica-dir=//g'`
      ;;
    --openmodelica-version=*)
      OPENMODELICA_VERSION=`echo $1 | sed -e 's/--openmodelica-version=//g'`
      ;;
    *)
      break
      ;;
  esac
  shift
done

check_configuration() {
  if [ -z "$SRC_OPENMODELICA" ]; then
    error_exit "You need to give a source directory for OpenModelica with --openmodelica-dir option."
  fi
  if [ -z "$OPENMODELICA_VERSION" ]; then
    error_exit "You need to give a version of OpenModelica to checkout with --openmodelica-version option, for example 1.9.3."
  fi
}

check_tag_openmodelica() {
  if [ -d "$SRC_OPENMODELICA" ]; then
    pushd "$SRC_OPENMODELICA" > /dev/null
    last_log_openmodelica=$(git log -1 --decorate | grep -o "tag: v${OPENMODELICA_VERSION}")
    popd > /dev/null
    if [ "$last_log_openmodelica" != "tag: v${OPENMODELICA_VERSION}" ]; then
      return 1
    fi
  else
    error_exit "$SRC_OPENMODELICA folder does not exist."
  fi
}

check_tag_omcompiler() {
  if [ -d "$SRC_OPENMODELICA/OMCompiler" ]; then
    pushd "$SRC_OPENMODELICA/OMCompiler" > /dev/null
    last_log_omcompiler=$(git log -1 --decorate | grep -o "tag: v${OPENMODELICA_VERSION}")
    popd > /dev/null
    if [ "$last_log_omcompiler" != "tag: v${OPENMODELICA_VERSION}" ]; then
      return 1
    fi
  else
    error_exit "$SRC_OPENMODELICA/OMCompiler folder does not exist."
  fi
}

check_tags() {
  check_tag_openmodelica || return 1
  check_tag_omcompiler || return 1
}

checkout_openmodelica_repository() {
echo "BUBU?? "
  rmdir $SRC_OPENMODELICA || echo "$SRC_OPENMODELICA folder was not empty it was already checkout."
  if [ ! -d "$SRC_OPENMODELICA" ]; then
    git clone $DYNAWO_OPENMODELICA_GIT_URL $SRC_OPENMODELICA --recursive || error_exit "Git clone of OpenModelica in $SRC_OPENMODELICA failed."
    if [ -d "$SRC_OPENMODELICA" ]; then
      pushd "$SRC_OPENMODELICA" > /dev/null
      git checkout tags/v${OPENMODELICA_VERSION} || error_exit "Git checkout tags/v${OPENMODELICA_VERSION} failed for OpenModelica in $SRC_OPENMODELICA."
      git submodule update --force --init --recursive
      popd > /dev/null
      check_tag_openmodelica || error_exit "OpenModelica needs to be in version ${OPENMODELICA_VERSION}."
      check_tag_omcompiler || error_exit "OpenModelica Compiler needs to be in version ${OPENMODELICA_VERSION}."
    fi
  fi
}

check_configuration
checkout_openmodelica_repository
