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

error_exit()
{
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

  if [  "$value" = UNDEFINED ]; then
    error_exit "You must define the value of $name"
  fi
  export $name="$value"
}

ADEPT_ARCHIVE=adept-1.1.tar.gz
ADEPT_DIRECTORY=adept-1.1
export_var_env ADEPT_DOWNLOAD_URL=http://www.met.reading.ac.uk/clouds/adept

HERE=$PWD

BUILD_DIR=$HERE
BUILD_TYPE=Debug

download_adept() {
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
  tar -xzf $ADEPT_ARCHIVE -C $BUILD_DIR
  cd $BUILD_DIR/$ADEPT_DIRECTORY
  if [ "$COMPILER" = "GCC" ]; then
    export CXXFLAGS_ADEPT=-Wall
  elif [ "$COMPILER" = "CLANG" ]; then
    export CXXFLAGS_ADEPT=-Weverything
  else
    error_exit "COMPILER environment variable needs to be GCC or CLANG."
  fi
  export CXXFLAGS_ADEPT="$CXXFLAGS_ADEPT $CXX_STDFLAG"
  if [ "${BUILD_TYPE}" = "Release" ]; then
      ./configure "CXXFLAGS=$CXXFLAGS_ADEPT -O3" --prefix=$INSTALL_DIR CC=$C_COMPILER CXX=$CXX_COMPILER --disable-openmp
  else
      ./configure "CXXFLAGS=$CXXFLAGS_ADEPT -g" --prefix=$INSTALL_DIR CC=$C_COMPILER CXX=$CXX_COMPILER --disable-openmp
  fi

  make && make install
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
