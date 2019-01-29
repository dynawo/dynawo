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

HERE=$PWD

get_absolute_path() {
  absolute=$(readlink -m $1)
  echo "$absolute"
}

find_cxx_std_flag() {
  if [ $CXX11_ENABLED = "YES" ]; then
    echo "int main() {return 0;}" > test_cxx11.cpp
    g++ -std=c++11 -c test_cxx11.cpp -o test_cxx11 2> /dev/null
    RETURN_CODE=$?
    if [ $RETURN_CODE -eq 0 ]; then
      export CXX_STDFLAG="-std=c++11"
      rm -f test_cxx11
    else
      g++ -std=c++0x -c test_cxx11.cpp -o test_cxx11 2> /dev/null
      RETURN_CODE=$?
      if [ $RETURN_CODE -eq 0 ]; then
        export CXX_STDFLAG="-std=c++0x"
        rm -f test_cxx11
      else
        export CXX_STDFLAG="-std=c++98"
      fi
    fi
    rm -f test_cxx11.cpp
  else
    export CXX_STDFLAG="-std=c++98"
  fi
}

compile_suitesparse() {
  cd $HERE/suitesparse
  bash suitesparse-chain.sh --build-dir=$SUITESPARSE_BUILD_DIR --install-dir=$SUITESPARSE_INSTALL_DIR
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

compile_nicslu() {
  cd $HERE/nicslu
  bash nicslu-chain.sh --build-dir=$NICSLU_BUILD_DIR --install-dir=$NICSLU_INSTALL_DIR
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

compile_sundials() {
  cd $HERE/sundials
  bash sundials-chain-2-7-0.sh --build-dir=$SUNDIALS_BUILD_DIR --install-dir=$SUNDIALS_INSTALL_DIR --suitesparse-install-dir=$SUITESPARSE_INSTALL_DIR --build-type=$BUILD_TYPE
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

compile_adept() {
  cd $HERE/adept
  bash adept-chain-1.1.sh --build-dir=$ADEPT_BUILD_DIR --install-dir=$ADEPT_INSTALL_DIR --build-type=$BUILD_TYPE
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

compile_libzip() {
  cd $HERE/libzip
  bash libzip-chain.sh --build-dir=$LIBZIP_BUILD_DIR --install-dir=$LIBZIP_INSTALL_DIR --build-type=$BUILD_TYPE
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

compile_libxml() {
  cd $HERE/libxml
  bash libxml-chain.sh --build-dir=$LIBXML_BUILD_DIR --install-dir=$LIBXML_INSTALL_DIR --build-type=$BUILD_TYPE
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

compile_libiidm() {
  cd $HERE/libiidm
  bash libiidm-chain.sh --build-dir=$LIBIIDM_BUILD_DIR --install-dir=$LIBIIDM_INSTALL_DIR --build-type=$BUILD_TYPE --libxml-install-dir=$LIBXML_INSTALL_DIR
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

compile_all() {
  compile_suitesparse &&
  compile_nicslu &&
  compile_sundials &&
  compile_adept &&
	compile_libzip &&
	compile_libxml &&
	compile_libiidm
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

while (($#)); do
  case $1 in
    --sundials-install-dir=*)
	    SUNDIALS_INSTALL_DIR=`echo $1 | sed -e 's/--sundials-install-dir=//g'`
	    SUNDIALS_INSTALL_DIR=$(get_absolute_path $SUNDIALS_INSTALL_DIR)
      if [ ! -d "$SUNDIALS_INSTALL_DIR" ]; then
        mkdir -p $SUNDIALS_INSTALL_DIR
      fi
      ;;
    --suitesparse-install-dir=*)
	    SUITESPARSE_INSTALL_DIR=`echo $1 | sed -e 's/--suitesparse-install-dir=//g'`
	    SUITESPARSE_INSTALL_DIR=$(get_absolute_path $SUITESPARSE_INSTALL_DIR)
      if [ ! -d "$SUITESPARSE_INSTALL_DIR" ]; then
        mkdir -p $SUITESPARSE_INSTALL_DIR
      fi
      ;;
    --adept-install-dir=*)
	    ADEPT_INSTALL_DIR=`echo $1 | sed -e 's/--adept-install-dir=//g'`
	    ADEPT_INSTALL_DIR=$(get_absolute_path $ADEPT_INSTALL_DIR)
      if [ ! -d "$ADEPT_INSTALL_DIR" ]; then
        mkdir -p $ADEPT_INSTALL_DIR
      fi
      ;;
    --nicslu-install-dir=*)
      NICSLU_INSTALL_DIR=`echo $1 | sed -e 's/--nicslu-install-dir=//g'`
      NICSLU_INSTALL_DIR=$(get_absolute_path $NICSLU_INSTALL_DIR)
      if [ ! -d "$NICSLU_INSTALL_DIR" ]; then
        mkdir -p $NICSLU_INSTALL_DIR
      fi
      ;;
    --libzip-install-dir=*)
      LIBZIP_INSTALL_DIR=`echo $1 | sed -e 's/--libzip-install-dir=//g'`
      LIBZIP_INSTALL_DIR=$(get_absolute_path $LIBZIP_INSTALL_DIR)
      if [ ! -d "$LIBZIP_INSTALL_DIR" ]; then
        mkdir -p $LIBZIP_INSTALL_DIR
      fi
      ;;
    --libxml-install-dir=*)
      LIBXML_INSTALL_DIR=`echo $1 | sed -e 's/--libxml-install-dir=//g'`
      LIBXML_INSTALL_DIR=$(get_absolute_path $LIBXML_INSTALL_DIR)
      if [ ! -d "$LIBXML_INSTALL_DIR" ]; then
        mkdir -p $LIBXML_INSTALL_DIR
      fi
      ;;
    --libiidm-install-dir=*)
      LIBIIDM_INSTALL_DIR=`echo $1 | sed -e 's/--libiidm-install-dir=//g'`
      LIBIIDM_INSTALL_DIR=$(get_absolute_path $LIBIIDM_INSTALL_DIR)
      if [ ! -d "$LIBIIDM_INSTALL_DIR" ]; then
        mkdir -p $LIBIIDM_INSTALL_DIR
      fi
      ;;
    --sundials-build-dir=*)
	    SUNDIALS_BUILD_DIR=`echo $1 | sed -e 's/--sundials-build-dir=//g'`
	    SUNDIALS_BUILD_DIR=$(get_absolute_path $SUNDIALS_BUILD_DIR)
      if [ ! -d "$SUNDIALS_BUILD_DIR" ]; then
        mkdir -p $SUNDIALS_BUILD_DIR
      fi
      ;;
    --suitesparse-build-dir=*)
	    SUITESPARSE_BUILD_DIR=`echo $1 | sed -e 's/--suitesparse-build-dir=//g'`
	    SUITESPARSE_BUILD_DIR=$(get_absolute_path $SUITESPARSE_BUILD_DIR)
      if [ ! -d "$SUITESPARSE_BUILD_DIR" ]; then
        mkdir -p $SUITESPARSE_BUILD_DIR
      fi
      ;;
    --nicslu-build-dir=*)
	    NICSLU_BUILD_DIR=`echo $1 | sed -e 's/--nicslu-build-dir=//g'`
	    NICSLU_BUILD_DIR=$(get_absolute_path $NICSLU_BUILD_DIR)
      if [ ! -d "$NICSLU_BUILD_DIR" ]; then
        mkdir -p $NICSLU_BUILD_DIR
      fi
      ;;
    --adept-build-dir=*)
	    ADEPT_BUILD_DIR=`echo $1 | sed -e 's/--adept-build-dir=//g'`
	    ADEPT_BUILD_DIR=$(get_absolute_path $ADEPT_BUILD_DIR)
      if [ ! -d "$ADEPT_BUILD_DIR" ]; then
        mkdir -p $ADEPT_BUILD_DIR
      fi
      ;;
    --libzip-build-dir=*)
      LIBZIP_BUILD_DIR=`echo $1 | sed -e 's/--libzip-build-dir=//g'`
      LIBZIP_BUILD_DIR=$(get_absolute_path $LIBZIP_BUILD_DIR)
      if [ ! -d "$LIBZIP_BUILD_DIR" ]; then
        mkdir -p $LIBZIP_BUILD_DIR
      fi
      ;;
    --libxml-build-dir=*)
      LIBXML_BUILD_DIR=`echo $1 | sed -e 's/--libxml-build-dir=//g'`
      LIBXML_BUILD_DIR=$(get_absolute_path $LIBXML_BUILD_DIR)
      if [ ! -d "$LIBXML_BUILD_DIR" ]; then
        mkdir -p $LIBXML_BUILD_DIR
      fi
      ;;
    --libiidm-build-dir=*)
      LIBIIDM_BUILD_DIR=`echo $1 | sed -e 's/--libiidm-build-dir=//g'`
      LIBIIDM_BUILD_DIR=$(get_absolute_path $LIBIIDM_BUILD_DIR)
      if [ ! -d "$LIBIIDM_BUILD_DIR" ]; then
        mkdir -p $LIBIIDM_BUILD_DIR
      fi
      ;;
    *)
      break
      ;;
  esac
  shift
