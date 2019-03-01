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

SUITE_SPARSE_VERSION=4.5.4
SUITE_SPARSE_ARCHIVE=SuiteSparse-${SUITE_SPARSE_VERSION}.tar.gz
SUITE_SPARSE_DIRECTORY=SuiteSparse
export_var_env SUITE_SPARSE_DOWNLOAD_URL=http://faculty.cse.tamu.edu/davis/SuiteSparse

HERE=$PWD

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
BUILD_DIR=$HERE
INSTALL_DIR=$HERE/install
export_var_env BUILD_TYPE=Debug
export_var_env C_COMPILER=$(command -v gcc)
export_var_env CXX_COMPILER=$(command -v g++)
export_var_env NB_PROCESSORS_USED=1
export_var_env CXX_STDFLAG=""

export_var_env DYNAWO_LIBRARY_TYPE=SHARED

download_suitesparse() {
  cd $SCRIPT_DIR
  if [ ! -f "${SUITE_SPARSE_ARCHIVE}" ]; then
    if [ -x "$(command -v wget)" ]; then
      wget --timeout 10 --tries 3 ${SUITE_SPARSE_DOWNLOAD_URL}/${SUITE_SPARSE_ARCHIVE} || error_exit "Error while downloading SuiteSparse."
    elif [ -x "$(command -v curl)" ]; then
      curl --connect-timeout 10 --retry 2 ${SUITE_SPARSE_DOWNLOAD_URL}/${SUITE_SPARSE_ARCHIVE} --output ${SUITE_SPARSE_ARCHIVE} || error_exit "Error while downloading SuiteSparse."
    else
      error_exit "You need to install either wget or curl."
    fi
  fi
}

