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

get_absolute_path() {
  python -c "import os; print(os.path.realpath('$1'))"
}

HERE=$PWD

SOURCE_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
BUILD_DIR=$HERE
INSTALL_DIR=$SOURCE_DIR/install
BUILD_TYPE=Debug
BOOST_INSTALL_DIR=""
GTEST_INSTALL_DIR=""
export_var_env DYNAWO_C_COMPILER=$(command -v gcc)
export_var_env DYNAWO_CXX_COMPILER=$(command -v g++)
export_var_env DYNAWO_CXX11_ENABLED=NO
export_var_env DYNAWO_NB_PROCESSORS_USED=1

export_var_env DYNAWO_LIBRARY_TYPE=SHARED

install_libxml() {
  cd $BUILD_DIR
  CMAKE_OPTIONNAL=""
  if [ ! -z "$BOOST_INSTALL_DIR" ]; then
    CMAKE_OPTIONNAL="-DBOOST_ROOT=$BOOST_INSTALL_DIR"
  fi
  if [ ! -z "$GTEST_INSTALL_DIR" ]; then
    CMAKE_OPTIONNAL="$CMAKE_OPTIONNAL -DGTEST_ROOT=$GTEST_INSTALL_DIR"
  fi
  if [ "$BUILD_TYPE" = "Release" ]; then
    CMAKE_OPTIONNAL="$CMAKE_OPTIONNAL -DLibXML_BUILD_TESTS=OFF -DLibXML_SAX_BUILD_SAMPLES=OFF"
  fi
  if [ "$DYNAWO_LIBRARY_TYPE" = "SHARED" ]; then
    XML_LIBRARY_TYPE_SHARED=TRUE
    XML_LIBRARY_TYPE_STATIC=FALSE
  else
    XML_LIBRARY_TYPE_SHARED=FALSE
    XML_LIBRARY_TYPE_STATIC=TRUE
  fi
  cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
    -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
    -DCMAKE_C_COMPILER=$DYNAWO_C_COMPILER \
    -DCMAKE_CXX_COMPILER=$DYNAWO_CXX_COMPILER \
    -DCXX11_ENABLED=$DYNAWO_CXX11_ENABLED \
    -DXERCESC_HOME=$XERCESC_INSTALL_DIR \
    -DLibXML_SAX_BUILD_SHARED=$XML_LIBRARY_TYPE_SHARED \
    -DLibXML_SAX_BUILD_STATIC=$XML_LIBRARY_TYPE_STATIC \
    $CMAKE_OPTIONNAL \
    $SOURCE_DIR
  make -j $DYNAWO_NB_PROCESSORS_USED && make install
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

while (($#)); do
  case $1 in
    --install-dir=*)
      INSTALL_DIR=$(get_absolute_path `echo $1 | sed -e 's/--install-dir=//g'`)
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
    --xercesc-install-dir=*)
      XERCESC_INSTALL_DIR=$(get_absolute_path `echo $1 | sed -e 's/--xercesc-install-dir=//g'`)
      ;;
    --boost-install-dir=*)
      BOOST_INSTALL_DIR=$(get_absolute_path `echo $1 | sed -e 's/--boost-install-dir=//g'`)
      ;;
    --gtest-install-dir=*)
      GTEST_INSTALL_DIR=$(get_absolute_path `echo $1 | sed -e 's/--gtest-install-dir=//g'`)
      ;;
    *)
      break
      ;;
  esac
  shift
done

if [ -z "$XERCESC_INSTALL_DIR" ]; then
  echo "Need to set XERCESC_INSTALL_DIR"
  exit 1
fi

install_libxml || error_exit "Error while building libxml"
