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

# All environment variables in this script must be exported through custom functions export_var_env or export_var_env_force
# or export_var_env_default and prefixed by DYNAWO_.

#################################
########### Functions ###########
#################################

error_exit() {
  echo "${1:-"Unknown Error"}" 1>&2
  exit 1
}

error() {
  echo "${1:-"Unknown Error"}" 1>&2
}

define_options() {
  export_var_env DYNAWO_USAGE="Usage: `basename $0` [option] -- program to deal with Dynawo

where [option] can be:"

  export_var_env DYNAWO_USER_OPTIONS="    =========== Dynawo User
        =========== Build
        build-user                            build Dynawo and its dependencies

        =========== Launch
        jobs ([args])                         launch Dynawo simulation
        jobs-with-curves ([args])             launch Dynawo simulation and open resulting curves in a browser

        =========== Utilities
        compileModelicaModel ([args])         compile a single Modelica model (.mo) into a Dynawo model (.so)
        generate-preassembled ([args])        generate a preassembled model (.so) from a model description (.xml)
        dump-model ([args])                   dump variables and parameters of a Dynawo model (.so) into a xml file"

  export_var_env DYNAWO_DEVELOPER_OPTIONS="    =========== Dynawo Developer
        =========== Build
        build-omcDynawo                       build the OpenModelica compiler for Dynawo
        config-3rd-party                      configure 3rd parties build
        build-3rd-party                       build 3rd party softwares
        config-dynawo                         configure Dynawo's compiling environment using CMake
        build-dynawo                          build Dynawo and install preassembled models (core, models cpp, models and solvers)
        build-dynaflow                        build DynaFlow related models (and core, models cpp and solvers) and install preassembled models (core, models cpp, DynaFlow models and solvers)
        build-dynaswing                       build DynaSwing related models (and core, models cpp and solvers) and install preassembled models (core, models cpp, DynaSwing models and solvers)
        build-dynawo-core                     build Dynawo without models
        build-dynawo-target                   build a specific Dynawo target (use help to see all cmake targets)
        build-dynawo-models-cpp               build Dynawo CPP models
        build-dynawo-models                   build Dynawo preassembled models
        build-dynawo-solvers                  build Dynawo solver descriptions
        build-all                             call in this order build-3rd-party, config-dynawo, build-dynawo, build-doxygen-doc
        build-tests ([args])                  build and launch Dynawo's unittest (launch all tests if [args] is empty)
        build-tests-coverage ([args])         build/launch Dynawo's unittest and generate code coverage report (launch all tests if [args] is empty)

        =========== Clean
        clean-3rd-party                       remove all 3rd party softwares objects
        clean-dynawo                          remove Dynawo's objects
        clean-all                             call clean-3rd-party, clean-dynawo
        clean-models [args]                   clean given preassembled models
        clean-tests                           remove all objects needed for unittest
        clean-tests-coverage                  remove all objects needed for unittest-coverage
        clean-old-branches                    remove old build/install/nrt results from merge branches

        =========== Clean-Build
        clean-build-3rd-party                 clean then build 3rd party libraries
        clean-build-dynawo                    clean, then configure and build Dynawo
        clean-build-all                       clean, then configure and build 3rd party libraries, Dynawo
        clean-build-models [args]             clean and build given preassembled models

        =========== Uninstall
        uninstall-3rd-party                   uninstall all 3rd party softwares
        uninstall-dynawo                      uninstall Dynawo
        uninstall-all                         call uninstall-3rd-party, uninstall-dynawo

        =========== Launch
        jobs ([args])                         launch Dynawo simulation
        jobs-with-curves ([args])             launch Dynawo simulation and open resulting curves in a browser
        jobs-gdb ([args])                     launch Dynawo simulation in gdb
        jobs-valgrind ([args])                launch Dynawo simulation in valgrind (defaut tool to check memory leakage)
        jobs-valgrind-callgrind ([args])      launch Dynawo simulation in valgrind with callgrind tool (profiling tool that records the call history)
        jobs-valgrind-dhat ([args])           launch Dynawo simulation in valgrind with dhat tool (dynamic heap analysis tool)
        jobs-valgrind-massif ([args])         launch Dynawo simulation in valgrind with massif tool (a heap profiler)
        unittest-gdb [arg]                    call unittest in gdb
        curves [arg]                          plot curves of job
        curves-reference [arg]                plot curves of job's reference
        curves-reference-same-graph [arg]     plot curves of job and job's reference on the same graph

        =========== Distribution
        distrib                               create distribution of Dynawo
        distrib-omc                           create distribution with omc binary
        distrib-headers                       create distribution with Dynawo headers but without omc
        deploy                                deploy the current version of dynawo binaries/libraries/includes to be used as a release by an another project

        =========== Tests
        nrt ([-p regex] [-n name_filter])     run (filtered) non-regression tests and open the result in chosen browser
        nrt-clean                             clean non-regression tests
        nrt-diff ([args])                     make a diff between two non-regression test outputs
        nrt-ref ([args])                      define or redefine automatically the non-regression tests references
        nrt-xsl ([args])                      update automatically the xml input files from the nrt
        version-validation                    clean all built items, then build them all and run non-regression tests
        list-tests                            print all available unittest target
        list-models                           list all preassembled models you can use with clean-models or clean-build-models
        run-doc-tests                         run all tests provided in the documentation

        =========== Utilities
        generate-preassembled-gdb             generate a preassembled model with debugger
        dump-model-gdb                        dump model with debugger
        dump-model-valgrind                   dump model with valgrind
        compileCppModelicaModelInDynamicLib   compile Modelica Model generated for Dynawo"

  export_var_env DYNAWO_DOCUMENTATION_OPTIONS="    =========== Dynawo Documentation
        =========== Launch
        doc                                   open Dynawo's documentation
        doxygen-doc                           open Dynawo's Doxygen documentation into chosen browser
        modelica-doc                          open Dynawo's Modelica models documentation
        nrt-doc                               open Dynawo's nrt documentation

        =========== Build
        build-doc                             build documentation
        build-doxygen-doc                     build all doxygen documentation
        build-nrt-doc                         build nrt documentation

        =========== Clean
        clean-doc                             clean documentation
        clean-nrt-doc                         clean nrt documentation"

  export_var_env DYNAWO_OTHER_OPTIONS="    =========== Others
    help                                  show all available options
    help-user                             show user specific options
    deploy-autocompletion                 deploy autocompletion functions for Dynawo.
    display-environment                   display all environment variables managed by Dynawo
    reset-environment                     reset all environment variables set by Dynawo
    version                               show Dynawo version"
}

help_dynawo() {
  define_options
  echo "$DYNAWO_USAGE"
  echo
  echo "$DYNAWO_USER_OPTIONS"
  echo;echo
  echo "$DYNAWO_DEVELOPER_OPTIONS"
  echo;echo
  echo "$DYNAWO_DOCUMENTATION_OPTIONS"
  echo;echo
  echo "$DYNAWO_OTHER_OPTIONS"
}

help_dynawo_user() {
  define_options
  echo "$DYNAWO_USAGE"
  echo
  echo "$DYNAWO_USER_OPTIONS"
  echo;echo
  echo "$DYNAWO_DOCUMENTATION_OPTIONS"
  echo;echo
  echo "$DYNAWO_OTHER_OPTIONS"
}

export_var_env_force() {
  local var="$@"
  local name=${var%%=*}
  local value="${var#*=}"

  if ! `expr $name : "DYNAWO_.*" > /dev/null`; then
    error_exit "You must export variables with DYNAWO prefix for $name."
  fi

  if eval "[ \"\$$name\" ]"; then
    unset $name
    export $name="$value"
    return
  fi

  if [ "$value" = UNDEFINED ]; then
    error_exit "You must define the value of $name"
  fi
  export $name="$value"
}

