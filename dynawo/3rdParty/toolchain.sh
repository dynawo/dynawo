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

export_var_env_default() {
  var=$@
  name=${var%=*}
  value=${var##*=}

  if [ "$value" = UNDEFINED ]; then
    if eval "[ \$$name ]"; then
      eval "value=\${$name}"
      export_var_env ${name}_DEFAULT=false
    else
      export_var_env ${name}_DEFAULT=true
      return
    fi
  fi

  export $name="$value"
  export_var_env ${name}_DEFAULT=false
}

get_absolute_path() {
  python -c "import os; print(os.path.realpath('$1'))"
}

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

find_cxx_std_flag() {
  if [ "$(echo "$CXX11_ENABLED" | tr '[:upper:]' '[:lower:]')" = "yes" -o "$(echo "$CXX11_ENABLED" | tr '[:upper:]' '[:lower:]')" = "true" -o "$(echo "$CXX11_ENABLED" | tr '[:upper:]' '[:lower:]')" = "on" ]; then
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
  cd $SCRIPT_DIR/suitesparse
  bash suitesparse-chain.sh --build-dir=$SUITESPARSE_BUILD_DIR --install-dir=$SUITESPARSE_INSTALL_DIR
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

compile_nicslu() {
  cd $SCRIPT_DIR/nicslu
  bash nicslu-chain.sh --build-dir=$NICSLU_BUILD_DIR --install-dir=$NICSLU_INSTALL_DIR
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

compile_sundials() {
  cd $SCRIPT_DIR/sundials
  bash sundials-chain-2-7-0.sh --build-dir=$SUNDIALS_BUILD_DIR --install-dir=$SUNDIALS_INSTALL_DIR --suitesparse-install-dir=$SUITESPARSE_INSTALL_DIR --build-type=$BUILD_TYPE
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

compile_adept() {
  cd $SCRIPT_DIR/adept
  bash adept-chain-1.1.sh --build-dir=$ADEPT_BUILD_DIR --install-dir=$ADEPT_INSTALL_DIR --build-type=$BUILD_TYPE
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

compile_libzip() {
  cd $SCRIPT_DIR/libzip
  bash libzip-chain.sh --build-dir=$LIBZIP_BUILD_DIR --install-dir=$LIBZIP_INSTALL_DIR --build-type=$BUILD_TYPE $LIBARCHIVE_OPTION $BOOST_OPTION $GTEST_OPTION
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

compile_libxml() {
  cd $SCRIPT_DIR/libxml
  bash libxml-chain.sh --build-dir=$LIBXML_BUILD_DIR --install-dir=$LIBXML_INSTALL_DIR --build-type=$BUILD_TYPE --xercesc-install-dir=$XERCESC_INSTALL_DIR $BOOST_OPTION $GTEST_OPTION
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

compile_libiidm() {
  cd $SCRIPT_DIR/libiidm
  bash libiidm-chain.sh --build-dir=$LIBIIDM_BUILD_DIR --install-dir=$LIBIIDM_INSTALL_DIR --build-type=$BUILD_TYPE --libxml-install-dir=$LIBXML_INSTALL_DIR $BOOST_OPTION $GTEST_OPTION
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

compile_xercesc() {
  cd $SCRIPT_DIR/xerces-c
  bash xerces-c-chain.sh --build-dir=$XERCESC_BUILD_DIR --install-dir=$XERCESC_INSTALL_DIR --build-type=$BUILD_TYPE
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

compile_all() {
  compile_suitesparse &&
  compile_nicslu &&
  compile_sundials &&
  compile_adept &&
  compile_xercesc &&
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
    --xercesc-install-dir=*)
      XERCESC_INSTALL_DIR=`echo $1 | sed -e 's/--xercesc-install-dir=//g'`
      XERCESC_INSTALL_DIR=$(get_absolute_path $XERCESC_INSTALL_DIR)
      if [ ! -d "$XERCESC_INSTALL_DIR" ]; then
        mkdir -p $XERCESC_INSTALL_DIR
      fi
      ;;
    --boost-install-dir=*)
			BOOST_ROOT=`echo $1 | sed -e 's/--boost-install-dir=//g'`
			;;
    --libarchive-install-dir=*)
			LIBARCHIVE_HOME=`echo $1 | sed -e 's/--libarchive-install-dir=//g'`
      ;;
    --gtest-install-dir=*)
      GTEST_ROOT=`echo $1 | sed -e 's/--gtest-install-dir=//g'`
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
    --xercesc-build-dir=*)
      XERCESC_BUILD_DIR=`echo $1 | sed -e 's/--xercesc-build-dir=//g'`
      XERCESC_BUILD_DIR=$(get_absolute_path $XERCESC_BUILD_DIR)
      if [ ! -d "$XERCESC_BUILD_DIR" ]; then
        mkdir -p $XERCESC_BUILD_DIR
      fi
      ;;
    *)
      break
      ;;
  esac
  shift
done

if [[ -z "$SUNDIALS_INSTALL_DIR" ]]; then
  echo "Need to set SUNDIALS_INSTALL_DIR"
  exit 1
fi
if [[ -z "$SUITESPARSE_INSTALL_DIR" ]]; then
  echo "Need to set SUITESPARSE_INSTALL_DIR"
  exit 1
fi
if [[ -z "$NICSLU_INSTALL_DIR" ]]; then
  echo "Need to set NICSLU_INSTALL_DIR"
  exit 1
fi
if [[ -z "$ADEPT_INSTALL_DIR" ]]; then
  echo "Need to set ADEPT_INSTALL_DIR"
  exit 1
fi
if [[ -z "$LIBZIP_INSTALL_DIR" ]]; then
  echo "Need to set LIBZIP_INSTALL_DIR"
  exit 1
fi
if [[ -z "$LIBXML_INSTALL_DIR" ]]; then
  echo "Need to set LIBXML_INSTALL_DIR"
  exit 1
fi
if [[ -z "$LIBIIDM_INSTALL_DIR" ]]; then
  echo "Need to set LIBIIDM_INSTALL_DIR"
  exit 1
fi
if [[ -z "$XERCESC_INSTALL_DIR" ]]; then
  echo "Need to set XERCESC_INSTALL_DIR"
  exit 1
fi
if [[ -z "$SUNDIALS_BUILD_DIR" ]]; then
  echo "Need to set SUNDIALS_BUILD_DIR"
  exit 1
fi
if [[ -z "$SUITESPARSE_BUILD_DIR" ]]; then
  echo "Need to set SUITESPARSE_BUILD_DIR"
  exit 1
fi
if [[ -z "$NICSLU_BUILD_DIR" ]]; then
  echo "Need to set NICSLU_BUILD_DIR"
  exit 1
fi
if [[ -z "$ADEPT_BUILD_DIR" ]]; then
  echo "Need to set ADEPT_BUILD_DIR"
  exit 1
fi
if [[ -z "$LIBZIP_BUILD_DIR" ]]; then
  echo "Need to set LIBZIP_BUILD_DIR"
  exit 1
fi
if [[ -z "$LIBXML_BUILD_DIR" ]]; then
  echo "Need to set LIBXML_BUILD_DIR"
  exit 1
fi
if [[ -z "$LIBIIDM_BUILD_DIR" ]]; then
  echo "Need to set LIBIIDM_BUILD_DIR"
  exit 1
fi
if [[ -z "$XERCESC_BUILD_DIR" ]]; then
  echo "Need to set XERCESC_BUILD_DIR"
  exit 1
fi

find_cxx_std_flag

export_var_env_default LIBARCHIVE_HOME=UNDEFINED
export_var_env_default BOOST_ROOT=UNDEFINED
export_var_env_default GTEST_ROOT=UNDEFINED

if [ $BOOST_ROOT_DEFAULT != true ]; then
  BOOST_OPTION="--boost-install-dir=$BOOST_ROOT"
else
  BOOST_OPTION=""
fi
if [ $LIBARCHIVE_HOME_DEFAULT != true ]; then
  LIBARCHIVE_OPTION="--libarchive-install-dir=$LIBARCHIVE_HOME"
else
  LIBARCHIVE_OPTION=""
fi
if [ $GTEST_ROOT_DEFAULT != true ]; then
  GTEST_OPTION="--gtest-install-dir=$GTEST_ROOT"
else
  GTEST_OPTION=""
fi

compile_all || error_exit "Error while building 3rd parties"
