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

  if [  "$value" = UNDEFINED ]; then
    error_exit "You must define the value of $name"
  fi
  export $name="$value"
}

XERCESC_VERSION=3.2.2
XERCESC_ARCHIVE=xerces-c-${XERCESC_VERSION}.tar.gz
XERCESC_DIRECTORY=xerces-c-$XERCESC_VERSION
export_var_env XERCESC_DOWNLOAD_URL=http://archive.apache.org/dist/xerces/c/$(echo "$XERCESC_VERSION" | cut -d '.' -f 1)/sources

HERE=$PWD

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
BUILD_DIR=$HERE
BUILD_TYPE=Debug
INSTALL_DIR=$BUILD_DIR/$XERCESC_DIRECTORY/install
export_var_env C_COMPILER=$(command -v gcc)
export_var_env CXX_COMPILER=$(command -v g++)
export_var_env CXX11_ENABLED=NO
export_var_env NB_PROCESSORS_USED=1

export_var_env DYNAWO_LIBRARY_TYPE=SHARED

download_xercesc() {
  cd $SCRIPT_DIR
  if [ ! -f "${XERCESC_ARCHIVE}" ]; then
    if [ -x "$(command -v wget)" ]; then
      wget --timeout 10 --tries 3 ${XERCESC_DOWNLOAD_URL}/${XERCESC_ARCHIVE} || error_exit "Error while downloading Xerces-c."
    elif [ -x "$(command -v curl)" ]; then
      curl --connect-timeout 10 --retry 2 ${XERCESC_DOWNLOAD_URL}/${XERCESC_ARCHIVE} --output ${XERCESC_ARCHIVE} || error_exit "Error while downloading Xerces-c."
    else
      error_exit "You need to install either wget or curl."
    fi
  fi
}

install_xercesc() {
  cd $SCRIPT_DIR
  if [ ! -d "$BUILD_DIR/$XERCESC_DIRECTORY" ]; then
    tar -xzf $XERCESC_ARCHIVE -C $BUILD_DIR
  fi
  cd $BUILD_DIR/$XERCESC_DIRECTORY
  if [ "$DYNAWO_LIBRARY_TYPE" = "SHARED" ]; then
    XERCESC_LIBRARY_TYPE_OPTION="--disable-static --enable-shared"
  else
    XERCESC_LIBRARY_TYPE_OPTION="--enable-static --disable-shared"
  fi
  if [ "$(echo "$CXX11_ENABLED" | tr '[:upper:]' '[:lower:]')" = "yes" -o "$(echo "$CXX11_ENABLED" | tr '[:upper:]' '[:lower:]')" = "true" -o "$(echo "$CXX11_ENABLED" | tr '[:upper:]' '[:lower:]')" = "on" ]; then
    if [ "$BUILD_TYPE" = "Debug" ]; then
      CC=$C_COMPILER CXX=$CXX_COMPILER CXXFLAGS="-g -O0" ./configure $XERCESC_LIBRARY_TYPE_OPTION --prefix=$INSTALL_DIR
    else
      CC=$C_COMPILER CXX=$CXX_COMPILER ./configure $XERCESC_LIBRARY_TYPE_OPTION --prefix=$INSTALL_DIR
    fi
  else
    if [ "$BUILD_TYPE" = "Debug" ]; then
      CC=$C_COMPILER CXX=$CXX_COMPILER CXXFLAGS="-g -O0 -std=c++98" ./configure $XERCESC_LIBRARY_TYPE_OPTION --without-icu --disable-xmlch-char16_t --prefix=$INSTALL_DIR
    else
      CC=$C_COMPILER CXX=$CXX_COMPILER CXXFLAGS="-std=c++98" ./configure $XERCESC_LIBRARY_TYPE_OPTION --without-icu --disable-xmlch-char16_t --prefix=$INSTALL_DIR
    fi
  fi
  make -j $NB_PROCESSORS_USED V=1 && make install
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

download_xercesc || error_exit "Error while downloading Xerces-c."
install_xercesc || error_exit "Error while building Xerces-c."