export_var_env() {
  local var="$@"
  local name=${var%%=*}
  local value="${var#*=}"

  if ! `expr $name : "DYNAWO_.*" > /dev/null`; then
    error_exit "You must export variables with DYNAWO prefix for $name."
  fi

  if eval "[ \"\$$name\" ]"; then
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
  local var="$@"
  local name=${var%%=*}
  local value="${var#*=}"

  if ! `expr $name : "DYNAWO_.*" > /dev/null`; then
    error_exit "You must export variables with DYNAWO prefix for $name."
  fi

  if [ "$value" = UNDEFINED ]; then
    if eval "[ \"\$$name\" ]"; then
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

export_git_branch() {
  current_dir=$PWD
  if [ ! -d "$DYNAWO_HOME" ]; then
    error_exit "$DYNAWO_HOME does not exist."
  fi
  cd $DYNAWO_HOME
  if [ -e ".git" ]; then
    branch_name=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
    if [[ "${branch_name}" == "" ]]; then
      branch_ref=$(git rev-parse --short HEAD 2> /dev/null)
      [ -z "$branch_ref" ] && branch_ref=unknown
      branch_name="detached_"${branch_ref}
    fi
  else
    branch_name="no-branch"
  fi
  export_var_env_force DYNAWO_BRANCH_NAME=${branch_name}
  cd $current_dir
}

# Export variables needed for Dynawo
set_environment() {
  DYNAWO_FOLDER_BUILD_TYPE=$DYNAWO_BUILD_TYPE
  # Force build type when building tests (or tests coverage)
  case $1 in
    build-tests-coverage)
      export_var_env_force DYNAWO_BUILD_TYPE=Debug
      DYNAWO_FOLDER_BUILD_TYPE=TestsCoverage
      export_var_env_force DYNAWO_BUILD_TESTS=OFF
      export_var_env_force DYNAWO_BUILD_TESTS_COVERAGE=ON
      export_var_env_force DYNAWO_USE_XSD_VALIDATION=true
      export_var_env DYNAWO_DICTIONARIES=dictionaries_mapping
      ;;
    build-tests)
      export_var_env_force DYNAWO_BUILD_TYPE=Debug
      DYNAWO_FOLDER_BUILD_TYPE=Tests
      export_var_env_force DYNAWO_BUILD_TESTS=ON
      export_var_env_force DYNAWO_BUILD_TESTS_COVERAGE=OFF
      export_var_env_force DYNAWO_USE_XSD_VALIDATION=true
      export_var_env DYNAWO_DICTIONARIES=dictionaries_mapping
      ;;
    list-tests)
      export_var_env_force DYNAWO_BUILD_TYPE=Debug
      DYNAWO_FOLDER_BUILD_TYPE=Tests
      export_var_env_force DYNAWO_BUILD_TESTS=ON
      export_var_env_force DYNAWO_BUILD_TESTS_COVERAGE=OFF
      export_var_env_force DYNAWO_USE_XSD_VALIDATION=true
      ;;
    unittest-gdb)
      export_var_env_force DYNAWO_BUILD_TYPE=Debug
      DYNAWO_FOLDER_BUILD_TYPE=Tests
      export_var_env_force DYNAWO_BUILD_TESTS=ON
      export_var_env_force DYNAWO_BUILD_TESTS_COVERAGE=OFF
      export_var_env_force DYNAWO_USE_XSD_VALIDATION=true
      export_var_env_force DYNAWO_XSD_DIR=./
      ;;
    clean-tests)
      export_var_env_force DYNAWO_BUILD_TYPE=Debug
      DYNAWO_FOLDER_BUILD_TYPE=Tests
      export_var_env_force DYNAWO_BUILD_TESTS=ON
      export_var_env_force DYNAWO_BUILD_TESTS_COVERAGE=OFF
      export_var_env_force DYNAWO_USE_XSD_VALIDATION=true
      ;;
    clean-tests-coverage)
      export_var_env_force DYNAWO_BUILD_TYPE=Debug
      DYNAWO_FOLDER_BUILD_TYPE=TestsCoverage
      export_var_env_force DYNAWO_BUILD_TESTS=OFF
      export_var_env_force DYNAWO_BUILD_TESTS_COVERAGE=ON
      export_var_env_force DYNAWO_USE_XSD_VALIDATION=true
      ;;
    *)
      ;;
  esac

  # Compiler, to have default with gcc
  export_var_env DYNAWO_COMPILER=GCC

  # Set path to compilers
  set_compiler

  # Build_config
  export_var_env DYNAWO_BUILD_TESTS=OFF
  export_var_env DYNAWO_BUILD_TESTS_COVERAGE=OFF
  export_var_env DYNAWO_BUILD_TYPE=UNDEFINED
  export_var_env DYNAWO_USE_LEGACY_IIDM=NO
  export_var_env_force DYNAWO_USE_ADEPT=YES

  export_var_env DYNAWO_COMPILER_VERSION=$($DYNAWO_C_COMPILER -dumpversion)

  # Dynawo
  export_var_env DYNAWO_HOME=UNDEFINED
  export_git_branch
  export_var_env_force DYNAWO_SRC_DIR=$DYNAWO_HOME/dynawo
  export_var_env DYNAWO_DEPLOY_DIR=$DYNAWO_HOME/deploy/$DYNAWO_COMPILER_NAME$DYNAWO_COMPILER_VERSION/shared/dynawo

  DIR_LIBIIDM="libiidm"
  if [ "$(echo "$DYNAWO_USE_LEGACY_IIDM" | tr '[:upper:]' '[:lower:]')" = "yes" -o "$(echo "$DYNAWO_USE_LEGACY_IIDM" | tr '[:upper:]' '[:lower:]')" = "true" -o "$(echo "$DYNAWO_USE_LEGACY_IIDM" | tr '[:upper:]' '[:lower:]')" = "on" ]; then
    DIR_LIBIIDM="libiidm0"
  fi

  if [ ! -z "$DYNAWO_JENKINS_MODE" ]; then
    export_var_env DYNAWO_BUILD_DIR=$DYNAWO_HOME/build/$DYNAWO_COMPILER_NAME$DYNAWO_COMPILER_VERSION/shared/dynawo
    export_var_env DYNAWO_INSTALL_DIR=$DYNAWO_HOME/install/$DYNAWO_COMPILER_NAME$DYNAWO_COMPILER_VERSION/shared/dynawo
  else
    export_var_env DYNAWO_BUILD_DIR=$DYNAWO_HOME/build/$DYNAWO_COMPILER_NAME$DYNAWO_COMPILER_VERSION/$DYNAWO_BRANCH_NAME/$DYNAWO_FOLDER_BUILD_TYPE$SUFFIX_CX11/shared/dynawo
    export_var_env DYNAWO_INSTALL_DIR=$DYNAWO_HOME/install/$DYNAWO_COMPILER_NAME$DYNAWO_COMPILER_VERSION/$DYNAWO_BRANCH_NAME/$DYNAWO_FOLDER_BUILD_TYPE$SUFFIX_CX11/shared/dynawo
  fi
  export_var_env DYNAWO_DEBUG_COMPILER_OPTION="-O0"
  export_var_env DYNAWO_FORCE_CXX11_ABI=false

  # Find build type for third party libraries
  DYNAWO_BUILD_TYPE_THIRD_PARTY=$DYNAWO_BUILD_TYPE
  case $DYNAWO_BUILD_TYPE_THIRD_PARTY in
    Tests | TestCoverage)
      DYNAWO_BUILD_TYPE_THIRD_PARTY=Debug
      ;;
    *)
      ;;
  esac

  # Third parties
  export_var_env_force DYNAWO_THIRD_PARTY_SRC_DIR=$DYNAWO_SRC_DIR/3rdParty
  export_var_env_force DYNAWO_THIRD_PARTY_BUILD_DIR_VERSION=$DYNAWO_HOME/build/3rdParty/$DYNAWO_COMPILER_NAME$DYNAWO_COMPILER_VERSION/shared/$DYNAWO_BUILD_TYPE_THIRD_PARTY$SUFFIX_CX11
  export_var_env_force DYNAWO_THIRD_PARTY_INSTALL_DIR_VERSION=$DYNAWO_HOME/install/3rdParty/$DYNAWO_COMPILER_NAME$DYNAWO_COMPILER_VERSION/shared/$DYNAWO_BUILD_TYPE_THIRD_PARTY$SUFFIX_CX11
  export_var_env DYNAWO_THIRD_PARTY_BUILD_DIR=$DYNAWO_THIRD_PARTY_BUILD_DIR_VERSION
  export_var_env DYNAWO_THIRD_PARTY_INSTALL_DIR=$DYNAWO_THIRD_PARTY_INSTALL_DIR_VERSION

  if [ -d "$DYNAWO_THIRD_PARTY_INSTALL_DIR/boost" ]; then
    if [ ! -z "$(ls -A $DYNAWO_THIRD_PARTY_INSTALL_DIR/boost)" ]; then
      export_var_env DYNAWO_BOOST_HOME=$DYNAWO_THIRD_PARTY_INSTALL_DIR/boost
      unset DYNAWO_BOOST_HOME_DEFAULT
    fi
  fi

  if [ -d "$DYNAWO_THIRD_PARTY_INSTALL_DIR/libarchive" ]; then
    if [ ! -z "$(ls -A $DYNAWO_THIRD_PARTY_INSTALL_DIR/libarchive)" ]; then
      export_var_env DYNAWO_LIBARCHIVE_HOME=$DYNAWO_THIRD_PARTY_INSTALL_DIR/libarchive
      unset DYNAWO_LIBARCHIVE_HOME_DEFAULT
    fi
  fi

  if [ -d "$DYNAWO_THIRD_PARTY_INSTALL_DIR/zlib" ]; then
    if [ ! -z "$(ls -A $DYNAWO_THIRD_PARTY_INSTALL_DIR/zlib)" ]; then
      export_var_env DYNAWO_ZLIB_HOME=$DYNAWO_THIRD_PARTY_INSTALL_DIR/zlib
      unset DYNAWO_ZLIB_HOME_DEFAULT
    fi
  fi

  if [ -d "$DYNAWO_THIRD_PARTY_INSTALL_DIR/googletest" ]; then
    if [ ! -z "$(ls -A $DYNAWO_THIRD_PARTY_INSTALL_DIR/googletest)" ]; then
      export_var_env DYNAWO_GTEST_HOME=$DYNAWO_THIRD_PARTY_INSTALL_DIR/googletest
      export_var_env DYNAWO_GMOCK_HOME=$DYNAWO_THIRD_PARTY_INSTALL_DIR/googletest
      unset DYNAWO_GTEST_HOME_DEFAULT
      unset DYNAWO_GMOCK_HOME_DEFAULT
    fi
  fi

  if [ -d "$DYNAWO_THIRD_PARTY_INSTALL_DIR/libxml2" ]; then
    if [ ! -z "$(ls -A $DYNAWO_THIRD_PARTY_INSTALL_DIR/libxml2)" ]; then
      export_var_env DYNAWO_LIBXML2_HOME=$DYNAWO_THIRD_PARTY_INSTALL_DIR/libxml2
      unset DYNAWO_LIBXML2_HOME_DEFAULT
    fi
  fi

  # External libs
  export_var_env_default DYNAWO_ZLIB_HOME=UNDEFINED
  export_var_env_default DYNAWO_LIBARCHIVE_HOME=UNDEFINED
  export_var_env_default DYNAWO_BOOST_HOME=UNDEFINED
  export_var_env_default DYNAWO_GTEST_HOME=UNDEFINED
  export_var_env_default DYNAWO_GMOCK_HOME=UNDEFINED
  export_var_env_default DYNAWO_LIBXML2_HOME=UNDEFINED

  export_var_env_force DYNAWO_SUITESPARSE_INSTALL_DIR=$DYNAWO_THIRD_PARTY_INSTALL_DIR/suitesparse
  export_var_env_force DYNAWO_NICSLU_INSTALL_DIR=$DYNAWO_THIRD_PARTY_INSTALL_DIR/nicslu
  export_var_env_force DYNAWO_SUNDIALS_INSTALL_DIR=$DYNAWO_THIRD_PARTY_INSTALL_DIR/sundials
  export_var_env_force DYNAWO_ADEPT_INSTALL_DIR=$DYNAWO_THIRD_PARTY_INSTALL_DIR/adept
  export_var_env_force DYNAWO_XERCESC_INSTALL_DIR=$DYNAWO_THIRD_PARTY_INSTALL_DIR/xerces-c

  export_var_env_force DYNAWO_LIBIIDM_HOME=$DYNAWO_THIRD_PARTY_INSTALL_DIR/$DIR_LIBIIDM
  export_var_env_force DYNAWO_LIBIIDM_INSTALL_DIR=$DYNAWO_LIBIIDM_HOME

  export_var_env_force DYNAWO_LIBZIP_HOME=$DYNAWO_THIRD_PARTY_INSTALL_DIR/libzip
  export_var_env_force DYNAWO_LIBZIP_INSTALL_DIR=$DYNAWO_LIBZIP_HOME

  export_var_env_force DYNAWO_LIBXML_HOME=$DYNAWO_THIRD_PARTY_INSTALL_DIR/libxml
  export_var_env_force DYNAWO_LIBXML_INSTALL_DIR=$DYNAWO_LIBXML_HOME

  # DYNAWO_IIDM_EXTENSION not set by default
  export_var_env DYNAWO_LIBIIDM_EXTENSIONS=$DYNAWO_LIBIIDM_INSTALL_DIR/lib

  # Miscellaneous
  export_var_env DYNAWO_USE_XSD_VALIDATION=true
  export_var_env DYNAWO_LOCALE=en_GB
  export_var_env DYNAWO_BROWSER=firefox
  export_var_env DYNAWO_PDFVIEWER=xdg-open
  export_var_env_force DYNAWO_NRT_DIR=$DYNAWO_HOME/nrt
  export_var_env_force DYNAWO_EXAMPLES_DIR=$DYNAWO_HOME/examples
  export_var_env DYNAWO_RESULTS_SHOW=true
  export_var_env_force DYNAWO_CURVES_TO_HTML_DIR=$DYNAWO_HOME/util/curvesToHtml
  export_var_env_force DYNAWO_SCRIPTS_DIR=$DYNAWO_INSTALL_DIR/sbin
  export_var_env_force DYNAWO_NRT_DIFF_DIR=$DYNAWO_HOME/util/nrt_diff
  export_var_env_force DYNAWO_ENV_DYNAWO=$SCRIPT
  export_var_env DYNAWO_CMAKE_GENERATOR="Unix Makefiles"
  export_var_env DYNAWO_CMAKE_BUILD_OPTION=""
  if [ -x "$(command -v cmake)" ]; then
    CMAKE_VERSION=$(cmake --version | head -1 | awk '{print $(NF)}')
    CMAKE_BUILD_OPTION=""
    if [ $(echo $CMAKE_VERSION | cut -d '.' -f 1) -ge 3 -a $(echo $CMAKE_VERSION | cut -d '.' -f 2) -ge 12 ]; then
      CMAKE_BUILD_OPTION="-j $DYNAWO_NB_PROCESSORS_USED"
    fi
    export_var_env_force DYNAWO_CMAKE_BUILD_OPTION="$CMAKE_BUILD_OPTION"
  fi
  export_var_env DYNAWO_PYTHON_COMMAND="python"
  if [ ! -x "$(command -v ${DYNAWO_PYTHON_COMMAND})" ]; then
    error_exit "Your python interpreter \"${DYNAWO_PYTHON_COMMAND}\" does not work. Use export DYNAWO_PYTHON_COMMAND=<Python Interpreter> in your myEnvDynawo.sh."
  fi

  # Only used until now by nrt
  export_var_env DYNAWO_NB_PROCESSORS_USED=1

  # OpenModelica config
  export_var_env_force DYNAWO_OPENMODELICA_VERSION=1_13_2
  export_var_env_force DYNAWO_MODELICA_LIB=3.2.3
  export_var_env DYNAWO_SRC_OPENMODELICA=UNDEFINED
  export_var_env DYNAWO_INSTALL_OPENMODELICA=UNDEFINED

  # JQuery config
  export_var_env DYNAWO_JQUERY_DOWNLOAD_URL=https://github.com/jquery/jquery/archive
  export_var_env DYNAWO_FLOT_DOWNLOAD_URL=https://github.com/flot/flot/archive

  if [ "`uname`" = "Linux" ]; then
    export_var_env_force DYNAWO_SHARED_LIBRARY_SUFFIX="so"
  else
    echo "OS `uname` not supported."
    exit 1
  fi

  # Export library path, path and other standard environment variables
  set_standard_environment_variables

  set_commit_hook
}

ld_library_path_remove() {
  export LD_LIBRARY_PATH=`echo -n $LD_LIBRARY_PATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`;
}

ld_library_path_prepend() {
  if [ ! -z "$LD_LIBRARY_PATH" ]; then
    ld_library_path_remove $1
    export LD_LIBRARY_PATH="$1:$LD_LIBRARY_PATH"
  else
    export LD_LIBRARY_PATH="$1"
  fi
}

python_path_remove() {
  export PYTHONPATH=`echo -n $PYTHONPATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`;
}

python_path_append() {
  if [ ! -z "$PYTHONPATH" ]; then
    python_path_remove $1
    export PYTHONPATH="$PYTHONPATH:$1"
  else
    export PYTHONPATH="$1"
  fi
}

