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

NICSLU_ARCHIVE=_nicslu301.zip
NICSLU_DIR=_nicslu

HERE=$PWD

BUILD_DIR=$HERE
export INSTALL_LIB=$HERE/lib
export INSTALL_INCLUDE=$HERE/include

patch_nicslu() {
  if [ -d "$BUILD_DIR" ]; then
    if [ -z "$(ls -A $BUILD_DIR)" ]; then # If directory is empty
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
  if [ -f "$NICSLU_ARCHIVE" ]; then
    patch_nicslu
    cd $BUILD_DIR/$NICSLU_DIR
    if [ "${BUILD_TYPE}" = "Debug" ]; then
      make DEBUGFLAG="-g" OPTIMIZATION="" || error_exit "Error while building Nicslu"
    else
      make || error_exit "Error while building Nicslu"
    fi
    cp -R include $INSTALL_DIR || error_exit "Error while building Nicslu"
    cp lib/*.so $INSTALL_LIB && cp util/*.so $INSTALL_LIB || error_exit "Error while building Nicslu"
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
        mkdir -p $INSTALL_DIR
        mkdir -p $INSTALL_DIR/include
        mkdir -p $INSTALL_DIR/lib
      fi
      export INSTALL_LIB=$INSTALL_DIR/lib
      export INSTALL_INCLUDE=$INSTALL_DIR/include
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

install_nicslu || error_exit "Error while building NICSLU suite"
