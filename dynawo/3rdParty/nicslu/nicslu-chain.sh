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

NICSLU_ARCHIVE=_nicslu301.zip
NICSLU_DIR=_nicslu

HERE=$PWD

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
BUILD_DIR=$HERE
INSTALL_DIR=$HERE/install
BUILD_TYPE=Debug
export_var_env DYNAWO_C_COMPILER=$(command -v gcc)

export_var_env DYNAWO_LIBRARY_TYPE=SHARED

patch_nicslu() {
  cd $SCRIPT_DIR
  if [ -d "$BUILD_DIR" ]; then
    if [ ! -d "$BUILD_DIR/$NICSLU_DIR" ]; then
      if [ -x "$(command -v unzip)" ]; then
        unzip $NICSLU_ARCHIVE -d $BUILD_DIR
      else
        error_exit "You need to install unzip."
      fi
      patch -d $BUILD_DIR/$NICSLU_DIR -p1 < nicslu.patch
    fi
  fi
}

install_nicslu() {
  if [ -f "$SCRIPT_DIR/$NICSLU_ARCHIVE" ]; then
    patch_nicslu
    cd $BUILD_DIR/$NICSLU_DIR
    if [ "$DYNAWO_LIBRARY_TYPE" = "SHARED" ]; then
      if [ "${BUILD_TYPE}" = "Debug" ]; then
        make shared DEBUGFLAG="-g" OPTIMIZATION="-O0" CC=$DYNAWO_C_COMPILER || error_exit "Error while building Nicslu"
      else
        make shared CC=$DYNAWO_C_COMPILER || error_exit "Error while building Nicslu"
      fi
      cp lib/*.so $INSTALL_DIR/lib && cp util/*.so $INSTALL_DIR/lib || error_exit "Error while building Nicslu"
    elif [ "$DYNAWO_LIBRARY_TYPE" = "STATIC" ]; then
      if [ "${BUILD_TYPE}" = "Debug" ]; then
        make static DEBUGFLAG="-g" OPTIMIZATION="-O0" CC=$DYNAWO_C_COMPILER || error_exit "Error while building Nicslu"
      else
        make static CC=$DYNAWO_C_COMPILER || error_exit "Error while building Nicslu"
      fi
      cp lib/*.a $INSTALL_DIR/lib && cp util/*.a $INSTALL_DIR/lib || error_exit "Error while building Nicslu"
    else
      error_exit "Error while building Nicslu BUILD_TYPE is invalid"
    fi
    cp -R include $INSTALL_DIR || error_exit "Error while building Nicslu"
    cp util/nicslu_util.h $INSTALL_DIR/include || error_exit "Error while building Nicslu"
  else
    echo ""
    echo "You can download Nicslu from http://nicslu.weebly.com/ and copy/paste the zip obtained in $(pwd)."
    echo ""
  fi
}

while (($#)); do
  case $1 in
    --install-dir=*)
      INSTALL_DIR=$(get_absolute_path `echo $1 | sed -e 's/--install-dir=//g'`)
      if [ ! -d "$INSTALL_DIR/include" ]; then
        mkdir -p $INSTALL_DIR/include
      fi
      if [ ! -d "$INSTALL_DIR/lib" ]; then
        mkdir -p $INSTALL_DIR/lib
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

install_nicslu || error_exit "Error while building NICSLU"