install_suitesparse() {
  cd $SCRIPT_DIR
  if [ ! -d "$BUILD_DIR/$SUITE_SPARSE_DIRECTORY" ]; then
    tar -xzf $SUITE_SPARSE_ARCHIVE -C $BUILD_DIR
  fi
  if [ "${BUILD_TYPE}" = "Debug" ]; then
    export CC_FLAG="-g"
    export OPTIMIZATION="-O0"
  else
    export CC_FLAG=""
  fi
  if [ "$DYNAWO_LIBRARY_TYPE" = "SHARED" ]; then
    cd $BUILD_DIR/$SUITE_SPARSE_DIRECTORY/SuiteSparse_config
    { make -j $NB_PROCESSORS_USED CC="$C_COMPILER $CC_FLAG" CXX="$CXX_COMPILER $CC_FLAG $CXX_STDFLAG" library && make  CC="$C_COMPILER $CC_FLAG" CXX="$CXX_COMPILER $CC_FLAG $CXX_STDFLAG" INSTALL_LIB=$INSTALL_DIR/lib INSTALL_INCLUDE=$INSTALL_DIR/include install; } || error_exit "Error while building SuiteSparse"
    cd $BUILD_DIR/$SUITE_SPARSE_DIRECTORY/AMD
    { make -j $NB_PROCESSORS_USED CC="$C_COMPILER $CC_FLAG" CXX="$CXX_COMPILER $CC_FLAG $CXX_STDFLAG" library && make CC="$C_COMPILER $CC_FLAG" CXX="$CXX_COMPILER $CC_FLAG $CXX_STDFLAG" INSTALL_LIB=$INSTALL_DIR/lib INSTALL_INCLUDE=$INSTALL_DIR/include install; } || error_exit "Error while building AMD"
    cd $BUILD_DIR/$SUITE_SPARSE_DIRECTORY/COLAMD
    { make -j $NB_PROCESSORS_USED CC="$C_COMPILER $CC_FLAG" CXX="$CXX_COMPILER $CC_FLAG $CXX_STDFLAG" library && make CC="$C_COMPILER $CC_FLAG" CXX="$CXX_COMPILER $CC_FLAG $CXX_STDFLAG" INSTALL_LIB=$INSTALL_DIR/lib INSTALL_INCLUDE=$INSTALL_DIR/include install; } || error_exit "Error while building COLAMD"
    cd $BUILD_DIR/$SUITE_SPARSE_DIRECTORY/BTF
    { make -j $NB_PROCESSORS_USED CC="$C_COMPILER $CC_FLAG" CXX="$CXX_COMPILER $CC_FLAG $CXX_STDFLAG" library && make CC="$C_COMPILER $CC_FLAG" CXX="$CXX_COMPILER $CC_FLAG $CXX_STDFLAG" INSTALL_LIB=$INSTALL_DIR/lib INSTALL_INCLUDE=$INSTALL_DIR/include install; } || error_exit "Error while building BTF"
    cd $BUILD_DIR/$SUITE_SPARSE_DIRECTORY/KLU
    { make -j $NB_PROCESSORS_USED CC="$C_COMPILER $CC_FLAG" CXX="$CXX_COMPILER $CC_FLAG $CXX_STDFLAG" library && make CC="$C_COMPILER $CC_FLAG" CXX="$CXX_COMPILER $CC_FLAG $CXX_STDFLAG" INSTALL_LIB=$INSTALL_DIR/lib INSTALL_INCLUDE=$INSTALL_DIR/include install; } || error_exit "Error while building KLU"
  else
    mkdir -p $INSTALL_DIR/lib
    mkdir -p $INSTALL_DIR/include
    cd $BUILD_DIR/$SUITE_SPARSE_DIRECTORY/SuiteSparse_config
    make -j $NB_PROCESSORS_USED CC="$C_COMPILER $CC_FLAG" CXX="$CXX_COMPILER $CC_FLAG $CXX_STDFLAG" static || error_exit "Error while building SuiteSparse"
    cp *.a $INSTALL_DIR/lib/ || error_exit "Error while building SuiteSparse"
    cp SuiteSparse_config.h $INSTALL_DIR/include/ || error_exit "Error while building SuiteSparse"
    cd $BUILD_DIR/$SUITE_SPARSE_DIRECTORY/AMD
    make -j $NB_PROCESSORS_USED CC="$C_COMPILER $CC_FLAG" CXX="$CXX_COMPILER $CC_FLAG $CXX_STDFLAG" static || error_exit "Error while building AMD"
    cp Lib/*.a $INSTALL_DIR/lib || error_exit "Error while building AMD"
    cp Include/amd.h $INSTALL_DIR/include || error_exit "Error while building AMD"
    cd $BUILD_DIR/$SUITE_SPARSE_DIRECTORY/COLAMD
    make -j $NB_PROCESSORS_USED CC="$C_COMPILER $CC_FLAG" CXX="$CXX_COMPILER $CC_FLAG $CXX_STDFLAG" static || error_exit "Error while building COLAMD"
    cp Lib/*.a $INSTALL_DIR/lib || error_exit "Error while building COLAMD"
    cp Include/colamd.h $INSTALL_DIR/include || error_exit "Error while building COLAMD"
    cd $BUILD_DIR/$SUITE_SPARSE_DIRECTORY/BTF
    make -j $NB_PROCESSORS_USED CC="$C_COMPILER $CC_FLAG" CXX="$CXX_COMPILER $CC_FLAG $CXX_STDFLAG" static || error_exit "Error while building BTF"
    cp Lib/*.a $INSTALL_DIR/lib || error_exit "Error while building BTF"
    cp Include/btf.h $INSTALL_DIR/include || error_exit "Error while building BTF"
    cd $BUILD_DIR/$SUITE_SPARSE_DIRECTORY/KLU
    make -j $NB_PROCESSORS_USED CC="$C_COMPILER $CC_FLAG" CXX="$CXX_COMPILER $CC_FLAG $CXX_STDFLAG" static || error_exit "Error while building KLU"
    cp Lib/*.a $INSTALL_DIR/lib || error_exit "Error while building KLU"
    cp Include/klu.h $INSTALL_DIR/include || error_exit "Error while building KLU"
  fi
}

while (($#)); do
  case $1 in
    --install-dir=*)
	    INSTALL_DIR=`echo $1 | sed -e 's/--install-dir=//g'`
      if [ ! -d "$INSTALL_DIR" ]; then
        mkdir -p $INSTALL_DIR
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

download_suitesparse || error_exit "Error while downloading SuiteSparse suite"
install_suitesparse || error_exit "Error while building SuiteSparse suite"