path_remove() {
  export PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`;
}

path_prepend() {
  if [ ! -z "$PATH" ]; then
    path_remove $1
    export PATH="$1:$PATH"
  else
    export PATH="$1"
  fi
}

set_standard_environment_variables() {
  if [ $DYNAWO_ZLIB_HOME_DEFAULT != true ]; then
    ld_library_path_prepend $DYNAWO_ZLIB_HOME/lib
  fi

  if [ $DYNAWO_LIBARCHIVE_HOME_DEFAULT != true ]; then
    ld_library_path_prepend $DYNAWO_LIBARCHIVE_HOME/lib
  fi

  if [ $DYNAWO_BOOST_HOME_DEFAULT != true ]; then
    ld_library_path_prepend $DYNAWO_BOOST_HOME/lib
  fi

  if [ $DYNAWO_LIBXML2_HOME_DEFAULT != true ]; then
    ld_library_path_prepend $DYNAWO_LIBXML2_HOME/lib
  fi

  if [ "$DYNAWO_BUILD_TYPE" = "Debug" ]; then
    if [ $DYNAWO_GTEST_HOME_DEFAULT != true ]; then
      if [ -d "$DYNAWO_GTEST_HOME/lib64" ]; then
        ld_library_path_prepend $DYNAWO_GTEST_HOME/lib64
      elif [ -d "$DYNAWO_GTEST_HOME/lib" ]; then
        ld_library_path_prepend $DYNAWO_GTEST_HOME/lib
      else
        error_exit "Not enable to find GoogleTest library directory for runtime."
      fi
    fi
  fi

  ld_library_path_prepend $DYNAWO_NICSLU_INSTALL_DIR/lib
  ld_library_path_prepend $DYNAWO_SUITESPARSE_INSTALL_DIR/lib
  if [ -d "$DYNAWO_SUNDIALS_INSTALL_DIR/lib64" ]; then
    ld_library_path_prepend $DYNAWO_SUNDIALS_INSTALL_DIR/lib64
  elif [ -d "$DYNAWO_SUNDIALS_INSTALL_DIR/lib" ]; then
    ld_library_path_prepend $DYNAWO_SUNDIALS_INSTALL_DIR/lib
  else
    ld_library_path_prepend $DYNAWO_SUNDIALS_INSTALL_DIR/lib
    ld_library_path_prepend $DYNAWO_SUNDIALS_INSTALL_DIR/lib64
  fi
  ld_library_path_prepend $DYNAWO_LIBZIP_HOME/lib
  ld_library_path_prepend $DYNAWO_LIBXML_HOME/lib
  ld_library_path_prepend $DYNAWO_LIBIIDM_HOME/lib
  ld_library_path_prepend $DYNAWO_ADEPT_INSTALL_DIR/lib
  ld_library_path_prepend $DYNAWO_XERCESC_INSTALL_DIR/lib
  ld_library_path_prepend $DYNAWO_INSTALL_DIR/lib

  path_prepend $DYNAWO_INSTALL_OPENMODELICA/bin
  python_path_append $DYNAWO_SCRIPTS_DIR

  export_var_env_force DYNAWO_RESOURCES_DIR=$DYNAWO_INSTALL_DIR/share:$DYNAWO_INSTALL_DIR/share/xsd
}

set_compiler() {
  if [ "$DYNAWO_COMPILER" = "GCC" ]; then
    export_var_env_force DYNAWO_COMPILER_NAME=$(echo $DYNAWO_COMPILER | tr "[A-Z]" "[a-z]")
  elif [ "$DYNAWO_COMPILER" = "CLANG" ]; then
    export_var_env_force DYNAWO_COMPILER_NAME=$(echo $DYNAWO_COMPILER | tr "[A-Z]" "[a-z]")
  else
    error_exit "DYNAWO_COMPILER environment variable needs to be GCC or CLANG."
  fi
  export_var_env_force DYNAWO_C_COMPILER=$(command -v $DYNAWO_COMPILER_NAME)
  export_var_env_force DYNAWO_CXX_COMPILER=$(command -v ${DYNAWO_COMPILER_NAME%cc}++) # Trick to remove cc from gcc and leave clang alone, because we want fo find g++ and clang++
}

set_commit_hook() {
  hook_file_msg='#!'"/bin/bash
$DYNAWO_HOME/util/hooks/commit_hook.sh"' $1'
  if [ -f "$DYNAWO_HOME/.git/hooks/commit-msg" ]; then
    current_file=$(cat $DYNAWO_HOME/.git/hooks/commit-msg)
    if [ "$hook_file_msg" != "$current_file" ]; then
      echo "$hook_file_msg" > $DYNAWO_HOME/.git/hooks/commit-msg || error_exit "You need to set commit-msg in .git/hooks."
    fi
    if [ ! -x "$DYNAWO_HOME/.git/hooks/commit-msg" ]; then
      chmod +x $DYNAWO_HOME/.git/hooks/commit-msg || error_exit "commit-msg in .git/hooks needs to be executable."
    fi
  else
    if [ -d "$DYNAWO_HOME/.git" ]; then
      echo "$hook_file_msg" > $DYNAWO_HOME/.git/hooks/commit-msg || error_exit "You need to set commit-msg in .git/hooks."
      chmod +x $DYNAWO_HOME/.git/hooks/commit-msg || error_exit "commit-msg in .git/hooks needs to be executable."
    fi
  fi

  hook_file_master='#!'"/bin/bash
# Avoid committing in master
branch=\"\$(git rev-parse --abbrev-ref HEAD)\"
if [ \"\$branch\" = \"master\" ]; then
  echo \"You can't commit directly to master branch.\"
  exit 1
fi
whitespace_present=no
for file in \$(git diff-index --name-status --cached HEAD | grep -v \"^D\" | grep -v \".*.patch\" | grep -v \".*.png\" | grep -v \"ModelicaCompiler/test\" | grep -v \"reference\" | cut -c3-); do
  if [ ! -z \"\$(git grep --cached \"^[[:space:]]\+\$\" \$file)\" ]; then
    sed -i 's/^[[:space:]]*\$//' \$file
    whitespace_present=yes
  fi
  if [ ! -z \"\$(git grep --cached \"[[:space:]]\+\$\" \$file)\" ]; then
    sed -i 's/[[:space:]]*\$//' \$file
    whitespace_present=yes
  fi
  if [ -n \"\$(git show :\$file | tail -c1)\" ]; then
    if [ -n \"\$(tail -c1 \$file)\" ]; then
      echo >> \$file
    fi
    whitespace_present=yes
  fi
done
tab_present=no
files=()
for file in \$(git diff-index --name-status --cached HEAD | grep -v \"^D\" | grep -v \".*.patch\" | grep -v \".*.png\" | grep -v \"Makefile\" | grep -v \"ModelicaCompiler/test\" | grep -v \"reference\" | cut -c3-); do
  if [ ! -z \"\$(git grep --cached \"$(printf '\t')\" \$file)\" ]; then
    tab_present=yes
    files=(\${files[@]} \$file)
  fi
done
if [ \"\$whitespace_present\" = \"yes\" ]; then
  echo \"Whitespace problems has been corrected on your files. You need to add them to the index and relaunch commit again.\"
  echo
fi
if [ \"\$tab_present\" = \"yes\" ]; then
  echo \"Following files contain tab character, you need to replace them by spaces:\"
  for file in \"\${files[@]}\"; do
    echo \$file
  done
  echo
fi
if [[ \"\$whitespace_present\" == \"yes\" || \"\$tab_present\" == \"yes\" ]]; then
  exit 1
fi
git diff-index --check --cached HEAD -- ':(exclude)*/reference/*' ':(exclude)*.patch'"
  if [ -f "$DYNAWO_HOME/.git/hooks/pre-commit" ]; then
    current_file=$(cat $DYNAWO_HOME/.git/hooks/pre-commit)
    if [ "$hook_file_master" != "$current_file" ]; then
      echo "$hook_file_master" > $DYNAWO_HOME/.git/hooks/pre-commit
    fi
    if [ ! -x "$DYNAWO_HOME/.git/hooks/pre-commit" ]; then
      chmod +x $DYNAWO_HOME/.git/hooks/pre-commit
    fi
  else
    if [ -d "$DYNAWO_HOME/.git" ]; then
      echo "$hook_file_master" > $DYNAWO_HOME/.git/hooks/pre-commit
      chmod +x $DYNAWO_HOME/.git/hooks/pre-commit
    fi
  fi

  if [ -e "$DYNAWO_HOME/.git" ]; then
    if [ -z "$(git --git-dir $DYNAWO_HOME/.git config --get core.commentchar 2> /dev/null)" ] || [ $(git --git-dir $DYNAWO_HOME/.git config --get core.commentchar 2> /dev/null) = "#" ]; then
      git --git-dir $DYNAWO_HOME/.git config core.commentchar % || error_exit "You need to change git config commentchar from # to %."
    fi
  fi
}

display_environment_variables() {
  printenv | grep DYNAWO_ | sort
  echo PATH $PATH
  echo PYTHONPATH $PYTHONPATH
  echo LD_LIBRARY_PATH $LD_LIBRARY_PATH
}

config_3rd_party() {
  CMAKE_OPTIONAL=""
  if [ $DYNAWO_BOOST_HOME_DEFAULT != true ]; then
    CMAKE_OPTIONAL="-DBOOST_ROOT=$DYNAWO_BOOST_HOME"
  fi
  if [ $DYNAWO_ZLIB_HOME_DEFAULT != true ]; then
    CMAKE_OPTIONAL="$CMAKE_OPTIONAL -DZLIB_ROOT=$DYNAWO_ZLIB_HOME"
  fi
  if [ $DYNAWO_LIBARCHIVE_HOME_DEFAULT != true ]; then
    CMAKE_OPTIONAL="$CMAKE_OPTIONAL -DLIBARCHIVE_HOME=$DYNAWO_LIBARCHIVE_HOME"
  fi
  if [ $DYNAWO_LIBXML2_HOME_DEFAULT != true ]; then
    CMAKE_OPTIONAL="$CMAKE_OPTIONAL -DLIBXML2_HOME=$DYNAWO_LIBXML2_HOME"
  fi
  if [ $DYNAWO_BUILD_TESTS = "ON" -o $DYNAWO_BUILD_TESTS_COVERAGE = "ON" ]; then
      if [ $DYNAWO_GTEST_HOME_DEFAULT != true ]; then
        CMAKE_OPTIONAL="$CMAKE_OPTIONAL -DGTEST_ROOT=$DYNAWO_GTEST_HOME"
      fi
  fi
  if [ $DYNAWO_FORCE_CXX11_ABI = true ]; then
    CMAKE_OPTIONAL="$CMAKE_OPTIONAL -DFORCE_CXX11_ABI=$DYNAWO_FORCE_CXX11_ABI"
  fi

  mkdir -p $DYNAWO_THIRD_PARTY_BUILD_DIR/build
  cd $DYNAWO_THIRD_PARTY_BUILD_DIR/build
  cmake $DYNAWO_SRC_DIR/3rdParty \
    -DCMAKE_INSTALL_PREFIX=$DYNAWO_THIRD_PARTY_INSTALL_DIR \
    -DDOWNLOAD_DIR=$DYNAWO_THIRD_PARTY_BUILD_DIR/src \
    -DTMP_DIR=$DYNAWO_THIRD_PARTY_BUILD_DIR/tmp \
    -DCMAKE_C_COMPILER=$DYNAWO_C_COMPILER \
    -DCMAKE_CXX_COMPILER=$DYNAWO_CXX_COMPILER \
    -DUSE_LEGACY_IIDM=$DYNAWO_USE_LEGACY_IIDM \
    -DBOOST_ROOT_DEFAULT:STRING=$DYNAWO_BOOST_HOME_DEFAULT \
    -DCMAKE_BUILD_TYPE=$DYNAWO_BUILD_TYPE \
    -DOPENMODELICA_INSTALL=$DYNAWO_INSTALL_OPENMODELICA \
    -DOPENMODELICA_SRC=$DYNAWO_SRC_OPENMODELICA \
    -G "$DYNAWO_CMAKE_GENERATOR" \
    $CMAKE_OPTIONAL
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

build_3rd_party() {
  config_3rd_party || error_exit "Error with 3rd parties configuration."
  if [ "$DYNAWO_CMAKE_GENERATOR" = "Unix Makefiles" ]; then
    cd $DYNAWO_THIRD_PARTY_BUILD_DIR/build
    available_cmd=($(make help | fgrep '...' | awk '{print $2}'))
    for cmd in "$@"; do
      if ! echo ${available_cmd[*]} | grep -w "$cmd" > /dev/null; then
        echo "$cmd is not a 3rd party target."
        make help
        exit 1
      fi
    done
    make -j $DYNAWO_NB_PROCESSORS_USED $@
  else
    cmake --build $DYNAWO_THIRD_PARTY_BUILD_DIR/build $DYNAWO_CMAKE_BUILD_OPTION --target $@
  fi
  RETURN_CODE=$?
  set_environment
  return ${RETURN_CODE}
}

build_omcDynawo() {
  config_3rd_party || error_exit "Error with 3rd parties configuration."
  if [ "$DYNAWO_CMAKE_GENERATOR" = "Unix Makefiles" ]; then
    cd $DYNAWO_THIRD_PARTY_BUILD_DIR/build
    make -j $DYNAWO_NB_PROCESSORS_USED openmodelica
  else
    cmake --build $DYNAWO_THIRD_PARTY_BUILD_DIR/build $DYNAWO_CMAKE_BUILD_OPTION --target openmodelica
  fi
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

# clean third parties
clean_3rd_party() {
  if [ -d "$DYNAWO_THIRD_PARTY_BUILD_DIR" ]; then
    rm -rf $DYNAWO_THIRD_PARTY_BUILD_DIR
  fi
}

# uninstall third parties
uninstall_3rd_party() {
  if [ -d "$DYNAWO_THIRD_PARTY_INSTALL_DIR" ]; then
    rm -rf $DYNAWO_THIRD_PARTY_INSTALL_DIR
  fi
}

# clean Dynawo
clean_dynawo() {
  rm -rf $DYNAWO_BUILD_DIR
}

# uninstall Dynawo
uninstall_dynawo() {
  rm -rf $DYNAWO_INSTALL_DIR
}

# clean Dynawo, 3rd party
clean_all() {
  clean_3rd_party
  clean_dynawo
}

#uninstall Dynawo, 3rd party
uninstall_all() {
  uninstall_3rd_party
  uninstall_dynawo
}

# Configure Dynawo
config_dynawo() {
  if [ ! -d "$DYNAWO_BUILD_DIR" ]; then
    mkdir -p $DYNAWO_BUILD_DIR
  fi
  cd $DYNAWO_BUILD_DIR

  CMAKE_OPTIONAL=""
  if [ $DYNAWO_BOOST_HOME_DEFAULT != true ]; then
    CMAKE_OPTIONAL="-DBOOST_ROOT=$DYNAWO_BOOST_HOME"
  fi
  if [ $DYNAWO_ZLIB_HOME_DEFAULT != true ]; then
    CMAKE_OPTIONAL="$CMAKE_OPTIONAL -DZLIB_ROOT=$DYNAWO_ZLIB_HOME"
  fi
  if [ $DYNAWO_LIBARCHIVE_HOME_DEFAULT != true ]; then
    CMAKE_OPTIONAL="$CMAKE_OPTIONAL -DLIBARCHIVE_HOME=$DYNAWO_LIBARCHIVE_HOME"
  fi
  if [ $DYNAWO_LIBXML2_HOME_DEFAULT != true ]; then
    CMAKE_OPTIONAL="$CMAKE_OPTIONAL -DLIBXML2_HOME=$DYNAWO_LIBXML2_HOME"
  fi
  if [ $DYNAWO_BUILD_TESTS = "ON" -o $DYNAWO_BUILD_TESTS_COVERAGE = "ON" ]; then
      if [ $DYNAWO_GTEST_HOME_DEFAULT != true ]; then
        CMAKE_OPTIONAL="$CMAKE_OPTIONAL -DGTEST_ROOT=$DYNAWO_GTEST_HOME"
      fi
      if [ $DYNAWO_GMOCK_HOME_DEFAULT != true ]; then
        CMAKE_OPTIONAL="$CMAKE_OPTIONAL -DGMOCK_HOME=$DYNAWO_GMOCK_HOME"
      fi
  fi
  if [ $DYNAWO_FORCE_CXX11_ABI = true ]; then
    CMAKE_OPTIONAL="$CMAKE_OPTIONAL -DFORCE_CXX11_ABI=$DYNAWO_FORCE_CXX11_ABI"
  fi

  cmake -DCMAKE_C_COMPILER:PATH=$DYNAWO_C_COMPILER \
    -DCMAKE_CXX_COMPILER:PATH=$DYNAWO_CXX_COMPILER \
    -DCMAKE_BUILD_TYPE:STRING=$DYNAWO_BUILD_TYPE \
    -DBUILD_TESTS=$DYNAWO_BUILD_TESTS \
    -DBUILD_TESTS_COVERAGE=$DYNAWO_BUILD_TESTS_COVERAGE \
    -DDYNAWO_HOME:PATH=$DYNAWO_HOME \
    -DCMAKE_INSTALL_PREFIX:PATH=$DYNAWO_INSTALL_DIR \
    -DUSE_ADEPT:BOOL=$DYNAWO_USE_ADEPT \
    -DINSTALL_OPENMODELICA:PATH=$DYNAWO_INSTALL_OPENMODELICA \
    -DOPENMODELICA_VERSION:STRING=$DYNAWO_OPENMODELICA_VERSION \
    -DUSE_LEGACY_IIDM=$DYNAWO_USE_LEGACY_IIDM \
    -DBOOST_ROOT_DEFAULT:STRING=$DYNAWO_BOOST_HOME_DEFAULT \
    -DDYNAWO_DEBUG_COMPILER_OPTION:STRING="$DYNAWO_DEBUG_COMPILER_OPTION" \
    -DADEPT_HOME=$DYNAWO_ADEPT_INSTALL_DIR \
    -DSUNDIALS_HOME=$DYNAWO_SUNDIALS_INSTALL_DIR \
    -DSUITESPARSE_HOME=$DYNAWO_SUITESPARSE_INSTALL_DIR \
    -DNICSLU_HOME=$DYNAWO_NICSLU_INSTALL_DIR \
    -DLIBZIP_HOME=$DYNAWO_LIBZIP_INSTALL_DIR \
    -DLIBXML_HOME=$DYNAWO_LIBXML_INSTALL_DIR \
    -DLIBIIDM_HOME=$DYNAWO_LIBIIDM_INSTALL_DIR \
    -DXERCESC_HOME=$DYNAWO_XERCESC_INSTALL_DIR \
    -DDYNAWO_PYTHON_COMMAND="$DYNAWO_PYTHON_COMMAND" \
    $CMAKE_OPTIONAL \
    -G "$DYNAWO_CMAKE_GENERATOR" \
    $DYNAWO_SRC_DIR

  RETURN_CODE=$?
  return ${RETURN_CODE}
}

is_launcher_installed() {
  if [ -x "$DYNAWO_INSTALL_DIR/bin/launcher" ]; then
    return 0
  else
    return 1
  fi
}

install_launcher() {
  build_3rd_party || error_exit "Error during 3rd parties installation."
  config_dynawo || error_exit "Error during Dynawo configuration."
  build_dynawo || error_exit "Error during Dynawo installation."
}

# Compile a modelica model
compile_Modelica_Model() {
  if ! is_launcher_installed; then
    (install_launcher) || error_exit "Error during launcher installation."
  fi
  $DYNAWO_INSTALL_DIR/bin/launcher --compile $@ || error_exit "Error during compilation of a Modelica Model."
}

# Compile Dynawo core (without models)
build_dynawo_core() {
  if [ ! -d "$DYNAWO_BUILD_DIR" ]; then
    error_exit "$DYNAWO_BUILD_DIR does not exist."
  fi
  if [ "$DYNAWO_CMAKE_GENERATOR" = "Unix Makefiles" ]; then
    cd $DYNAWO_BUILD_DIR
    make -j $DYNAWO_NB_PROCESSORS_USED install
  else
    cmake --build $DYNAWO_BUILD_DIR $DYNAWO_CMAKE_BUILD_OPTION --target install
  fi
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

# Compile a Dynawo target, use help to see all targets
build_dynawo_target() {
  if [ ! -d "$DYNAWO_BUILD_DIR" ]; then
    error_exit "$DYNAWO_BUILD_DIR does not exist."
  fi
  if [ "$DYNAWO_CMAKE_GENERATOR" = "Unix Makefiles" ]; then
    cd $DYNAWO_BUILD_DIR
    make -j $DYNAWO_NB_PROCESSORS_USED $@
  else
    cmake --build $DYNAWO_BUILD_DIR $DYNAWO_CMAKE_BUILD_OPTION --config $DYNAWO_BUILD_TYPE --target $@
  fi
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

build_dynawo_models_cpp() {
  if [ ! -d "$DYNAWO_BUILD_DIR" ]; then
    error_exit "$DYNAWO_BUILD_DIR does not exist."
  fi
  if [ "$DYNAWO_CMAKE_GENERATOR" = "Unix Makefiles" ]; then
    cd $DYNAWO_BUILD_DIR
    make -j $DYNAWO_NB_PROCESSORS_USED models-cpp || error_exit "Error during make models-cpp."
  else
    cmake --build $DYNAWO_BUILD_DIR $DYNAWO_CMAKE_BUILD_OPTION --target models-cpp --config $DYNAWO_BUILD_TYPE || error_exit "Error during build models-cpp."
  fi
}

build_dynawo_models() {
  if [ ! -d "$DYNAWO_BUILD_DIR" ]; then
    error_exit "$DYNAWO_BUILD_DIR does not exist."
  fi
  if [ "$DYNAWO_CMAKE_GENERATOR" = "Unix Makefiles" ]; then
    cd $DYNAWO_BUILD_DIR
    make -j $DYNAWO_NB_PROCESSORS_USED models || error_exit "Error during make models."
  else
    cmake --build $DYNAWO_BUILD_DIR $DYNAWO_CMAKE_BUILD_OPTION --target models --config $DYNAWO_BUILD_TYPE || error_exit "Error during build models."
  fi
}

build_dynawo_solvers() {
  if [ ! -d "$DYNAWO_BUILD_DIR" ]; then
    error_exit "$DYNAWO_BUILD_DIR does not exist."
  fi
  if [ "$DYNAWO_CMAKE_GENERATOR" = "Unix Makefiles" ]; then
    cd $DYNAWO_BUILD_DIR
    make -j$DYNAWO_NB_PROCESSORS_USED solvers || error_exit "Error during make solvers."
  else
    cmake --build $DYNAWO_BUILD_DIR $DYNAWO_CMAKE_BUILD_OPTION --target solvers --config $DYNAWO_BUILD_TYPE || error_exit "Error during build solvers."
  fi
}

# Compile Dynawo (core + models)
build_dynawo() {
  if [ ! -d "$DYNAWO_BUILD_DIR" ]; then
    error_exit "$DYNAWO_BUILD_DIR does not exist."
  fi
  cd $DYNAWO_BUILD_DIR
  build_dynawo_core || error_exit "Error during build_dynawo_core."
  build_dynawo_models_cpp || error_exit "Error during build_dynawo_models_cpp."
  build_dynawo_models || error_exit "Error during build_dynawo_models."
  build_dynawo_solvers
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

build_dynaX() {
  config_dynawo || error_exit "Error during config_dynawo."
  if [ ! -d "$DYNAWO_BUILD_DIR" ]; then
    error_exit "$DYNAWO_BUILD_DIR does not exist."
  fi
  cd $DYNAWO_BUILD_DIR
  build_dynawo_core || error_exit "Error during build_dynawo_core."
  build_dynawo_models_cpp || error_exit "Error during build_dynawo_models_cpp."
  build_dynawo_solvers || error_exit "Error during build_dynawo_solvers."
  build_dynawo_target $@
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

build_dynaflow() {
  build_dynaX DYNAFLOW_MODELS || error_exit "Error during build_dynaflow."
}

build_dynaswing() {
  build_dynaX DYNASWING_MODELS || error_exit "Error during build_dynaflow."
}

build_user() {
  install_launcher || error_exit "Error during Dynawo installation."
}

# Compile Dynawo and its dependencies
build_all() {
  build_3rd_party || error_exit "Error during build_3rd_party."
  config_dynawo || error_exit "Error during config_dynawo."
  build_dynawo || error_exit "Error during build_dynawo."
  build_test_doxygen_doc || error_exit "Error during build_test_doxygen_doc."
}

build_tests() {
  build_3rd_party || error_exit "Error during build_3rd_party."
  config_dynawo || error_exit "Error during config_dynawo."
  ## for unit test, no need to generate modelica models
  build_dynawo_core || error_exit "Error during build_dynawo_core."
  build_dynawo_models_cpp || error_exit "Error during build_dynawo_models_cpp."

  tests=$@
  if [ -z "$tests" ]; then
    cmake --build $DYNAWO_BUILD_DIR --target tests --config Debug
  else
    cmake --build $DYNAWO_BUILD_DIR --target ${tests} --config Debug
  fi

  RETURN_CODE=$?
  if [ ${RETURN_CODE} -ne 0 ]; then
    return ${RETURN_CODE}
  fi

  echo "#######################"
  echo "Running python tests"
  echo "#######################"
  ${DYNAWO_PYTHON_COMMAND} $DYNAWO_NRT_DIFF_DIR/test/nrtDiffTest.py
  RETURN_CODE=$?
  if [ ${RETURN_CODE} -ne 0 ]; then
    return ${RETURN_CODE}
  fi
  ${DYNAWO_PYTHON_COMMAND} $DYNAWO_NRT_DIFF_DIR/test/nrtUtilsTests.py
  if [ ${RETURN_CODE} -ne 0 ]; then
    return ${RETURN_CODE}
  fi
  ${DYNAWO_PYTHON_COMMAND} $DYNAWO_NRT_DIFF_DIR/test/defineTestReferenceTests.py
  if [ ${RETURN_CODE} -ne 0 ]; then
    return ${RETURN_CODE}
  fi
  return ${RETURN_CODE}
}

list_tests() {
  build_3rd_party > /dev/null 2>&1 || error_exit "Error during build_3rd_party."
  echo "===================================="
  echo " List of available unittests target"
  echo "===================================="
  config_dynawo > /dev/null 2>&1 || error_exit "Error during config_dynawo."
  if [ "$DYNAWO_CMAKE_GENERATOR" = "Unix Makefiles" ]; then
    cmake --build $DYNAWO_BUILD_DIR --target help | grep -Ei 'tests' | grep -Eiv 'pre-tests'
  else
    error_exit "Option not available with $DYNAWO_CMAKE_GENERATOR CMake generator. Use Unix Makefiles."
  fi
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

verify_browser() {
  if [ ! -x "$(command -v $DYNAWO_BROWSER)" ]; then
    error_exit "Specified browser DYNAWO_BROWSER=$DYNAWO_BROWSER not found."
  fi
}

build_tests_coverage() {
  build_3rd_party || error_exit "Error during build_3rd_party."
  config_dynawo || error_exit "Error during config_dynawo."
  ## for unit test, no need to generate modelica models
  build_dynawo_core || error_exit "Error during build_dynawo_core."
  build_dynawo_models_cpp || error_exit "Error during build_dynawo_models_cpp."
  if ${DYNAWO_PYTHON_COMMAND} -c "import coverage" &> /dev/null; then
    DYNAWO_PYTHON_COMMAND_SAVE=${DYNAWO_PYTHON_COMMAND}
    export_var_env_force DYNAWO_PYTHON_COMMAND="coverage run"
  fi
  tests=$@

  cmake --build $DYNAWO_BUILD_DIR --target reset-coverage --config Debug || error_exit "Error during make reset-coverage."
  if [ -z "$tests" ]; then
    cmake --build $DYNAWO_BUILD_DIR --target tests-coverage --config Debug || error_exit "Error during make tests-coverage."
  else
    for test in ${tests}; do
      cmake --build $DYNAWO_BUILD_DIR --target ${test}-coverage --config Debug || error_exit "Error during make ${test}-coverage."
    done
  fi
  cmake --build $DYNAWO_BUILD_DIR --target export-coverage --config Debug
  RETURN_CODE=$?
  if [ ${RETURN_CODE} -ne 0 ]; then
    exit ${RETURN_CODE}
  fi
  if [ "$DYNAWO_RESULTS_SHOW" = true ] ; then
    verify_browser
    $DYNAWO_BROWSER $DYNAWO_BUILD_DIR/coverage/index.html
  fi
  cp $DYNAWO_BUILD_DIR/coverage/coverage.info $DYNAWO_HOME/build
  if [ -d "$DYNAWO_HOME/build/coverage-sonar" ]; then
    rm -rf "$DYNAWO_HOME/build/coverage-sonar"
  fi
  mkdir -p $DYNAWO_HOME/build/coverage-sonar || error_exit "Impossible to create $DYNAWO_HOME/build/coverage-sonar."
  cd $DYNAWO_HOME/build/coverage-sonar
  for file in $(find $DYNAWO_BUILD_DIR -name "*.gcno" | grep -v "/test/"); do
    cpp_file_name=$(basename $file .gcno)
    cpp_file=$(find $DYNAWO_HOME/dynawo/sources -name "$cpp_file_name" 2> /dev/null)
    gcov -pb $cpp_file -o $file > /dev/null
  done
  find $DYNAWO_HOME/build/coverage-sonar -type f -not -name "*dynawo*" -exec rm -f {} \;
  if ${DYNAWO_PYTHON_COMMAND_SAVE} -c "import coverage" &> /dev/null; then
    echo "### Generating python coverage"
    PYTHON_COVERAGE_FILES=""
    for file in $(find $DYNAWO_BUILD_DIR -name ".coverage"); do
     PYTHON_COVERAGE_FILES="$file $PYTHON_COVERAGE_FILES"
     echo "   Found: $file"
    done
    coverage combine $PYTHON_COVERAGE_FILES || error_exit "Impossible to combine coverage files $PYTHON_COVERAGE_FILES"
    mkdir -p $DYNAWO_HOME/build/coverage-sonar/coverage-python || error_exit "Impossible to create $DYNAWO_HOME/build/coverage-sonar/coverage-python."
    coverage xml -o $DYNAWO_HOME/build/coverage-sonar/coverage-python/coverage.xml || error_exit "Impossible to generate python XML coverage file."
    export_var_env_force DYNAWO_PYTHON_COMMAND=${DYNAWO_PYTHON_COMMAND_SAVE}
    ${DYNAWO_PYTHON_COMMAND} $DYNAWO_HOME/util/ci/correctCoberturaPaths.py
  fi
}

clean_models() {
  if [ $# -eq 0 ]; then
    echo "No model given as argument."
    return 0
  fi
  for model in `echo $@`; do
    rm -rf $DYNAWO_BUILD_DIR/M/M/P/${model}*
  done
}

clean_build_models() {
  clean_models $@
  if [ $# -eq 0 ]; then
    return 0
  fi
  for model in `echo $@`; do
    if ! list_models | grep -w $model &> /dev/null; then
      error_exit "$model is not a valid model to build."
    fi
  done
  build_dynawo_target $@
}

list_models() {
  ls -l ${DYNAWO_HOME}/dynawo/sources/Models/Modelica/PreassembledModels/*.xml | awk '{print $NF}' | xargs -i basename {} '.xml'
}

clean_tests() {
  clean_dynawo || error_exit
  uninstall_dynawo || error_exit
}

clean_tests_coverage() {
  clean_dynawo || error_exit
  uninstall_dynawo || error_exit
}

clean_old_dir() {
  directory=$1
  cd ${directory}
  shift 1
  branches=$@

  nbdir=$(find . -maxdepth 1 -type d | wc -l) # count . as a dir
  if [ $nbdir -eq 1 ]; then
    return
  fi

  directories=$(ls -d */ | cut -f1 -d'/')
  for d in $directories; do
    branch_exist="false"
    for b in ${branches}; do
      if [[ "${b}" = "${d}" ]]; then
        branch_exist="true"
        break
      fi
    done
    if [[ "${branch_exist}" = "false" ]]; then
      rm -rvf ${directory}/${d}
    fi
  done
}

# Clean build/install/nrt of old branches
clean_old_branches() {
  current_dir=$PWD
  cd ${DYNAWO_HOME}
  branches=$(git for-each-ref --format='%(refname:short)' refs/heads)
  # clean old directories in build_dir, nrt and install
  clean_old_dir ${DYNAWO_HOME}/build/ ${branches}
  clean_old_dir ${DYNAWO_HOME}/install/ ${branches}

  if [ -d "${DYNAWO_HOME}/nrt/output/" ]; then
    clean_old_dir ${DYNAWO_HOME}/nrt/output/ ${branches}
  fi

  cd ${current_dir}
}

# Clean, then configure and build dynawo
clean_build_dynawo() {
  clean_dynawo || error_exit
  uninstall_dynawo || error_exit
  config_dynawo || error_exit
  build_dynawo || error_exit
}

# Remove all built files, then generate them all again
clean_build_all() {
  clean_all || error_exit
  uninstall_all || error_exit
  build_all || error_exit
}

# Clean then build 3rd party libraries
clean_build_3rd_party() {
  clean_3rd_party || error_exit
  uninstall_3rd_party || error_exit
  build_3rd_party || error_exit
}

# validate a given version before commit
version_validation() {
  clean_build_all || error_exit
  create_distrib || error_exit
  nrt || error_exit
}

# Compile Dynawo Doxygen doc
build_test_doxygen_doc() {
  build_doxygen_doc || error_exit
  test_doxygen_doc || error_exit
}

build_doxygen_doc() {
  if [ ! -d "$DYNAWO_BUILD_DIR" ]; then
    error_exit "You need to build Dynawo first to build doxygen documentation."
  fi
  mkdir -p $DYNAWO_INSTALL_DIR/doxygen/
  cmake --build $DYNAWO_BUILD_DIR --target doc
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

test_doxygen_doc() {
  if [ -f "$DYNAWO_INSTALL_DIR/doxygen/warnings.txt"  ] ; then
    rm -f $DYNAWO_INSTALL_DIR/doxygen/warnings_filtered.txt
    # need to filter "return type of member (*) is not documented" as it is a doxygen bug detected on 1.8.17 that will be solved in 1.8.18
    grep -Fvf $DYNAWO_HOME/util/warnings_to_filter.txt $DYNAWO_INSTALL_DIR/doxygen/warnings.txt > $DYNAWO_INSTALL_DIR/doxygen/warnings_filtered.txt
    nb_warnings=$(wc -l $DYNAWO_INSTALL_DIR/doxygen/warnings_filtered.txt | awk '{print $1}')
    if [ ${nb_warnings} -ne 0 ]; then
      echo "===================================="
      echo "| Result of doxygen doc generation |"
      echo "===================================="
      echo " nbWarnings = ${nb_warnings} > 0 => doc is incomplete"
      echo " edit ${DYNAWO_INSTALL_DIR}/doxygen/warnings_filtered.txt  to have more details"
      error_exit "Doxygen doc is not complete"
    fi
  fi
}

open_modelica_doc() {
  error_exit "Not available for the moment."
  # open_pdf $DYNAWO_HOME/documentation/ModelicaDocumentation/model_documentation.pdf
}

launch_jobs() {
  if ! is_launcher_installed; then
    install_launcher || error_exit "Error during launcher installation."
  fi
  $DYNAWO_INSTALL_DIR/bin/launcher $@
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

generate_preassembled() {
  if ! is_launcher_installed; then
    install_launcher || error_exit "Error during launcher installation."
  fi
  $DYNAWO_INSTALL_DIR/bin/launcher --generate-preassembled $*
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

generate_preassembled_gdb() {
  if ! is_launcher_installed; then
    install_launcher || error_exit "Error during launcher installation."
  fi
  $DYNAWO_INSTALL_DIR/bin/launcher --generate-preassembled-gdb $*
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

compile_cpp_modelica_model_in_dynamic_lib() {
  if ! is_launcher_installed; then
    install_launcher || error_exit "Error during launcher installation."
  fi
  $DYNAWO_INSTALL_DIR/bin/launcher --compile-cpp-modelica-model-in-dynamic-lib $*
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

install_jquery() {
  JQUERY_VERSION=1.3.2
  JQUERY_ARCHIVE=$JQUERY_VERSION.tar.gz

  FLOT_VERSION=0.6.0
  FLOT_ARCHIVE=v$FLOT_VERSION.tar.gz

  if [ ! -x "$(command -v tar)" ]; then
    error_exit "You need to install tar command line utility."
  fi

  JQUERY_BUILD_DIR=$DYNAWO_HOME/build/3rdParty/jquery
  mkdir -p $JQUERY_BUILD_DIR

  if [ ! -f "$DYNAWO_HOME/util/curvesToHtml/resources/jquery.js" ]; then
    if [ ! -f "$JQUERY_BUILD_DIR/${JQUERY_ARCHIVE}" ]; then
      if [ -x "$(command -v wget)" ]; then
        wget --timeout 10 --tries 3 ${DYNAWO_JQUERY_DOWNLOAD_URL}/${JQUERY_ARCHIVE} -P $JQUERY_BUILD_DIR || error_exit "Error while downloading Jquery."
      elif [ -x "$(command -v curl)" ]; then
        curl -L --connect-timeout 10 --retry 2 ${DYNAWO_JQUERY_DOWNLOAD_URL}/${JQUERY_ARCHIVE} -o $JQUERY_BUILD_DIR/${JQUERY_ARCHIVE} || error_exit "Error while downloading Jquery."
      else
        error_exit "You need to install either wget or curl."
      fi
    fi
    if [ -f "$JQUERY_BUILD_DIR/${JQUERY_ARCHIVE}" ]; then
      if [ ! -d "$JQUERY_BUILD_DIR/jquery-$JQUERY_VERSION" ]; then
        tar xzf $JQUERY_BUILD_DIR/${JQUERY_ARCHIVE} -C $JQUERY_BUILD_DIR || error_exit "Error while tar Jquery."
      fi
      if [ -d "$JQUERY_BUILD_DIR/jquery-$JQUERY_VERSION" ]; then
        cp "$JQUERY_BUILD_DIR/jquery-$JQUERY_VERSION/jquery.js" "$DYNAWO_HOME/util/curvesToHtml/resources/jquery.js"
      fi
    fi
  fi

  flot_files=(jquery.flot.crosshair.js jquery.flot.js jquery.flot.navigate.js jquery.flot.selection.js arrow-down.gif arrow-left.gif arrow-right.gif arrow-up.gif)
  for file in ${flot_files[*]}; do
    if [ ! -f "$DYNAWO_HOME/util/curvesToHtml/resources/$file" ]; then
      if [ ! -f "$JQUERY_BUILD_DIR/${FLOT_ARCHIVE}" ]; then
        if [ -x "$(command -v wget)" ]; then
          wget --timeout 10 --tries 3 ${DYNAWO_FLOT_DOWNLOAD_URL}/${FLOT_ARCHIVE} -P $JQUERY_BUILD_DIR || error_exit "Error while downloading Flot."
        elif [ -x "$(command -v curl)" ]; then
          curl -L --connect-timeout 10 --retry 2 ${DYNAWO_FLOT_DOWNLOAD_URL}/${FLOT_ARCHIVE} --output $JQUERY_BUILD_DIR/${FLOT_ARCHIVE} || error_exit "Error while downloading Flot."
        else
          error_exit "You need to install either wget or curl."
        fi
      fi
      if [ -f "$JQUERY_BUILD_DIR/${FLOT_ARCHIVE}" ]; then
        if [ ! -d "flot-$FLOT_VERSION" ]; then
          tar xzf $JQUERY_BUILD_DIR/${FLOT_ARCHIVE} -C $JQUERY_BUILD_DIR || error_exit "Error while tar Flot."
        fi
        if [ -d "$JQUERY_BUILD_DIR/flot-$FLOT_VERSION" ]; then
          if `expr $file : "arrow-.*" > /dev/null`; then
            cp "$JQUERY_BUILD_DIR/flot-$FLOT_VERSION/examples/$file" "$DYNAWO_HOME/util/curvesToHtml/resources/$file"
          else
            cp "$JQUERY_BUILD_DIR/flot-$FLOT_VERSION/$file" "$DYNAWO_HOME/util/curvesToHtml/resources/$file"
          fi
        fi
      fi
    fi
  done
}

jobs_with_curves() {
  install_jquery
  launch_jobs $@ || error_exit "Dynawo job failed."
  echo "Generating curves visualization pages"
  curves_visu $@ || error_exit "Error during curves visualisation page generation"
  echo "End of generating curves visualization pages"
}

curves_visu() {
  verify_browser
  $DYNAWO_PYTHON_COMMAND $DYNAWO_CURVES_TO_HTML_DIR/curvesToHtml.py --jobsFile=$("$DYNAWO_PYTHON_COMMAND" -c "import os; print(os.path.realpath('$1'))") --withoutOffset --htmlBrowser="$DYNAWO_BROWSER" || return 1
}

curves_visu_reference_same_graph() {
  verify_browser
  $DYNAWO_PYTHON_COMMAND $DYNAWO_CURVES_TO_HTML_DIR/curvesToHtml.py --jobsFile=$("$DYNAWO_PYTHON_COMMAND" -c "import os; print(os.path.realpath('$1'))") --withoutOffset --htmlBrowser="$DYNAWO_BROWSER" --plotRef || return 1
}

curves_visu_reference() {
  jobs=$("$DYNAWO_PYTHON_COMMAND" -c "import os; print(os.path.realpath('$1'))")
  sed -i 's/<dyn:outputs directory="/<dyn:outputs directory="reference\//' $jobs
  sed -i 's/<outputs directory="/<outputs directory="reference\//' $jobs
  curves_visu $jobs
  sed -i 's/<dyn:outputs directory="reference\//<dyn:outputs directory="/' $jobs
  sed -i 's/<outputs directory="reference\//<outputs directory="/' $jobs
}

dump_model() {
  if ! is_launcher_installed; then
    install_launcher || error_exit "Error during launcher installation."
  fi
  $DYNAWO_INSTALL_DIR/bin/launcher --dump-model $@
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

valgrind_dump_model() {
  if ! is_launcher_installed; then
    install_launcher || error_exit "Error during launcher installation."
  fi
  $DYNAWO_INSTALL_DIR/bin/launcher --dump-model-valgrind $@
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

gdb_dump_model() {
  if ! is_launcher_installed; then
    install_launcher || error_exit "Error during launcher installation."
  fi
  $DYNAWO_INSTALL_DIR/bin/launcher --dump-model-gdb $@
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

open_doxygen_doc() {
  if [ ! -f "$DYNAWO_INSTALL_DIR/doxygen/html/index.html" ]; then
    echo "Doxygen documentation not yet generated"
    echo "Generating ..."
    build_test_doxygen_doc
    RETURN_CODE=$?
    if [ ${RETURN_CODE} -ne 0 ]; then
      exit ${RETURN_CODE}
    fi
    echo "... end of doc generation"
  fi
  verify_browser
  $DYNAWO_BROWSER $DYNAWO_INSTALL_DIR/doxygen/html/index.html
}

version() {
  if ! is_launcher_installed; then
    (install_launcher > /dev/null 2>&1) || error_exit "Error during launcher installation."
  fi
  $DYNAWO_INSTALL_DIR/bin/launcher --version
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

nrt() {
  if ! is_launcher_installed; then
    install_launcher || error_exit "Error during launcher installation."
  fi
  pushd "$DYNAWO_HOME" > /dev/null
  $DYNAWO_PYTHON_COMMAND -u $DYNAWO_NRT_DIR/nrt.py $@
  FAILED_CASES_NUM=$?
  popd > /dev/null

  jenkins_mode=$(printenv | grep "DYNAWO_JENKINS_MODE" | wc -l)

  if [ ${jenkins_mode} -ne 0 ]; then
    if [ ! -f "$DYNAWO_NRT_DIR/output/report.html" ]; then
      error_exit "No report was generated by the non regression test script"
    fi
  else
    if [ ! -f "$DYNAWO_NRT_DIR/output/$DYNAWO_BRANCH_NAME/report.html" ]; then
      error_exit "No report was generated by the non regression test script"
    fi
    if [ "$DYNAWO_RESULTS_SHOW" = true ] ; then
      verify_browser
      $DYNAWO_BROWSER $DYNAWO_NRT_DIR/output/$DYNAWO_BRANCH_NAME/report.html &
    fi
  fi

  if [ ${FAILED_CASES_NUM} -ne 0 ]; then
    error_exit "${FAILED_CASES_NUM} non regression tests failed"
  fi
  if [ "$DYNAWO_BUILD_TYPE" = "Debug" ]; then
    echo "Warning: Debug mode is activated, references comparison was not done"
  fi
}

nrt_clean() {
  find $DYNAWO_NRT_DIR/data -depth -type d -name "outputs*" -not -path "*reference*/*" -exec rm -rf {} \; > /dev/null 2>&1
  find $DYNAWO_EXAMPLES_DIR -depth -type d -name "outputs*" -not -path "*reference*/*" -exec rm -rf {} \; > /dev/null 2>&1
  rm -rf $DYNAWO_NRT_DIR/output
  rm -rf $DYNAWO_HOME/util/nrt_diff/output
  find $DYNAWO_NRT_DIR -name "*.pyc" -exec rm -rf {} \;
  find $DYNAWO_HOME/util/nrt_diff -name "*.pyc" -exec rm -rf {} \;
  find $DYNAWO_NRT_DIR/data -empty -type d -delete
}

run_documentation_test() {
  if ! is_launcher_installed; then
    install_launcher || error_exit "Error during launcher installation."
  fi

  DYNAWO_DOCUMENTATION_DIR="$DYNAWO_HOME/documentation"

  # compile_Modelica_Model
  # First example: Modelica model with no external variables
  pushd $DYNAWO_DOCUMENTATION_DIR/resources/exampleExecutables/TestCompile/Basic > /dev/null
  compile_Modelica_Model --model Test --compilation-dir compilation --model-dir . || error_exit "Error during example 1 of compile_Modelica_Model (c++ files generation)"
  if [ ! -f "compilation/Test_Dyn.cpp" ]; then
    error_exit "Error during example 1 of compile_Modelica_Model (c++ files generation): cannot find expected output"
  fi
  rm -rf $DYNAWO_DOCUMENTATION_DIR/resources/exampleExecutables/TestCompile/Basic/compilation

  compile_Modelica_Model --model Test --lib Test.so || error_exit "Error during example 1 of compile_Modelica_Model (model compilation)"
  if [ ! -f "Test.so" ]; then
    error_exit "Error during example 1 of compile_Modelica_Model (model compilation): cannot find expected output"
  fi

  mv Test.so BlackBox/.
  mv Test_Dyn_definition.h BlackBox/.
  pushd BlackBox  > /dev/null
  launch_jobs Test.jobs  || error_exit "Error during example 1 of compile_Modelica_Model (dynawo simulation with blackbox)"
  if [ ! -f "outputs/curves/curves.csv" ]; then
    error_exit "Error during example 1 of compile_Modelica_Model (dynawo simulation with blackbox): cannot find expected output"
  fi
  rm -rf Test.so
  rm -rf Test_Dyn_definition.h
  rm -rf outputs
  popd > /dev/null #BlackBox

  launch_jobs Test.jobs  || error_exit "Error during example 1 of compile_Modelica_Model (dynawo simulation with model compilation)"
  if [ ! -f "outputs/curves/curves.csv" ]; then
    error_exit "Error during example 1 of compile_Modelica_Model (dynawo simulation with model compilation): cannot find expected output"
  fi
  rm -rf outputs
  popd > /dev/null #$DYNAWO_DOCUMENTATION_DIR/resources/exampleExecutables/TestCompile/Basic

  # Second example: Modelica model with external variables
  pushd $DYNAWO_DOCUMENTATION_DIR/resources/exampleExecutables/TestCompile/ExternalVariables > /dev/null
  compile_Modelica_Model --model Test --lib Test.so || error_exit "Error during example 2 of compile_Modelica_Model (model compilation)"
  if [ ! -f "Test.so" ]; then
    error_exit "Error during example 2 of compile_Modelica_Model (model compilation): cannot find expected output"
  fi
  rm -rf Test.so
  rm -rf Test_Dyn_definition.h
  popd > /dev/null #$DYNAWO_DOCUMENTATION_DIR/resources/exampleExecutables/TestCompile/ExternalVariables

  # generate-preassembled
  # First example: Model with fully connected external variables
  pushd $DYNAWO_DOCUMENTATION_DIR/resources/exampleExecutables/TestPreassembledNoExternal > /dev/null
  generate_preassembled --model-list Test.xml --non-recursive-modelica-models-dir . || error_exit "Error during example 1 of generate-preassembled (model compilation no external)"
    if [ ! -f "Test.so" ]; then
    error_exit "Error during example 1 of generate-preassembled (model compilation no external): cannot find expected output"
  fi
  mv Test.so SimulationCompiledLib/.
  mv Test_Dyn_definition.h SimulationCompiledLib/.
  mv Test.mo SimulationCompiledLib/.
  pushd SimulationCompiledLib  > /dev/null
  launch_jobs Test.jobs  || error_exit "Error during example 1 of generate-preassembled (dynawo simulation with blackbox)"
  if [ ! -f "outputs/curves/curves.csv" ]; then
    error_exit "Error during example 1 of generate-preassembled (dynawo simulation with blackbox): cannot find expected output"
  fi
  rm -rf Test.so
  rm -rf Test.mo
  rm -rf Test_Dyn_definition.h
  rm -rf outputs
  popd > /dev/null #SimulationCompiledLib

  pushd Simulation  > /dev/null
  launch_jobs Test.jobs  || error_exit "Error during example 1 of generate-preassembled (dynawo simulation with model compilation)"
  if [ ! -f "outputs/curves/curves.csv" ]; then
    error_exit "Error during example 1 of generate-preassembled (dynawo simulation with model compilation): cannot find expected output"
  fi
  rm -rf outputs
  popd > /dev/null #Simulation
  popd > /dev/null #$DYNAWO_DOCUMENTATION_DIR/resources/exampleExecutables/TestPreassembledNoExternal

  # Second example: Model with partially connected external variables
  pushd $DYNAWO_DOCUMENTATION_DIR/resources/exampleExecutables/TestPreassembled > /dev/null
  generate_preassembled --model-list Test.xml --non-recursive-modelica-models-dir . || error_exit "Error during example 2 of generate-preassembled (model compilation)"
  if [ ! -f "Test.so" ]; then
    error_exit "Error during example 2 of generate-preassembled (model compilation): cannot find expected output"
  fi
  if [ ! -f "Test.mo" ]; then
    error_exit "Error during example 2 of generate-preassembled (model compilation): cannot find expected output"
  fi
  if [ ! -f "Test.extvar" ]; then
    error_exit "Error during example 2 of generate-preassembled (model compilation): cannot find expected output"
  fi
  rm -rf Test.so
  rm -rf Test.mo
  rm -rf Test.extvar
  rm -rf Test_Dyn_definition.h
  popd > /dev/null #$DYNAWO_DOCUMENTATION_DIR/resources/exampleExecutables/TestPreassembled

  # dump-model
  pushd $DYNAWO_DOCUMENTATION_DIR/resources/exampleExecutables/TestCompile/Basic > /dev/null
  compile_Modelica_Model --model Test --lib Test.so || error_exit "Error during example 1 of dump-model (model compilation)"
  dump_model -m ./Test.so -o Test.desc.xml || error_exit "Error during example 1 of dump-model (dump-model)"
  if [ ! -f "Test.desc.xml" ]; then
    error_exit "Error during example 1 of dump-model: cannot find expected output"
  fi
  rm -rf Test.so
  rm -rf Test.desc.xml
  rm -rf Test_Dyn_definition.h
  popd > /dev/null #$DYNAWO_DOCUMENTATION_DIR/resources/exampleExecutables/TestCompile/Basic
}


nrt_diff() {
  $DYNAWO_PYTHON_COMMAND $DYNAWO_NRT_DIFF_DIR/nrtDiff.py $@
}

nrt_ref() {
  $DYNAWO_PYTHON_COMMAND $DYNAWO_NRT_DIFF_DIR/defineTestReference.py $@
}

nrt_xsl() {
  export_var_env_force DYNAWO_NRT_SCRIPT_DIR=$DYNAWO_NRT_DIR
  $DYNAWO_PYTHON_COMMAND $DYNAWO_HOME/util/xsl/applyXsltToXml.py $@
}

check_coding_files() {
  # html escape .dic files for dictionary
  for dicfile in $(find $DYNAWO_INSTALL_DIR -iname '*.dic')
  do
    iconv -t iso8859-1 -f utf-8 "$dicfile" > "$dicfile.new" && mv -f "$dicfile.new" "$dicfile"
  done
}

find_lib_system_path() {
  if [ -z "$1" ]; then
    error_exit "You need to give the name of the library to search."
  fi
  local path
  if [ ! -f "$DYNAWO_INSTALL_DIR/bin/dynawo" ]; then
    error_exit "Dynawo binary should exist to deploy and find system library used to link against it."
  fi
  if [ "`uname`" = "Linux" ]; then
    path=$(ldd $DYNAWO_INSTALL_DIR/bin/dynawo | grep "$1" | cut -d '>' -f 2 | awk '{print $1}' | sed "s/lib$1.*//g"  | uniq)
  else
    echo "OS not supported."
    exit 1
  fi
  if [ -z "$path" ]; then
    error_exit "Could not find any path for $1 library, it should not happen so an issue must be addressed to the Dynawo team."
  fi
  echo -n $path
}

find_include_system_path() {
  if [ -z "$1" ]; then
    error_exit "You need to give the name of the library to search."
  fi
  local path
  if [ ! -f "$DYNAWO_BUILD_DIR/CMakeCache.txt" ]; then
    error_exit "$DYNAWO_BUILD_DIR should not be deleted before deploy to be able to determine include system paths used during compilation."
  fi
  path=$(cat $DYNAWO_BUILD_DIR/CMakeCache.txt | grep "$1":PATH | cut -d '=' -f 2)
  if [ -z "$path" ]; then
    error_exit "Could not find any path for $1 library, it should not happen so an issue must be addressed to the Dynawo team."
  fi
  echo -n $path
}

export_var_env_to_file() {
  export | grep DYNAWO_ | sed -e 's/declare -x //g' > "$1"
}

deploy_dynawo() {
  DYNAWO_VERSION=$(version) || error_exit "Error with version."
  version=$(echo $DYNAWO_VERSION | cut -f1 -d' ')
  rm -rf $DYNAWO_DEPLOY_DIR

  # check coding
  check_coding_files

  current_dir=$PWD
  mkdir -p $DYNAWO_DEPLOY_DIR || error_exit "Impossible to create $DYNAWO_DEPLOY_DIR."
  cd $DYNAWO_DEPLOY_DIR
  export_var_env_to_file "dynawoEnv.txt"
  mkdir -p lib
  mkdir -p bin

  echo "deploying Sundials libraries"
  cp -P $DYNAWO_SUNDIALS_INSTALL_DIR/lib*/*.* lib/
  echo "deploying Adept libraries"
  cp -P $DYNAWO_ADEPT_INSTALL_DIR/lib/*.* lib/
  echo "deploying SuiteSparse libraries"
  cp -P $DYNAWO_SUITESPARSE_INSTALL_DIR/lib/*.* lib/
  if [ -d "$DYNAWO_NICSLU_INSTALL_DIR/lib" ]; then
    if [ ! -z "$(ls -A $DYNAWO_NICSLU_INSTALL_DIR/lib)" ]; then
      echo "deploying Nicslu libraries"
      cp -P $DYNAWO_NICSLU_INSTALL_DIR/lib/*.* lib/
    fi
  fi
  echo "deploying libzip libraries"
  cp -P $DYNAWO_LIBZIP_HOME/lib/*.* lib/
  echo "deploying libxml libraries"
  cp -P $DYNAWO_LIBXML_HOME/lib/*.* lib/
  echo "deploying libiidm libraries"
  cp -P $DYNAWO_LIBIIDM_HOME/lib/*.* lib/
  if [ -d "$DYNAWO_LIBIIDM_HOME/bin" ]; then
    cp -n -R -P $DYNAWO_LIBIIDM_HOME/bin/* bin/
  fi
  if [ "$DYNAWO_BUILD_TYPE" = "Debug" ]; then
    if [ $DYNAWO_GTEST_HOME_DEFAULT != true ]; then
      echo "deploying gtest libraries"
      cp -P $DYNAWO_GTEST_HOME/lib*/*.* lib/
    fi
  fi


  if [ ! -d "$DYNAWO_DEPLOY_DIR" ]; then
    error_exit "$DYNAWO_DEPLOY_DIR does not exist."
  fi
  cd $DYNAWO_DEPLOY_DIR

  mkdir -p include
  echo "deploying Sundials include folder"
  cp -n -R -P $DYNAWO_SUNDIALS_INSTALL_DIR/include/* include/
  echo "deploying Adept include folder"
  cp -n -R $DYNAWO_ADEPT_INSTALL_DIR/include/* include/
  echo "deploying SuiteSparse include folder"
  cp -n -P $DYNAWO_SUITESPARSE_INSTALL_DIR/include/*.* include/
  if [ -d "$DYNAWO_NICSLU_INSTALL_DIR/include" ]; then
    if [ ! -z "$(ls -A $DYNAWO_NICSLU_INSTALL_DIR/include)" ]; then
      echo "deploying Nicslu include folder"
      cp -n -P $DYNAWO_NICSLU_INSTALL_DIR/include/*.* include/
    fi
  fi
  echo "deploying libzip include folder"
  cp -n -R -P $DYNAWO_LIBZIP_HOME/include/libzip include/
  echo "deploying libxml include folder"
  cp -n -R -P $DYNAWO_LIBXML_HOME/include/xml include/
  echo "deploying libiidm include folder"
  if [ -d "$DYNAWO_LIBIIDM_HOME/include/IIDM" ]; then
    cp -n -R -P $DYNAWO_LIBIIDM_HOME/include/IIDM include/
  fi
  if [ -d "$DYNAWO_LIBIIDM_HOME/include/powsybl" ]; then
    cp -n -R -P $DYNAWO_LIBIIDM_HOME/include/powsybl include/
  fi
  echo "deploying gtest include folder"
  if [ "$DYNAWO_BUILD_TYPE" = "Debug" ]; then
    if [ $DYNAWO_GTEST_HOME_DEFAULT != true ]; then
      echo "deploying gtest libraries"
      cp -n -R -P $DYNAWO_GTEST_HOME/include/* include/
    fi
  fi

  mkdir -p share
  cp -R -P $DYNAWO_LIBXML_HOME/share/cmake share/
  if [ -d "$DYNAWO_LIBIIDM_HOME/share" ]; then
    cp -R -P $DYNAWO_LIBIIDM_HOME/share/cmake share/
    cp -R -P $DYNAWO_LIBIIDM_HOME/share/iidm share/
  fi
  if [ -d "$DYNAWO_LIBIIDM_HOME/LibIIDM" ]; then
    cp -R -P $DYNAWO_LIBIIDM_HOME/LibIIDM/cmake share/
  fi

  mkdir -p cmake
  cp -P $DYNAWO_SUITESPARSE_INSTALL_DIR/cmake/* cmake

  echo "deploying OpenModelica"
  mkdir -p OpenModelica/bin/
  mkdir -p OpenModelica/include/
  mkdir -p OpenModelica/lib/omc/
  cp -P $DYNAWO_INSTALL_OPENMODELICA/bin/omc* OpenModelica/bin
  cp -P -R $DYNAWO_INSTALL_OPENMODELICA/include/omc OpenModelica/include/
  cp -P -R $DYNAWO_INSTALL_OPENMODELICA/lib/* OpenModelica/lib/
  cp -P $DYNAWO_INSTALL_OPENMODELICA/lib/omc/*.mo OpenModelica/lib/omc/
  cp -P -R $DYNAWO_INSTALL_OPENMODELICA/lib/omlibrary OpenModelica/lib/
  find OpenModelica/lib -name "libipopt*" -exec rm -f '{}' \;
  find OpenModelica/lib -name "libcoinmumps*" -exec rm -f '{}' \;
  find OpenModelica/lib -name "*.a" -exec rm -f '{}' \;
  find OpenModelica/lib -name "libamd*" -exec rm -f '{}' \;
  find OpenModelica/lib -name "libbtf*" -exec rm -f '{}' \;
  find OpenModelica/lib -name "libcminpack*" -exec rm -f '{}' \;
  find OpenModelica/lib -name "libcolamd*" -exec rm -f '{}' \;
  find OpenModelica/lib -name "libklu*" -exec rm -f '{}' \;
  find OpenModelica/lib -name "liblis*" -exec rm -f '{}' \;
  find OpenModelica/lib -name "libomopcua*" -exec rm -f '{}' \;
  find OpenModelica/lib -name "libOpenModelicaFMIRuntimeC*" -exec rm -f '{}' \;
  find OpenModelica/lib -name "libSimulationRuntimeC*" -exec rm -f '{}' \;
  find OpenModelica/lib -name "libsundials*" -exec rm -f '{}' \;
  find OpenModelica/lib -name "libumfpack*" -exec rm -f '{}' \;
  find OpenModelica/lib -name "libzlib*" -exec rm -f '{}' \;
  if [ "`uname`" = "Linux" ]; then
    for lib in {gfortran,quadmath,lapack,blas,lpsolve,cblas,atlas}; do
      if [ ! -z "$(ldd $DYNAWO_INSTALL_OPENMODELICA/bin/omcDynawo | grep $lib | cut -d '>' -f 2 | cut -d ' ' -f 2)" ]; then
        cp $(ldd $DYNAWO_INSTALL_OPENMODELICA/bin/omcDynawo | grep $lib | cut -d '>' -f 2 | cut -d ' ' -f 2) lib/
      fi
    done
  fi

  LIBRARY_SUFFIX=$DYNAWO_SHARED_LIBRARY_SUFFIX

  # BOOST
  echo "deploying boost"
  if [ $DYNAWO_BOOST_HOME_DEFAULT != true ]; then
    boost_system_folder=$DYNAWO_BOOST_HOME/lib
    boost_system_folder_include=$DYNAWO_BOOST_HOME/include
  else
    boost_system_folder=$(find_lib_system_path boost) || error_exit "Path for boost could not be found for deploy."
    boost_system_folder_include=$(find_include_system_path Boost_INCLUDE_DIR) || error_exit "Path for boost include could not be found for deploy."
  fi
  boost_libraries=""
  if [ -f "$DYNAWO_THIRD_PARTY_BUILD_DIR/build/CMakeCache.txt" ]; then
    for lib_boost in $(grep -o "libboost.*.$LIBRARY_SUFFIX" $DYNAWO_THIRD_PARTY_BUILD_DIR/build/CMakeCache.txt | tr ';' '\n' | grep -o "libboost.*.$LIBRARY_SUFFIX" | sort | uniq); do
      boost_libraries="${boost_libraries[@]} $lib_boost"
    done
  else
    error_exit "$DYNAWO_THIRD_PARTY_BUILD_DIR/build should not be deleted before deploy to be able to determine boost libraries used during compilation."
  fi
  if [ -f "$DYNAWO_THIRD_PARTY_BUILD_DIR/src/$DIR_LIBIIDM-build/CMakeCache.txt" ]; then
    for lib_boost in $(grep -o "libboost.*.$LIBRARY_SUFFIX" $DYNAWO_THIRD_PARTY_BUILD_DIR/src/$DIR_LIBIIDM-build/CMakeCache.txt | tr ';' '\n' | grep -o "libboost.*.$LIBRARY_SUFFIX" | sort | uniq); do
      boost_libraries="${boost_libraries[@]} $lib_boost"
    done
  else
    error_exit "$DYNAWO_THIRD_PARTY_BUILD_DIR/src/$DIR_LIBIIDM-build should not be deleted before deploy to be able to determine boost libraries used during compilation."
  fi
  if [ -f "$DYNAWO_BUILD_DIR/CMakeCache.txt" ]; then
    for lib_boost in $(grep -o "libboost.*.$LIBRARY_SUFFIX" $DYNAWO_BUILD_DIR/CMakeCache.txt | tr ';' '\n' | grep -o "libboost.*.$LIBRARY_SUFFIX" | sort | uniq); do
      boost_libraries="${boost_libraries[@]} $lib_boost"
    done
  else
    error_exit "$DYNAWO_BUILD_DIR should not be deleted before deploy to be able to determine boost libraries used during compilation."
  fi
  boost_libraries=($(echo "${boost_libraries[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
  for lib_boost in ${boost_libraries[@]}; do
    cp -P ${boost_system_folder}/${lib_boost}* lib/
  done
  if [ -f "$boost_system_folder/libboost_iostreams.$LIBRARY_SUFFIX" ]; then
    cp -P $boost_system_folder/libboost_iostreams*.$LIBRARY_SUFFIX* lib/
  fi
  if [ -f "$boost_system_folder/libboost_date_time.$LIBRARY_SUFFIX" ]; then
    cp -P $boost_system_folder/libboost_date_time*.$LIBRARY_SUFFIX* lib/
  fi
  cp -n -P -R $boost_system_folder_include/boost include/

  # XERCESC
  echo "deploying XercesC"
  if [ -d "$DYNAWO_XERCESC_INSTALL_DIR" ]; then
    cp -P $DYNAWO_XERCESC_INSTALL_DIR/lib/libxerces-c*.* lib/
    cp -n -r $DYNAWO_XERCESC_INSTALL_DIR/include/* include/
  else
    xerces_system_folder=$(find_lib_system_path xerces) || error_exit "Path for xerces could not be found for deploy."
    cp -P $xerces_system_folder/libxerces-c*.* lib/
    xerces_system_folder_include=$(find_include_system_path XercesC_INCLUDE_DIR) || error_exit "Path for xerces include could not be found for deploy."
    cp -n -r $xerces_system_folder_include/xercesc include/
  fi

  # ZLIB
  echo "deploying zlib"
  if [ $DYNAWO_ZLIB_HOME_DEFAULT != true ]; then
    cp -P $DYNAWO_ZLIB_HOME/lib/libz.$LIBRARY_SUFFIX* lib/
    cp -n $DYNAWO_ZLIB_HOME/include/zconf.h include/
    cp -n $DYNAWO_ZLIB_HOME/include/zlib.h include/
  else
    zlib_system_folder=$(find_lib_system_path z[.]) || error_exit "Path for zlib could not be found for deploy."
    cp -P ${zlib_system_folder}/libz.$LIBRARY_SUFFIX* lib/
    zlib_system_folder_include=$(find_include_system_path ZLIB_INCLUDE_DIR) || error_exit "Path for zlib include could not be found for deploy."
    cp -n $zlib_system_folder_include/zconf.h include/
    cp -n $zlib_system_folder_include/zlib.h include/
  fi

  # LIBARCHIVE
  echo "deploying libArchive"
  if [ $DYNAWO_LIBARCHIVE_HOME_DEFAULT != true ]; then
    cp -P $DYNAWO_LIBARCHIVE_HOME/lib/libarchive*.$LIBRARY_SUFFIX* lib/
    cp -n $DYNAWO_LIBARCHIVE_HOME/include/archive_entry.h include/
    cp -n $DYNAWO_LIBARCHIVE_HOME/include/archive.h include/
  else
    libarchive_system_folder=$(find_lib_system_path archive) || error_exit "Path for libarchive could not be found for deploy."
    cp -P ${libarchive_system_folder}/libarchive*.$LIBRARY_SUFFIX* lib/
    libarchive_system_folder_include=$(find_include_system_path LibArchive_INCLUDE_DIR) || error_exit "Path for libarchive include could not be found for deploy."
    cp -n $libarchive_system_folder_include/archive_entry.h include/
    cp -n $libarchive_system_folder_include/archive.h include/
    if [ "`uname`" = "Linux" ]; then
      for lib in {crypto,lzma,bz2,xml2,lzo2}; do
        if [ ! -z "$(ldd ${libarchive_system_folder}/libarchive.$LIBRARY_SUFFIX | grep $lib | cut -d '>' -f 2 | cut -d ' ' -f 2)" ]; then
          cp $(ldd ${libarchive_system_folder}/libarchive.$LIBRARY_SUFFIX | grep $lib | cut -d '>' -f 2 | cut -d ' ' -f 2) lib/
        fi
      done
    fi
  fi

  if [ "$(echo "$DYNAWO_USE_LEGACY_IIDM" | tr '[:upper:]' '[:lower:]')" = "yes" -o "$(echo "$DYNAWO_USE_LEGACY_IIDM" | tr '[:upper:]' '[:lower:]')" = "true" -o "$(echo "$DYNAWO_USE_LEGACY_IIDM" | tr '[:upper:]' '[:lower:]')" = "on" ]; then
    : # do nothing
  else
    # libXML2
    echo "deploying libxml2"
    if [ $DYNAWO_LIBXML2_HOME_DEFAULT != true ]; then
      cp -P $DYNAWO_LIBXML2_HOME/lib/libxml2*.$LIBRARY_SUFFIX* lib/
      cp -n -R $DYNAWO_LIBXML2_HOME/include/libxml2 include/
    else
      libxml2_system_folder=$(find_lib_system_path xml2) || error_exit "Path for libxml2 could not be found for deploy."
      cp -P ${libxml2_system_folder}/libxml2*.$LIBRARY_SUFFIX* lib/
      libxml2_system_folder_include=$(find_include_system_path LIBXML2_INCLUDE_DIR) || error_exit "Path for libxml2 include could not be found for deploy."
      cp -n -P -R ${libxml2_system_folder_include} include/
    fi
  fi

  # DYNAWO
  echo "deploying Dynawo"
  cp $DYNAWO_INSTALL_DIR/dynawo.sh .
  mkdir -p bin
  cp -r $DYNAWO_INSTALL_DIR/bin/* bin/
  cp -r $DYNAWO_INSTALL_DIR/lib/* lib/
  cp -n -r $DYNAWO_INSTALL_DIR/include/* include/
  cp -r $DYNAWO_INSTALL_DIR/share/* share/
  cp -r $DYNAWO_INSTALL_DIR/ddb .

  mkdir -p sbin
  echo "deploying Dynawo utils"
  cp $DYNAWO_INSTALL_DIR/sbin/*.py sbin/
  cp $DYNAWO_INSTALL_DIR/sbin/compileCppModelicaModelInDynamicLib.cmake sbin/
  cp $DYNAWO_INSTALL_DIR/sbin/PreloadCache.cmake sbin/
  cp $DYNAWO_INSTALL_DIR/sbin/compileModelicaModel sbin/
  cp $DYNAWO_INSTALL_DIR/sbin/dumpModel sbin/
  cp $DYNAWO_INSTALL_DIR/sbin/generate-preassembled sbin/
  cp $DYNAWO_INSTALL_DIR/sbin/dumpSolver sbin/
  cp $DYNAWO_INSTALL_DIR/sbin/generate-preassembled-${version} sbin/

  if [ -d "$DYNAWO_INSTALL_DIR/doxygen" ]; then
    mkdir -p doxygen
    cp -r $DYNAWO_INSTALL_DIR/doxygen/html doxygen/.
    cp $DYNAWO_INSTALL_DIR/doxygen/Dynawo.tag doxygen/.
  fi

  mkdir -p sbin/curvesToHtml/csvToHtml sbin/curvesToHtml/resources sbin/curvesToHtml/xmlToHtml
  cp -r $DYNAWO_CURVES_TO_HTML_DIR/*.py sbin/curvesToHtml/
  cp -r $DYNAWO_CURVES_TO_HTML_DIR/resources/* sbin/curvesToHtml/resources/
  cp -r $DYNAWO_CURVES_TO_HTML_DIR/csvToHtml/*.py sbin/curvesToHtml/csvToHtml/
  cp -r $DYNAWO_CURVES_TO_HTML_DIR/xmlToHtml/*.py sbin/curvesToHtml/xmlToHtml/
  mkdir -p sbin/nrt/nrt_diff
  cp -r $DYNAWO_NRT_DIFF_DIR/*.py sbin/nrt/nrt_diff
  cp -r $DYNAWO_NRT_DIR/nrt.py sbin/nrt/.
  cp -r $DYNAWO_NRT_DIR/resources sbin/nrt/.
  cp -r $DYNAWO_HOME/util/xsl sbin/.

  rm -f lib/*.la
  find OpenModelica/lib -name "*.la" -exec rm {} \;

  cd $current_dir
}

create_modelica_distrib() {
  if [ -z "$1" ]; then
    error_exit "You need to give a version."
  fi
  version=$1
  if [ ! -x "$(command -v zip)" ]; then
    error_exit "You need to install zip command line utility."
  fi
  # create zipped Dynawo library for OM users
  DYNAWO_LIB_ZIP_FILE=Dynawo_Modelica_library_V$version.zip
  pushd $DYNAWO_INSTALL_DIR/ddb
  zip -r -y $DYNAWO_LIB_ZIP_FILE Dynawo/
  mv $DYNAWO_LIB_ZIP_FILE $DYNAWO_HOME/distributions
  popd
}

create_distrib_with_headers() {
  if [ ! -z "$1" ]; then
    if [ "$1" = "with_omc" ]; then
      with_omc=yes
    fi
  fi
  DISTRIB_DIR=$DYNAWO_HOME/distributions
  mkdir -p $DISTRIB_DIR

  # Set Dynawo distrib version
  DYNAWO_VERSION=$(version) || error_exit "Error with version."
  version=$(echo $DYNAWO_VERSION | cut -f1 -d' ')

  if [ "$with_omc" = "yes" ]; then
    ZIP_FILE=Dynawo_omc_V$version.zip
  else
    ZIP_FILE=Dynawo_headers_V$version.zip
  fi

  # check coding
  check_coding_files

  # Deploy Dynawo
  deploy_dynawo

  create_modelica_distrib $version

  if [ "$DYNAWO_COMPILER" = "GCC" ]; then
    gcc_version=$($DYNAWO_C_COMPILER -dumpversion)
    if [ $(echo $gcc_version | cut -d '.' -f 1) -lt 5 ]; then
      sed -i 's/-std=c++98/-std=c++98 -D_GLIBCXX_USE_CXX11_ABI=0/' $DYNAWO_DEPLOY_DIR/sbin/compileCppModelicaModelInDynamicLib.cmake
    elif [ $(echo $gcc_version | cut -d '.' -f 1) -eq 5 -a $(echo $gcc_version | cut -d '.' -f 2) -lt 1 ]; then
      sed -i 's/-std=c++98/-std=c++98 -D_GLIBCXX_USE_CXX11_ABI=0/' $DYNAWO_DEPLOY_DIR/sbin/compileCppModelicaModelInDynamicLib.cmake
    fi
  fi

  ln -s $DYNAWO_HOME/examples $DYNAWO_DEPLOY_DIR/examples

  if [ ! -x "$(command -v zip)" ]; then
    error_exit "You need to install zip command line utility."
  fi

  if [ "`uname`" = "Linux" ]; then
    if [ -x "$(command -v chrpath)" ]; then
      chrpath -d $DYNAWO_DEPLOY_DIR/lib/libamd.so
      chrpath -d $DYNAWO_DEPLOY_DIR/lib/libbtf.so
      chrpath -d $DYNAWO_DEPLOY_DIR/lib/libcolamd.so
      chrpath -d $DYNAWO_DEPLOY_DIR/lib/libklu.so
      chrpath -d $DYNAWO_DEPLOY_DIR/lib/libsuitesparseconfig.so
    fi
  fi

  # create distribution
  if [ ! -d "$DYNAWO_DEPLOY_DIR" ]; then
    error_exit "$DYNAWO_DEPLOY_DIR does not exist."
  fi
  cd "$DYNAWO_DEPLOY_DIR/.."
  zip -r -y $ZIP_FILE dynawo/bin/ dynawo/lib/ dynawo/share/
  zip -r -g -y $ZIP_FILE dynawo/examples/ -x "*.py"
  zip -r -g -y $ZIP_FILE dynawo/dynawo.sh
  zip -r -g -y $ZIP_FILE dynawo/dynawoEnv.txt

  # need with omc binary
  zip -r -g -y $ZIP_FILE dynawo/ddb/ dynawo/include/ dynawo/sbin/ dynawo/cmake/

  if [ "$with_omc" = "yes" ]; then
    zip -r -g -y $ZIP_FILE dynawo/OpenModelica
  else
    if [ "`uname`" = "Linux" ]; then
      for lib in {gfortran,quadmath,lapack,blas,lpsolve,cblas,atlas}; do
        zip -d $ZIP_FILE dynawo/lib/lib${lib}* || echo -n # to avoid errors
      done
    fi
  fi

  # move distribution in distribution directory
  mv $ZIP_FILE $DISTRIB_DIR
}

create_distrib() {
  DISTRIB_DIR=$DYNAWO_HOME/distributions
  mkdir -p $DISTRIB_DIR

  # Set Dynawo distrib version
  DYNAWO_VERSION=$(version) || error_exit "Error with version."
  version=$(echo $DYNAWO_VERSION | cut -f1 -d' ')

  ZIP_FILE=Dynawo_V$version.zip

  # check coding
  check_coding_files

  # Deploy Dynawo
  deploy_dynawo

  create_modelica_distrib $version

  ln -s $DYNAWO_HOME/examples $DYNAWO_DEPLOY_DIR/examples

  if [ ! -x "$(command -v zip)" ]; then
    error_exit "You need to install zip command line utility."
  fi

  if [ "`uname`" = "Linux" ]; then
    if [ -x "$(command -v chrpath)" ]; then
      chrpath -d $DYNAWO_DEPLOY_DIR/lib/libamd.so
      chrpath -d $DYNAWO_DEPLOY_DIR/lib/libbtf.so
      chrpath -d $DYNAWO_DEPLOY_DIR/lib/libcolamd.so
      chrpath -d $DYNAWO_DEPLOY_DIR/lib/libklu.so
      chrpath -d $DYNAWO_DEPLOY_DIR/lib/libsuitesparseconfig.so
    fi
  fi

  # create distribution
  if [ ! -d "$DYNAWO_DEPLOY_DIR" ]; then
    error_exit "$DYNAWO_DEPLOY_DIR does not exist."
  fi
  cd "$DYNAWO_DEPLOY_DIR/.."
  zip -r -y $ZIP_FILE dynawo/bin/ dynawo/lib/ dynawo/share/
  zip -r -g -y $ZIP_FILE dynawo/examples/ -x "*.py" "*DynaSwing/Kundur_Example13*"
  zip -r -g -y $ZIP_FILE dynawo/dynawo.sh
  zip -r -g -y $ZIP_FILE dynawo/ddb/*.$DYNAWO_SHARED_LIBRARY_SUFFIX dynawo/ddb/*.desc.xml dynawo/ddb/*.extvar
  zip -r -g -y $ZIP_FILE dynawo/sbin/curvesToHtml
  zip -r -g -y $ZIP_FILE dynawo/sbin/xsl
  zip -r -g -y $ZIP_FILE dynawo/sbin/nrt

  # move distribution in distribution directory
  mv $ZIP_FILE $DISTRIB_DIR
}

deploy_dynawo_autocompletion() {
  $DYNAWO_HOME/util/autocompletion/deploy_autocompletion.sh $*
}

build_doc() {
  if [ ! -d "$DYNAWO_HOME/documentation" ]; then
    error_exit "$DYNAWO_HOME/documentation does not exist."
  fi
  cd $DYNAWO_HOME/documentation
  bash dynawo_documentation.sh
}

clean_doc() {
  if [ ! -d "$DYNAWO_HOME/documentation" ]; then
    error_exit "$DYNAWO_HOME/documentation does not exist."
  fi
  cd $DYNAWO_HOME/documentation
  bash clean.sh
}

open_doc() {
  open_pdf $DYNAWO_HOME/documentation/dynawoDocumentation/DynawoDocumentation.pdf
}

build_nrt_doc() {
  if [ ! -d "$DYNAWO_HOME/nrt/documentation" ]; then
    error_exit "$DYNAWO_HOME/nrt/documentation does not exist."
  fi
  cd $DYNAWO_HOME/nrt/documentation
  bash merge_tnr_descriptions.sh
}

clean_nrt_doc() {
  for folder in $(find $DYNAWO_HOME/nrt/data -type d -name "description"); do
    if [ -d "$folder" ]; then
      (cd $folder; rm -f *.toc *.aux *.bbl *.blg *.log *.out *.pdf *.gz *.mtc* *.maf *.lof)
    fi
  done
  (cd $DYNAWO_HOME/nrt/documentation; rm -f *.toc *.aux *.bbl *.blg *.log *.out *.pdf *.gz *.mtc* *.maf *.lof nrt_doc.tex)
}

open_pdf() {
  if [ -z "$1" ]; then
    error_exit "You need to specify a pdf file to open."
  fi
  if [ ! -z "$DYNAWO_PDFVIEWER" ]; then
    if [ -x "$(command -v $DYNAWO_PDFVIEWER)" ]; then
      if [ -f "$1" ]; then
        $DYNAWO_PDFVIEWER $1
      else
        error_exit "Pdf file $1 you try to open does not exist."
      fi
    else
      error_exit "pdfviewer $DYNAWO_PDFVIEWER seems not to be executable."
    fi
  elif [ -x "$(command -v xdg-open)" ]; then
      xdg-open $1
  else
    error_exit "Cannot determine how to open pdf document from command line. Use DYNAWO_PDFVIEWER environment variable."
  fi
}

open_nrt_doc() {
  open_pdf $DYNAWO_HOME/nrt/documentation/nrt_doc.pdf
}

unittest_gdb() {
  reset_environment_variables
  set_environment build-tests
  if [ ! -d "$DYNAWO_BUILD_DIR" ]; then
    build_3rd_party || error_exit
    config_dynawo || error_exit
    build_dynawo_core || error_exit
    build_dynawo_models_cpp || error_exit
  fi
  list_of_tests=($(find $DYNAWO_BUILD_DIR/sources -executable -type f -exec basename {} \; | grep test))
  if [[ ${#list_of_tests[@]} == 0 ]]; then
    echo "The list of tests is empty. This should not happen."
    exit 1
  fi
  if [ -z "$1" ]; then
    echo "You need to give the name of unittest to run."
    echo "List of available unittests:"
    for name in ${list_of_tests[@]}; do
      echo "  $name"
    done
    exit 1
  fi
  unittest_exe=$(find $DYNAWO_BUILD_DIR/sources -name "$1")
  if [ -z "$unittest_exe" ]; then
    echo "The unittest you gave is not available."
    echo "List of available unittests:"
    for name in ${list_of_tests[@]}; do
      echo "  $name"
    done
    exit 1
  fi
  if [ ! -d "$(dirname $unittest_exe)" ]; then
    error_exit "$(dirname $unittest_exe) does not exist."
  fi
  cd $(dirname $unittest_exe)
  gdb -q --args $unittest_exe
}

reset_environment_variables() {
  ld_library_path_remove $DYNAWO_NICSLU_INSTALL_DIR/lib
  ld_library_path_remove $DYNAWO_SUITESPARSE_INSTALL_DIR/lib
  ld_library_path_remove $DYNAWO_SUNDIALS_INSTALL_DIR/lib64
  ld_library_path_remove $DYNAWO_SUNDIALS_INSTALL_DIR/lib
  ld_library_path_remove $DYNAWO_LIBZIP_HOME/lib
  ld_library_path_remove $DYNAWO_LIBXML_HOME/lib
  ld_library_path_remove $DYNAWO_LIBIIDM_HOME/lib
  ld_library_path_remove $DYNAWO_ADEPT_INSTALL_DIR/lib
  ld_library_path_remove $DYNAWO_XERCESC_INSTALL_DIR/lib
  ld_library_path_remove $DYNAWO_INSTALL_DIR/lib
  ld_library_path_remove $DYNAWO_ZLIB_HOME/lib
  ld_library_path_remove $DYNAWO_LIBARCHIVE_HOME/lib
  ld_library_path_remove $DYNAWO_BOOST_HOME/lib
  ld_library_path_remove $DYNAWO_GTEST_HOME/lib64
  ld_library_path_remove $DYNAWO_GTEST_HOME/lib
  path_remove $DYNAWO_INSTALL_OPENMODELICA/bin
  python_path_remove $DYNAWO_SCRIPTS_DIR

  do_not_unset="DYNAWO_BUILD_TYPE DYNAWO_COMPILER DYNAWO_USE_LEGACY_IIDM DYNAWO_HOME DYNAWO_INSTALL_OPENMODELICA \
DYNAWO_SRC_OPENMODELICA DYNAWO_ZLIB_HOME DYNAWO_LIBARCHIVE_HOME DYNAWO_BOOST_HOME DYNAWO_GTEST_HOME DYNAWO_GMOCK_HOME DYNAWO_XSD_DIR"

  for var in $(printenv | grep DYNAWO_ | cut -d '=' -f 1); do
    if ! `echo $do_not_unset | grep -w $var > /dev/null`; then
      unset $var
    fi
  done
}

reset_environment_variables_full() {
  reset_environment_variables
  unset DYNAWO_BUILD_TYPE
  unset DYNAWO_COMPILER
  unset DYNAWO_USE_LEGACY_IIDM
  unset DYNAWO_HOME
  unset DYNAWO_INSTALL_OPENMODELICA
  unset DYNAWO_SRC_OPENMODELICA
  unset DYNAWO_ZLIB_HOME
  unset DYNAWO_LIBARCHIVE_HOME
  unset DYNAWO_BOOST_HOME
  unset DYNAWO_GTEST_HOME
  unset DYNAWO_GMOCK_HOME
}

#################################
########### Main script #########
#################################

if [ -n "$BASH_VERSION" ]; then
  SCRIPT=$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && echo "$(pwd)"/"$(basename ${BASH_SOURCE[0]})")
elif [ -n "$ZSH_VERSION" ]; then
  SCRIPT=$(cd "$(dirname "$0")" && echo "$(pwd)"/"$(basename $0)")
fi

LAUNCH_COMMAND=$*
MODE=$1

## set environment variables
set_environment $MODE

ARGS=`echo ${LAUNCH_COMMAND} | cut -d' ' -f2-`

# if there is no args, the last command return the launchCommand, so we force args to be empty
if [[ "${ARGS}" = "${LAUNCH_COMMAND}" ]]; then
  ARGS=""
fi

## launch command
case $MODE in
  build-3rd-party)
    build_3rd_party ${ARGS} || error_exit "Error while building 3rd parties"
    ;;

  build-all)
    build_all || error_exit "Error while building all"
    ;;

  build-doc)
    build_doc || error_exit "Error during the build of dynawo documentation"
    ;;

  build-doxygen-doc)
    build_test_doxygen_doc || error_exit "Error while building doxygen documentation"
    ;;

  build-dynawo)
    config_dynawo || error_exit "Error while configuring Dynawo"
    build_dynawo || error_exit "Error while building Dynawo"
    ;;

  build-dynaflow)
    build_dynaflow || error_exit "Error while building DynaFlow"
    ;;

  build-dynaswing)
    build_dynaswing || error_exit "Error while building DynaSwing"
    ;;

  build-dynawo-core)
    build_dynawo_core || error_exit "Failed to build Dynawo core"
    ;;

  build-dynawo-target)
    build_dynawo_target ${ARGS} || error_exit "Failed to build Dynawo target"
    ;;

  build-dynawo-models)
    build_dynawo_models || error_exit "Failed to build Dynawo models"
    ;;

  build-dynawo-models-cpp)
    build_dynawo_models_cpp || error_exit "Failed to build Dynawo models-cpp"
    ;;

  build-dynawo-solvers)
    build_dynawo_solvers || error_exit "Failed to build Dynawo solvers"
    ;;

  build-nrt-doc)
    build_nrt_doc || error_exit "Error during the build of Dynawo nrt documentation"
    ;;

  build-omcDynawo)
    build_omcDynawo || error_exit "Failed to build OMC for Dynawo"
    ;;

  build-tests)
    build_tests ${ARGS} || error_exit "Error while building tests"
    ;;

  build-tests-coverage)
    build_tests_coverage ${ARGS}|| error_exit "Error while building tests coverage"
    ;;

  build-user)
    build_user || error_exit "Error while building Dynawo"
    ;;

  clean-3rd-party)
    clean_3rd_party || error_exit "Error while cleaning 3rd parties"
    ;;

  clean-all)
    clean_all || error_exit "Error while clean all"
    ;;

  clean-build-3rd-party)
    clean_build_3rd_party || error_exit "Error while clean build 3rd parties"
    ;;

  clean-build-all)
    clean_build_all || error_exit "Error while clean build all"
    ;;

  clean-build-dynawo)
    clean_build_dynawo || error_exit "Error while clean build all"
    ;;

  clean-build-models)
    clean_build_models ${ARGS} || error_exit "Error while clean build models"
    ;;

  clean-doc)
    clean_doc || error_exit "Error during the clean of Dynawo documentation"
    ;;

  clean-dynawo)
    clean_dynawo || error_exit "Error while cleaning Dynawo"
    ;;

  clean-models)
    clean_models ${ARGS} || error_exit "Error during the clean of models"
    ;;

  clean-nrt-doc)
    clean_nrt_doc || error_exit "Error during the clean of Dynawo nrt documentation"
    ;;

  clean-old-branches)
    clean_old_branches || error_exit "Error during the cleaning of old branches build/install/nrt"
    ;;

  clean-tests)
    clean_tests || error_exit "Error during the cleaning of tests"
    ;;

  clean-tests-coverage)
    clean_tests_coverage || error_exit "Error during the cleaning of tests coverage"
    ;;

  compileCppModelicaModelInDynamicLib)
    compile_cpp_modelica_model_in_dynamic_lib ${ARGS} || error_exit "Error during the compilation of Modelica Model for Dynawo"
    ;;

  compileModelicaModel)
    compile_Modelica_Model ${ARGS} || error_exit "Failed to compile Modelica model"
    ;;

  config-3rd-party)
    config_3rd_party || error_exit "Error while configuring Dynawo 3rd Parties"
    ;;

  config-dynawo)
    config_dynawo || error_exit "Error while configuring Dynawo"
    ;;

  curves)
    curves_visu ${ARGS} || error_exit "Error with curves plot"
    ;;

  curves-reference)
    curves_visu_reference ${ARGS} || error_exit "Error with reference curves plot"
    ;;

  curves-reference-same-graph)
    curves_visu_reference_same_graph ${ARGS} || error_exit "Error with reference curves plot"
    ;;

  deploy)
    deploy_dynawo || error_exit "Error during the deployment of Dynawo"
    ;;

  deploy-autocompletion)
    deploy_dynawo_autocompletion ${ARGS} || error_exit "Error during the deployment of autocompletion for Dynawo"
    ;;

  display-environment)
    display_environment_variables || error_exit "Failed to display environment variables"
    ;;

  distrib)
    create_distrib || error_exit "Error while building Dynawo distribution"
    ;;

  distrib-omc)
    create_distrib_with_headers "with_omc" || error_exit "Error while building Dynawo distribution"
    ;;

  distrib-headers)
    create_distrib_with_headers || error_exit "Error while building Dynawo distribution"
    ;;

  doc)
    open_doc || error_exit "Error during the opening of Dynawo documentation"
    ;;

  doxygen-doc)
    open_doxygen_doc || error_exit "Error during Dynawo Doxygen doc visualisation"
    ;;

  dump-model)
    dump_model ${ARGS} || error_exit "Error during model's description dump"
    ;;

  dump-model-gdb)
    gdb_dump_model ${ARGS} || error_exit "Error during model's description dump"
    ;;

  dump-model-valgrind)
    valgrind_dump_model ${ARGS} || error_exit "Error during model's description dump"
    ;;

  generate-preassembled)
    generate_preassembled ${ARGS} || error_exit "Error during the generation of a preassembled model"
    ;;

  generate-preassembled-gdb)
    generate_preassembled_gdb ${ARGS} || error_exit "Error during the generation of a preassembled model"
    ;;

  help)
    help_dynawo "Error during the help"
    ;;

  help-user)
    help_dynawo_user "Error during the help for users"
    ;;

  jobs)
    launch_jobs ${ARGS} || error_exit "Dynawo job failed"
    ;;

  jobs-gdb)
    launch_jobs --gdb ${ARGS} || error_exit "Dynawo job failed"
    ;;

  jobs-valgrind)
    launch_jobs --valgrind ${ARGS} || error_exit "Dynawo job failed"
    ;;

  jobs-valgrind-callgrind)
    launch_jobs --valgrind-callgrind ${ARGS} || error_exit "Dynawo job failed"
    ;;

  jobs-valgrind-massif)
    launch_jobs --valgrind-massif ${ARGS} || error_exit "Dynawo job failed"
    ;;

  jobs-with-curves)
    jobs_with_curves ${ARGS} || error_exit "Dynawo job with curves failed"
    ;;

  list-models)
    list_models || error_exit "Error during the display of models list"
    ;;

  list-tests)
    list_tests || error_exit "Error during the display of tests list"
    ;;

  modelica-doc)
    open_modelica_doc || error_exit "Error while opening Dynawo Modelica library documentation"
    ;;

  nrt)
    nrt ${ARGS} || error_exit "Error during Dynawo's non regression tests execution"
    ;;

  nrt-clean)
    nrt_clean || error_exit "Error during Dynawo's non regression tests clean"
    ;;

  nrt-diff)
    nrt_diff ${ARGS} || error_exit "Error during Dynawo's NRT Diff execution"
    ;;

  nrt-ref)
    nrt_ref ${ARGS} || error_exit "Error during Dynawo's NRT ref execution"
    ;;

  nrt-xsl)
    nrt_xsl ${ARGS} || error_exit "Error during Dynawo's NRT xsl execution"
    ;;

  nrt-doc)
    open_nrt_doc || error_exit "Error during the opening of Dynawo nrt documentation"
    ;;

  reset-environment)
    reset_environment_variables_full || error_exit "Failed to reset environment variables"
    ;;

  run-doc-tests)
    run_documentation_test || error_exit "Error in the documentation tests"
    ;;

  uninstall-3rd-party)
    uninstall_3rd_party || error_exit "Error while uninstalling 3rd parties"
    ;;

  uninstall-all)
    uninstall_all || error_exit "Error while uninstalling all"
    ;;

  uninstall-dynawo)
    uninstall_dynawo || error_exit "Error while uninstalling Dynawo"
    ;;

  unittest-gdb)
    unittest_gdb ${ARGS} || error_exit "Error during the run unittest in gdb"
    ;;

  version)
    version || error_exit "Error during version visualisation"
    ;;

  version-validation)
    version_validation || error_exit "The current version does not fulfill the standard quality check"
    ;;

  *)
    echo "$1 is an invalid option"
    help_dynawo_user
    exit 1
    ;;
esac