done

if  [[ -z "$SUNDIALS_INSTALL_DIR" ]]; then
  echo "Need to set SUNDIALS_INSTALL_DIR"
  exit 1
fi
if  [[ -z "$SUITESPARSE_INSTALL_DIR" ]]; then
  echo "Need to set SUITESPARSE_INSTALL_DIR"
  exit 1
fi
if  [[ -z "$NICSLU_INSTALL_DIR" ]]; then
  echo "Need to set NICSLU_INSTALL_DIR"
  exit 1
fi
if  [[ -z "$ADEPT_INSTALL_DIR" ]]; then
  echo "Need to set ADEPT_INSTALL_DIR"
  exit 1
fi
if  [[ -z "$LIBZIP_INSTALL_DIR" ]]; then
  echo "Need to set LIBZIP_INSTALL_DIR"
  exit 1
fi
if  [[ -z "$LIBXML_INSTALL_DIR" ]]; then
  echo "Need to set LIBXML_INSTALL_DIR"
  exit 1
fi
if  [[ -z "$LIBIIDM_INSTALL_DIR" ]]; then
  echo "Need to set LIBIIDM_INSTALL_DIR"
  exit 1
fi
if  [[ -z "$SUNDIALS_BUILD_DIR" ]]; then
  echo "Need to set SUNDIALS_BUILD_DIR"
  exit 1
fi
if  [[ -z "$SUITESPARSE_BUILD_DIR" ]]; then
  echo "Need to set SUITESPARSE_BUILD_DIR"
  exit 1
fi
if  [[ -z "$NICSLU_BUILD_DIR" ]]; then
  echo "Need to set NICSLU_BUILD_DIR"
  exit 1
fi
if  [[ -z "$ADEPT_BUILD_DIR" ]]; then
  echo "Need to set ADEPT_BUILD_DIR"
  exit 1
fi
if  [[ -z "$LIBZIP_BUILD_DIR" ]]; then
  echo "Need to set LIBZIP_BUILD_DIR"
  exit 1
fi
if  [[ -z "$LIBXML_BUILD_DIR" ]]; then
  echo "Need to set LIBXML_BUILD_DIR"
  exit 1
fi
if  [[ -z "$LIBIIDM_BUILD_DIR" ]]; then
  echo "Need to set LIBIIDM_BUILD_DIR"
  exit 1
fi

find_cxx_std_flag

compile_all || error_exit "Error while building 3rd parties"
