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
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
#

error_exit() {
  echo "${1:-"Unknown Error"}" 1>&2
  exit -1
}

export_var_env() {
  var=$@
  name=${var%=*}
  value=${var##*=}

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

HERE=$PWD

SOURCE_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
BUILD_DIR=$HERE
INSTALL_DIR=$SOURCE_DIR/install
BUILD_TYPE=Debug
BOOST_INSTALL_DIR=""
export_var_env DYNAWO_C_COMPILER=$(command -v gcc)
export_var_env DYNAWO_CXX_COMPILER=$(command -v g++)
export_var_env DYNAWO_CXX11_ENABLED=NO
export_var_env DYNAWO_NB_PROCESSORS_USED=1

export_var_env DYNAWO_LIBRARY_TYPE=SHARED

install_libiidm() {
  cd $BUILD_DIR
  if [ ! -z "$BOOST_INSTALL_DIR" ]; then
    CMAKE_OPTIONNAL="-DBOOST_ROOT=$BOOST_INSTALL_DIR"
  else
    CMAKE_OPTIONNAL=""
  fi
  if [ "$DYNAWO_LIBRARY_TYPE" = "SHARED" ]; then
    IIDM_BUILD_SHARED=ON
  else
    IIDM_BUILD_SHARED=OFF
  fi
  cmake -DIIDM_BUILD_SHARED=$IIDM_BUILD_SHARED \
    -DBUILD_XML=ON \
    -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
    -DCMAKE_PREFIX_PATH=$LIBXML_INSTALL_DIR \
    -DCMAKE_BUILD_TYPE=$DYNAWO_BUILD_TYPE \
    -DCMAKE_C_COMPILER=$DYNAWO_C_COMPILER \
    -DCMAKE_CXX_COMPILER=$DYNAWO_CXX_COMPILER \
    -DCXX11_ENABLED=$DYNAWO_CXX11_ENABLED \
    $CMAKE_OPTIONNAL \
    $SOURCE_DIR
  make -j $DYNAWO_NB_PROCESSORS_USED && make install
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

while (($#)); do
  case $1 in
    --install-dir=*)
      INSTALL_DIR=`echo $1 | sed -e 's/--install-dir=//g'`
      if [ ! -d "$INSTALL_DIR" ]; then
        mkdir -p $INSTALL_DIR
      fi
      ;;
    --build-dir=*)
      BUILD_DIR=`echo $1 | sed -e 's/--build-dir=//g'`
      if [ ! -d "$BUILD_DIR" ]; then
        mkdir -p $BUILD_DIR
      fi
      ;;
    --build-type=*)
      BUILD_TYPE=`echo $1 | sed -e 's/--build-type=//g'`
      ;;
    --libxml-install-dir=*)
      LIBXML_INSTALL_DIR=`echo $1 | sed -e 's/--libxml-install-dir=//g'`
      ;;
    --boost-install-dir=*)
      BOOST_INSTALL_DIR=`echo $1 | sed -e 's/--boost-install-dir=//g'`
      ;;
    *)
      break
      ;;
  esac
  shift
done

if [ -z "$LIBXML_INSTALL_DIR" ]; then
  echo "Need to set LIBXML_INSTALL_DIR"
  exit 1
fi

install_libiidm || error_exit "Error while building libiidm"
