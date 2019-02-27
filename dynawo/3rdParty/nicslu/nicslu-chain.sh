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

  if [  "$value" = UNDEFINED ]; then
  	error_exit "You must define the value of $name"
  fi
  export $name="$value"
}

NICSLU_ARCHIVE=_nicslu301.zip
NICSLU_DIR=_nicslu

HERE=$PWD

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
BUILD_DIR=$HERE
INSTALL_DIR=$HERE/install
export_var_env C_COMPILER=$(command -v gcc)
export_var_env NB_PROCESSORS_USED=1

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
        make -j $NB_PROCESSORS_USED shared DEBUGFLAG="-g" OPTIMIZATION="" || error_exit "Error while building Nicslu"
      else
        make -j $NB_PROCESSORS_USED shared || error_exit "Error while building Nicslu"
      fi
      cp -R include $INSTALL_DIR || error_exit "Error while building Nicslu"
      cp util/nicslu_util.h $INSTALL_DIR/include || error_exit "Error while building Nicslu"
      cp lib/*.so $INSTALL_DIR/lib && cp util/*.so $INSTALL_DIR/lib || error_exit "Error while building Nicslu"
    else
      if [ "${BUILD_TYPE}" = "Debug" ]; then
        make -j $NB_PROCESSORS_USED static DEBUGFLAG="-g" OPTIMIZATION="" || error_exit "Error while building Nicslu"
      else
        make -j $NB_PROCESSORS_USED static || error_exit "Error while building Nicslu"
      fi
      cp -R include $INSTALL_DIR || error_exit "Error while building Nicslu"
      cp util/nicslu_util.h $INSTALL_DIR/include || error_exit "Error while building Nicslu"
      cp lib/*.a $INSTALL_DIR/lib && cp util/*.a $INSTALL_DIR/lib || error_exit "Error while building Nicslu"
    fi
  else
    echo ""
    echo "You can download Nicslu from http://nicslu.weebly.com/ and copy/paste the zip obtained in $(pwd)."
    echo ""
  fi
}

while (($#)); do
  case $1 in
    --install-dir=*)
	    INSTALL_DIR=`echo $1 | sed -e 's/--install-dir=//g'`
      if [ ! -d "$INSTALL_DIR" ]; then
        mkdir -p $INSTALL_DIR/include
        mkdir -p $INSTALL_DIR/lib
      fi
      break
      ;;
    --build-dir=*)
	    BUILD_DIR=`echo $1 | sed -e 's/--build-dir=//g'`
      if [ ! -d "$BUILD_DIR" ]; then
        mkdir -p $BUILD_DIR
      fi
      ;;
    *)
      break
      ;;
  esac
  shift
done

install_nicslu || error_exit "Error while building NICSLU"
