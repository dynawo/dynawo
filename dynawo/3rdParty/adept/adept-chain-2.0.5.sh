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

ADEPT_VERSION=2.0.5
ADEPT_ARCHIVE=adept-$ADEPT_VERSION.tar.gz
ADEPT_DIRECTORY=adept-$ADEPT_VERSION
export_var_env DYNAWO_ADEPT_DOWNLOAD_URL=http://www.met.reading.ac.uk/clouds/adept

HERE=$PWD

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
BUILD_DIR=$HERE
BUILD_TYPE=Debug
INSTALL_DIR=$BUILD_DIR/$ADEPT_DIRECTORY/install

export_var_env DYNAWO_C_COMPILER=$(command -v gcc)
export_var_env DYNAWO_CXX_COMPILER=$(command -v g++)
export_var_env DYNAWO_NB_PROCESSORS_USED=1
export_var_env DYNAWO_CXX11_ENABLED=NO

export_var_env DYNAWO_LIBRARY_TYPE=SHARED

download_adept() {
  cd $SCRIPT_DIR
  if [ ! -f "${ADEPT_ARCHIVE}" ]; then
    if [ -x "$(command -v wget)" ]; then
      wget --timeout 10 --tries 3 ${DYNAWO_ADEPT_DOWNLOAD_URL}/${ADEPT_ARCHIVE} || error_exit "Error while downloading Adept."
    elif [ -x "$(command -v curl)" ]; then
      curl --connect-timeout 10 --retry 2 ${DYNAWO_ADEPT_DOWNLOAD_URL}/${ADEPT_ARCHIVE} --output ${ADEPT_ARCHIVE} || error_exit "Error while downloading Adept."
    else
      error_exit "You need to install either wget or curl."
    fi
  fi
}

patch_adept() {
  cd $SCRIPT_DIR
  if [ ! -d "$BUILD_DIR/$ADEPT_DIRECTORY" ]; then
    tar -xzf $ADEPT_ARCHIVE -C $BUILD_DIR
    patch -d $BUILD_DIR -p0 < adept-${ADEPT_VERSION}.patch
  fi
}

install_adept() {
  patch_adept

  cd $SCRIPT_DIR
  if [ ! -d "$BUILD_DIR/$ADEPT_DIRECTORY" ]; then
    tar -xzf $ADEPT_ARCHIVE -C $BUILD_DIR
  fi
  cd $BUILD_DIR/$ADEPT_DIRECTORY
  if [ "$DYNAWO_LIBRARY_TYPE" = "SHARED" ]; then
    ADEPT_LIBRARY_TYPE_OPTION="--disable-static --enable-shared"
  else
    ADEPT_LIBRARY_TYPE_OPTION="--enable-static --disable-shared"
  fi
  CXX_STD=""
  if [ "$(echo "$DYNAWO_CXX11_ENABLED" | tr '[:upper:]' '[:lower:]')" = "no" -o "$(echo "$DYNAWO_CXX11_ENABLED" | tr '[:upper:]' '[:lower:]')" = "false" -o "$(echo "$DYNAWO_CXX11_ENABLED" | tr '[:upper:]' '[:lower:]')" = "off" ]; then
    CXX_STD="-std=c++98"
  fi
  if [ "$BUILD_TYPE" = "Debug" ]; then
    ./configure "CXXFLAGS=-g -O0 -fPIC $CXX_STD" --prefix=$INSTALL_DIR CC=$DYNAWO_C_COMPILER CXX=$DYNAWO_CXX_COMPILER --disable-openmp $ADEPT_LIBRARY_TYPE_OPTION
  else
    ./configure "CXXFLAGS=-O3 -fPIC $CXX_STD" --prefix=$INSTALL_DIR CC=$DYNAWO_C_COMPILER CXX=$DYNAWO_CXX_COMPILER --disable-openmp $ADEPT_LIBRARY_TYPE_OPTION
  fi
  make -j $DYNAWO_NB_PROCESSORS_USED && make install && if [ "$DYNAWO_LIBRARY_TYPE" = "SHARED" -a "`uname`" = "Darwin" ]; then install_name_tool -id @rpath/libadept.dylib $INSTALL_DIR/lib/libadept.dylib; fi
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
    *)
      break
      ;;
  esac
  shift
done

download_adept || error_exit "Error while downloading Adept"
install_adept || error_exit "Error while building Adept"
