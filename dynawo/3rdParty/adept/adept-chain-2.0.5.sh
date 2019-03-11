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

ADEPT_VERSION=2.0.5
ADEPT_ARCHIVE=adept-$ADEPT_VERSION.tar.gz
ADEPT_DIRECTORY=adept-$ADEPT_VERSION
export_var_env ADEPT_DOWNLOAD_URL=http://www.met.reading.ac.uk/clouds/adept

HERE=$PWD

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
BUILD_DIR=$HERE
BUILD_TYPE=Debug
INSTALL_DIR=$BUILD_DIR/$ADEPT_DIRECTORY/install

export_var_env COMPILER=GCC
export_var_env C_COMPILER=$(command -v gcc)
export_var_env CXX_COMPILER=$(command -v g++)
export_var_env NB_PROCESSORS_USED=1

if [ "$(echo $COMPILER | tr "[A-Z]" "[a-z]")" != "$(basename $C_COMPILER)" ]; then
  echo "There is an incoherence between COMPILER and C_COMPILER. You should export COMPILER with the appropriate value (GCC or CLANG)."
  exit 1
fi

export_var_env DYNAWO_LIBRARY_TYPE=SHARED

download_adept() {
  cd $SCRIPT_DIR
  if [ ! -f "${ADEPT_ARCHIVE}" ]; then
    if [ -x "$(command -v wget)" ]; then
      wget --timeout 10 --tries 3 ${ADEPT_DOWNLOAD_URL}/${ADEPT_ARCHIVE} || error_exit "Error while downloading Adept."
    elif [ -x "$(command -v curl)" ]; then
      curl --connect-timeout 10 --retry 2 ${ADEPT_DOWNLOAD_URL}/${ADEPT_ARCHIVE} --output ${ADEPT_ARCHIVE} || error_exit "Error while downloading Adept."
    else
      error_exit "You need to install either wget or curl."
    fi
  fi
}

install_adept() {
  cd $SCRIPT_DIR
  if [ ! -d "$BUILD_DIR/$ADEPT_DIRECTORY" ]; then
    tar -xzf $ADEPT_ARCHIVE -C $BUILD_DIR
  fi
  cd $BUILD_DIR/$ADEPT_DIRECTORY
  if [ "$COMPILER" = "GCC" ]; then
    CXXFLAGS_ADEPT=-Wall
  elif [ "$COMPILER" = "CLANG" ]; then
    CXXFLAGS_ADEPT=-Weverything
  else
    error_exit "COMPILER environment variable needs to be GCC or CLANG."
  fi
  export CXXFLAGS_ADEPT="$CXXFLAGS_ADEPT $CXX_STDFLAG -fPIC"
  if [ "$DYNAWO_LIBRARY_TYPE" = "SHARED" ]; then
    ADEPT_LIBRARY_TYPE_OPTION="--disable-static --enable-shared"
  else
    ADEPT_LIBRARY_TYPE_OPTION="--enable-static --disable-shared"
  fi
  if [ "${BUILD_TYPE}" = "Release" ]; then
    ./configure "CXXFLAGS=$CXXFLAGS_ADEPT -O3" --prefix=$INSTALL_DIR CC=$C_COMPILER CXX=$CXX_COMPILER --disable-openmp $ADEPT_LIBRARY_TYPE_OPTION
  else
    ./configure "CXXFLAGS=$CXXFLAGS_ADEPT -g -O0" --prefix=$INSTALL_DIR CC=$C_COMPILER CXX=$CXX_COMPILER --disable-openmp $ADEPT_LIBRARY_TYPE_OPTION
  fi
  make -j $NB_PROCESSORS_USED && make install
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
    *)
      break
      ;;
  esac
  shift
done

download_adept || error_exit "Error while downloading Adept"
install_adept || error_exit "Error while building Adept"
