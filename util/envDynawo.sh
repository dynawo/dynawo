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
        build-3rd-party                       build 3rd party softwares for all compilation environments (Release/Debug, C++98/11) for a compiler in shared or static
        build-3rd-party-version               build 3rd party softwares
        config-dynawo                         configure Dynawo's compiling environment using CMake
        build-dynawo                          build Dynawo and install preassembled models (core, models cpp, models and solvers)
        build-dynawo-core                     build Dynawo without models
        build-dynawo-models-cpp               build Dynawo CPP models
        build-dynawo-models                   build Dynawo preassembled models
        build-dynawo-solvers                  build Dynawo solver descriptions
        build-all                             call in this order build-3rd-party, config-dynawo, build-dynawo, build-doxygen-doc
        build-tests ([args])                  build and launch Dynawo's unittest (launch all tests if [args] is empty)
        build-tests-coverage ([args])         build/launch Dynawo's unittest and generate code coverage report (launch all tests if [args] is empty)

        =========== Clean
        clean-omcDynawo                       remove the OpenModelica compiler for dynawo
        clean-3rd-party                       remove all 3rd party softwares objects
        clean-dynawo                          remove Dynawo's objects
        clean-all                             call clean-3rd-party, clean-dynawo
        clean-tests                           remove all objects needed for unittest
        clean-tests-coverage                  remove all objects needed for unittest-coverage
        clean-old-branches                    remove old build/install/nrt results from merge branches

        =========== Clean-Build
        clean-build-3rd-party                 clean then build 3rd party libraries
        clean-build-dynawo                    clean, then configure and build Dynawo
        clean-build-all                       clean, then configure and build 3rd party libraries, Dynawo

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

        =========== Distribution
        distrib                               create distribution of Dynawo
        distrib-omc                           create distribution with omc binary
        deploy                                deploy the current version of dynawo binaries/libraries/includes to be used as a release by an another project

        =========== Tests
        nrt ([-p regex] [-n name_filter])     run (filtered) non-regression tests and open the result in chosen browser
        nrt-diff ([args])                     make a diff between two non-regression test outputs
        nrt-ref ([args])                      define or redefine automatically the non-regression tests references
        version-validation                    clean all built items, then build them all and run non-regression tests
        list-tests                            print all available unittest target

        =========== Utilities
        generate-preassembled-gdb             generate a preassembled model with debugger
        compileCppModelicaModelInDynamicLib   compile Modelica Model generated for Dynawo
        flat-model ([args])                   generate and display the (full) flat Modelica model"

  export_var_env DYNAWO_DOCUMENTATION_OPTIONS="    =========== Dynawo Documentation
        =========== Launch
        doc                                   open Dynawo's documentation
        doxygen-doc                           open Dynawo's Doxygen documentation into chosen browser
        modelica-doc                          open Dynawo's Modelica models documentation
        nrt-doc                               open Dynawo's nrt documentation

        =========== Build
        build-doc                             build documentation
        build-doxygen-doc                     build all doxygen documentation
        build-modelica-doc                    build all Dynawo modelica library document
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
      branch_ref=$(git rev-parse --short HEAD)
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
  # Force build type when building tests (or tests coverage)
  case $1 in
    build-tests-coverage)
      export_var_env_force DYNAWO_BUILD_TYPE=TestCoverage
      export_var_env_force DYNAWO_USE_XSD_VALIDATION=true
      export_var_env DYNAWO_DICTIONARIES=dictionaries_mapping
      ;;
    build-tests)
      export_var_env_force DYNAWO_BUILD_TYPE=Tests
      export_var_env_force DYNAWO_USE_XSD_VALIDATION=true
      export_var_env DYNAWO_DICTIONARIES=dictionaries_mapping
      ;;
    list-tests)
      export_var_env_force DYNAWO_BUILD_TYPE=Tests
      export_var_env_force DYNAWO_USE_XSD_VALIDATION=true
      ;;
    clean-tests)
      export_var_env_force DYNAWO_BUILD_TYPE=Tests
      export_var_env_force DYNAWO_USE_XSD_VALIDATION=true
      ;;
    clean-tests-coverage)
      export_var_env_force DYNAWO_BUILD_TYPE=TestCoverage
      export_var_env_force DYNAWO_USE_XSD_VALIDATION=true
      ;;
    *)
      ;;
  esac

  # Find build type for thid party libraries
  export_var_env_force DYNAWO_BUILD_TYPE_THIRD_PARTY=$DYNAWO_BUILD_TYPE
  case $DYNAWO_BUILD_TYPE_THIRD_PARTY in
    Tests | TestCoverage)
      export_var_env_force DYNAWO_BUILD_TYPE_THIRD_PARTY="Debug"
      ;;
    *)
      ;;
  esac

  # Compiler, to have default with gcc
  export_var_env DYNAWO_COMPILER=GCC

  # Set path to compilers
  set_compiler

  # Build_config
  export_var_env DYNAWO_BUILD_TYPE=UNDEFINED
  export_var_env DYNAWO_CXX11_ENABLED=UNDEFINED
  export_var_env_force DYNAWO_USE_ADEPT=YES

  export_var_env DYNAWO_COMPILER_VERSION=$($DYNAWO_C_COMPILER -dumpversion)
  export_var_env DYNAWO_LIBRARY_TYPE=SHARED

  # Dynawo
  export_var_env DYNAWO_HOME=UNDEFINED
  export_git_branch
  export_var_env_force DYNAWO_SRC_DIR=$DYNAWO_HOME/dynawo
  export_var_env DYNAWO_DEPLOY_DIR=$DYNAWO_HOME/deploy/$DYNAWO_COMPILER_NAME$DYNAWO_COMPILER_VERSION/$(echo $DYNAWO_LIBRARY_TYPE | tr "[A-Z]" "[a-z]")

  SUFFIX_CX11=""
  if [ "$(echo "$DYNAWO_CXX11_ENABLED" | tr '[:upper:]' '[:lower:]')" = "yes" -o "$(echo "$DYNAWO_CXX11_ENABLED" | tr '[:upper:]' '[:lower:]')" = "true" -o "$(echo "$DYNAWO_CXX11_ENABLED" | tr '[:upper:]' '[:lower:]')" = "on" ]; then
    SUFFIX_CX11="-cxx11"
  fi

  if [ ! -z "$DYNAWO_JENKINS_MODE" ]; then
    export_var_env DYNAWO_BUILD_DIR=$DYNAWO_HOME/build/$DYNAWO_COMPILER_NAME$DYNAWO_COMPILER_VERSION/$(echo $DYNAWO_LIBRARY_TYPE | tr "[A-Z]" "[a-z]")$SUFFIX_CX11/dynawo
    export_var_env DYNAWO_INSTALL_DIR=$DYNAWO_HOME/install/$DYNAWO_COMPILER_NAME$DYNAWO_COMPILER_VERSION/$(echo $DYNAWO_LIBRARY_TYPE | tr "[A-Z]" "[a-z]")$SUFFIX_CX11/dynawo
  else
    export_var_env DYNAWO_BUILD_DIR=$DYNAWO_HOME/build/$DYNAWO_COMPILER_NAME$DYNAWO_COMPILER_VERSION/$DYNAWO_BRANCH_NAME/$DYNAWO_BUILD_TYPE$SUFFIX_CX11/$(echo $DYNAWO_LIBRARY_TYPE | tr "[A-Z]" "[a-z]")/dynawo
    export_var_env DYNAWO_INSTALL_DIR=$DYNAWO_HOME/install/$DYNAWO_COMPILER_NAME$DYNAWO_COMPILER_VERSION/$DYNAWO_BRANCH_NAME/$DYNAWO_BUILD_TYPE$SUFFIX_CX11/$(echo $DYNAWO_LIBRARY_TYPE | tr "[A-Z]" "[a-z]")/dynawo
  fi
  export_var_env DYNAWO_DEBUG_COMPILER_OPTION="-O1"

  # External libs
  export_var_env_default DYNAWO_ZLIB_HOME=UNDEFINED
  export_var_env_default DYNAWO_LIBARCHIVE_HOME=UNDEFINED
  export_var_env_default DYNAWO_BOOST_HOME=UNDEFINED
  export_var_env DYNAWO_BOOST_USE_STATIC=OFF
  export_var_env_default DYNAWO_GTEST_HOME=UNDEFINED
  export_var_env_default DYNAWO_GMOCK_HOME=UNDEFINED

  # Third parties
  export_var_env_force DYNAWO_THIRD_PARTY_SRC_DIR=$DYNAWO_SRC_DIR/3rdParty
  export_var_env DYNAWO_THIRD_PARTY_BUILD_DIR=$DYNAWO_HOME/build/3rdParty/$DYNAWO_COMPILER_NAME$DYNAWO_COMPILER_VERSION/$(echo $DYNAWO_LIBRARY_TYPE | tr "[A-Z]" "[a-z]")
  export_var_env DYNAWO_THIRD_PARTY_INSTALL_DIR=$DYNAWO_HOME/install/3rdParty/$DYNAWO_COMPILER_NAME$DYNAWO_COMPILER_VERSION/$(echo $DYNAWO_LIBRARY_TYPE | tr "[A-Z]" "[a-z]")
  export_var_env_force DYNAWO_THIRD_PARTY_BUILD_DIR_VERSION=$DYNAWO_THIRD_PARTY_BUILD_DIR/$DYNAWO_BUILD_TYPE_THIRD_PARTY$SUFFIX_CX11
  export_var_env_force DYNAWO_THIRD_PARTY_INSTALL_DIR_VERSION=$DYNAWO_THIRD_PARTY_INSTALL_DIR/$DYNAWO_BUILD_TYPE_THIRD_PARTY$SUFFIX_CX11

  export_var_env_force DYNAWO_SUITESPARSE_BUILD_DIR=$DYNAWO_THIRD_PARTY_BUILD_DIR_VERSION/suitesparse
  export_var_env_force DYNAWO_NICSLU_BUILD_DIR=$DYNAWO_THIRD_PARTY_BUILD_DIR_VERSION/nicslu
  export_var_env_force DYNAWO_SUNDIALS_BUILD_DIR=$DYNAWO_THIRD_PARTY_BUILD_DIR_VERSION/sundials
  export_var_env_force DYNAWO_ADEPT_BUILD_DIR=$DYNAWO_THIRD_PARTY_BUILD_DIR_VERSION/adept
  export_var_env_force DYNAWO_XERCESC_BUILD_DIR=$DYNAWO_THIRD_PARTY_BUILD_DIR_VERSION/xerces-c

  export_var_env_force DYNAWO_SUITESPARSE_INSTALL_DIR=$DYNAWO_THIRD_PARTY_INSTALL_DIR_VERSION/suitesparse
  export_var_env_force DYNAWO_NICSLU_INSTALL_DIR=$DYNAWO_THIRD_PARTY_INSTALL_DIR_VERSION/nicslu
  export_var_env_force DYNAWO_SUNDIALS_INSTALL_DIR=$DYNAWO_THIRD_PARTY_INSTALL_DIR_VERSION/sundials
  export_var_env_force DYNAWO_ADEPT_INSTALL_DIR=$DYNAWO_THIRD_PARTY_INSTALL_DIR_VERSION/adept
  export_var_env_force DYNAWO_XERCESC_INSTALL_DIR=$DYNAWO_THIRD_PARTY_INSTALL_DIR_VERSION/xerces-c

  export_var_env_force DYNAWO_LIBIIDM_HOME=$DYNAWO_THIRD_PARTY_INSTALL_DIR_VERSION/libiidm
  export_var_env_force DYNAWO_LIBIIDM_INSTALL_DIR=$DYNAWO_LIBIIDM_HOME
  export_var_env_force DYNAWO_LIBIIDM_BUILD_DIR=$DYNAWO_THIRD_PARTY_BUILD_DIR_VERSION/libiidm

  export_var_env_force DYNAWO_LIBZIP_HOME=$DYNAWO_THIRD_PARTY_INSTALL_DIR_VERSION/libzip
  export_var_env_force DYNAWO_LIBZIP_INSTALL_DIR=$DYNAWO_LIBZIP_HOME
  export_var_env_force DYNAWO_LIBZIP_BUILD_DIR=$DYNAWO_THIRD_PARTY_BUILD_DIR_VERSION/libzip

  export_var_env_force DYNAWO_LIBXML_HOME=$DYNAWO_THIRD_PARTY_INSTALL_DIR_VERSION/libxml
  export_var_env_force DYNAWO_LIBXML_INSTALL_DIR=$DYNAWO_LIBXML_HOME
  export_var_env_force DYNAWO_LIBXML_BUILD_DIR=$DYNAWO_THIRD_PARTY_BUILD_DIR_VERSION/libxml

  # Miscellaneous
  export_var_env DYNAWO_USE_XSD_VALIDATION=true
  export_var_env DYNAWO_LOCALE=en_GB
  export_var_env DYNAWO_BROWSER=firefox
  export_var_env DYNAWO_PDFVIEWER=xdg-open
  export_var_env_force DYNAWO_NRT_DIR=$DYNAWO_HOME/nrt
  export_var_env DYNAWO_RESULTS_SHOW=true
  export_var_env_force DYNAWO_CURVES_TO_HTML_DIR=$DYNAWO_HOME/util/curvesToHtml
  export_var_env_force DYNAWO_MODEL_DOCUMENTATION_DIR=$DYNAWO_HOME/util/modelDocumentation
  export_var_env_force DYNAWO_SCRIPTS_DIR=$DYNAWO_INSTALL_DIR/sbin
  export_var_env_force DYNAWO_NRT_DIFF_DIR=$DYNAWO_HOME/util/nrt_diff
  export_var_env_force DYNAWO_ENV_DYNAWO=$SCRIPT
  export_var_env DYNAWO_CMAKE_GENERATOR="Unix Makefiles"
  CMAKE_VERSION=$(cmake --version | head -1 | awk '{print $(NF)}')
  CMAKE_BUILD_OPTION=""
  if [ $(echo $CMAKE_VERSION | cut -d '.' -f 1) -ge 3 -a $(echo $CMAKE_VERSION | cut -d '.' -f 2) -ge 12 ]; then
    CMAKE_BUILD_OPTION="-j $DYNAWO_NB_PROCESSORS_USED"
  fi
  export_var_env DYNAWO_CMAKE_BUILD_OPTION="$CMAKE_BUILD_OPTION"

  # Only used until now by nrt
  export_var_env DYNAWO_NB_PROCESSORS_USED=1
  if [ $DYNAWO_NB_PROCESSORS_USED -gt $TOTAL_CPU ]; then
    error_exit "PROCESSORS_USED ($DYNAWO_NB_PROCESSORS_USED) is higher than the number of cpu of the system ($TOTAL_CPU)"
  fi

  # OpenModelica config
  export_var_env DYNAWO_OPENMODELICA_VERSION=1_13_2
  if [ "$DYNAWO_OPENMODELICA_VERSION" != "1_9_4" ] && [ "$DYNAWO_OPENMODELICA_VERSION" != "1_13_2" ]; then
    error_exit "OpenModelica version ($DYNAWO_OPENMODELICA_VERSION) should be 1_9_4 or 1_13_2"
  fi
  export_var_env_force DYNAWO_MODELICA_LIB=3.2.2
  export_var_env DYNAWO_SRC_OPENMODELICA=UNDEFINED
  export_var_env DYNAWO_INSTALL_OPENMODELICA=UNDEFINED

  # JQuery config
  export_var_env DYNAWO_JQUERY_DOWNLOAD_URL=https://github.com/jquery/jquery/archive
  export_var_env DYNAWO_FLOT_DOWNLOAD_URL=https://github.com/flot/flot/archive

  if [ "`uname`" = "Linux" ]; then
    export_var_env_force DYNAWO_SHARED_LIBRARY_SUFFIX="so"
  elif [ "`uname`" = "Darwin" ]; then
    export_var_env_force DYNAWO_SHARED_LIBRARY_SUFFIX="dylib"
  else
    echo "OS `uname` not supported."
    exit 1
  fi

  # Export library path, path and other standard environment variables
  set_standard_environment_variables

  set_commit_hook

  set_cpplint
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

  if [ $DYNAWO_ZLIB_HOME_DEFAULT != true ]; then
    ld_library_path_prepend $DYNAWO_ZLIB_HOME/lib
  fi

  if [ $DYNAWO_LIBARCHIVE_HOME_DEFAULT != true ]; then
    ld_library_path_prepend $DYNAWO_LIBARCHIVE_HOME/lib
  fi

  if [ $DYNAWO_BOOST_HOME_DEFAULT != true ]; then
    ld_library_path_prepend $DYNAWO_BOOST_HOME/lib
  fi

  if [ "$DYNAWO_BUILD_TYPE" = "Debug" -o "$DYNAWO_BUILD_TYPE" = "Tests" -o "$DYNAWO_BUILD_TYPE" = "TestCoverage" ]; then
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

  hook_file_master='#!'"/bin/sh
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
    if [ "$(git config --get core.commentchar)" = "#" ]; then
      git config core.commentchar % || error_exit "You need to change git config commentchar from # to %."
    fi
  fi
}

set_cpplint() {
  export_var_env DYNAWO_CPPLINT_DOWNLOAD_URL=https://github.com/cpplint/cpplint/archive
  CPPLINT_VERSION=1.3.0
  CPPLINT_ARCHIVE=$CPPLINT_VERSION.tar.gz

  CPPLINT_FILE=cpplint.py
  CPPLINT_DIR=$DYNAWO_HOME/cpplint

  if [ ! -f "$CPPLINT_DIR/$CPPLINT_FILE" ]; then
    if [ -x "$(command -v wget)" ]; then
      wget --timeout 10 --tries 3 ${DYNAWO_CPPLINT_DOWNLOAD_URL}/${CPPLINT_ARCHIVE} -P "$CPPLINT_DIR" > /dev/null 2>&1 || error_exit "Error while downloading cpplint."
    elif [ -x "$(command -v curl)" ]; then
      curl -L --connect-timeout 10 --retry 2 ${DYNAWO_CPPLINT_DOWNLOAD_URL}/${CPPLINT_ARCHIVE} --output "$CPPLINT_DIR/$CPPLINT_ARCHIVE" > /dev/null 2>&1 || error_exit "Error while downloading cpplint."
    else
      error_exit "You need to install either wget or curl."
    fi
    if [ -x "$(command -v tar)" ]; then
      tar xzf "$CPPLINT_DIR/$CPPLINT_ARCHIVE" -C $CPPLINT_DIR
      cp "$CPPLINT_DIR/cpplint-$CPPLINT_VERSION/$CPPLINT_FILE" "$CPPLINT_DIR/$CPPLINT_FILE"
      rm -rf "$CPPLINT_DIR/cpplint-$CPPLINT_VERSION"
      rm -f "$CPPLINT_DIR/$CPPLINT_ARCHIVE"
    else
      error_exit "You need to install tar command line utility."
    fi
  fi
}

display_environment_variables() {
  printenv | grep DYNAWO_ | sort
  echo PATH $PATH
  echo PYTHONPATH $PYTHONPATH
  echo LD_LIBRARY_PATH $LD_LIBRARY_PATH
}

is_omcDynawo_installed() {
  if [ ! -x "$DYNAWO_INSTALL_OPENMODELICA/bin/omcDynawo" ]; then
    return 1
  elif [ -x "$DYNAWO_INSTALL_OPENMODELICA/bin/omcDynawo" ]; then
    $DYNAWO_INSTALL_OPENMODELICA/bin/omcDynawo --version > /dev/null 2>&1 || return 1
    installed_version=$($DYNAWO_INSTALL_OPENMODELICA/bin/omcDynawo --version | cut -d ' ' -f2 | tr -d 'v')
    if [ "$installed_version" != ${DYNAWO_OPENMODELICA_VERSION//_/.} ]; then
      return 1
    fi
    if [ ! -d "$DYNAWO_INSTALL_OPENMODELICA/lib/omlibrary" ]; then
      return 1
    else
      if [ ! -d "$DYNAWO_INSTALL_OPENMODELICA/lib/omlibrary/Modelica" ]; then
        return 1
      fi
      if [ ! -d "$DYNAWO_INSTALL_OPENMODELICA/lib/omlibrary/ModelicaServices" ]; then
        return 1
      fi
      if [ ! -f "$DYNAWO_INSTALL_OPENMODELICA/lib/omlibrary/Complex.mo" ]; then
        return 1
      fi
    fi
  fi
  return 0
}

# Build openModelica compiler
build_omcDynawo() {
  if ! is_omcDynawo_installed; then
    if [ ! -d "$DYNAWO_SRC_DIR/3rdParty/omcUpdate_$DYNAWO_OPENMODELICA_VERSION" ]; then
      error_exit "$DYNAWO_SRC_DIR/3rdParty/omcUpdate_$DYNAWO_OPENMODELICA_VERSION does not exist."
    fi
    cd $DYNAWO_SRC_DIR/3rdParty/omcUpdate_$DYNAWO_OPENMODELICA_VERSION
    bash checkoutOpenModelica.sh --openmodelica-dir=$DYNAWO_SRC_OPENMODELICA --openmodelica-version=$DYNAWO_OPENMODELICA_VERSION --modelica-version=$DYNAWO_MODELICA_LIB || error_exit "OpenModelica source code is not well checked-out. Delete your current source folder and relaunch command."
    bash cleanBeforeLaunch.sh --openmodelica-dir=$DYNAWO_SRC_OPENMODELICA || error_exit "Cleaning of OpenModelica source folder did not work. Delete your current source folder and relaunch command."
    bash omcUpdateDynawo.sh --openmodelica-dir=$DYNAWO_SRC_OPENMODELICA --openmodelica-install=$DYNAWO_INSTALL_OPENMODELICA --nbProcessors=$DYNAWO_NB_PROCESSORS_USED || error_exit "Building of OpenModelica did not work. Delete your current source folder and relaunch command."
  else
    echo "OpenModelica for Dynawo is already installed."
    echo "You can re-install it by launching clean-omcDynawo command first."
  fi
}

# Clean openModelica compiler
clean_omcDynawo() {
  if [ ! -d "$DYNAWO_SRC_DIR/3rdParty/omcUpdate_$DYNAWO_OPENMODELICA_VERSION" ]; then
    error_exit "$DYNAWO_SRC_DIR/3rdParty/omcUpdate_$DYNAWO_OPENMODELICA_VERSION does not exist."
  fi
  cd $DYNAWO_SRC_DIR/3rdParty/omcUpdate_$DYNAWO_OPENMODELICA_VERSION
  bash cleanBeforeLaunch.sh --openmodelica-dir=$DYNAWO_SRC_OPENMODELICA --openmodelica-install=$DYNAWO_INSTALL_OPENMODELICA
}

# Build third parties
build_3rd_party() {
  # Save DYNAWO_BUILD_TYPE and DYNAWO_CXX11_ENABLED as I force it to change to build all 3rd party combination
  INITIAL_BUILD_TYPE=$DYNAWO_BUILD_TYPE
  INITIAL_CXX11_ENABLED=$DYNAWO_CXX11_ENABLED

  export_var_env_force DYNAWO_BUILD_TYPE=Release
  export_var_env_force DYNAWO_CXX11_ENABLED=NO
  set_environment "No-Mode"
  build_3rd_party_version || error_exit "Error during 3rd parties build in Release and c++98."

  export_var_env_force DYNAWO_CXX11_ENABLED=YES
  set_environment "No-Mode"
  build_3rd_party_version || error_exit "Error during 3rd parties build in Release and c++11."

  export_var_env_force DYNAWO_BUILD_TYPE=Debug
  export_var_env_force DYNAWO_CXX11_ENABLED=NO
  set_environment "No-Mode"
  build_3rd_party_version || error_exit "Error during 3rd parties build in Debug and c++98."

  export_var_env_force DYNAWO_CXX11_ENABLED=YES
  set_environment "No-Mode"
  build_3rd_party_version || error_exit "Error during 3rd parties build in Debug and c++11."

  # Come back to initial environement
  export_var_env_force DYNAWO_BUILD_TYPE=$INITIAL_BUILD_TYPE
  export_var_env_force DYNAWO_CXX11_ENABLED=$INITIAL_CXX11_ENABLED
  set_environment $MODE

  NICSLU_ARCHIVE=_nicslu301.zip
  if [ ! -f "$DYNAWO_SRC_DIR/3rdParty/nicslu/$NICSLU_ARCHIVE" ]; then
    echo ""
    echo "Nicslu was not installed. You can download it from http://nicslu.weebly.com/ and copy/paste the zip obtained in $DYNAWO_SRC_DIR/3rdParty/nicslu."
    echo ""
  fi
}

# Build a speficic version of third party libraries
build_3rd_party_version() {
  if ! is_3rd_party_version_installed; then
    if [ ! -d "$DYNAWO_SRC_DIR/3rdParty" ]; then
      error_exit "$DYNAWO_SRC_DIR/3rdParty does not exist."
    fi
    cd $DYNAWO_SRC_DIR/3rdParty
    if [ $DYNAWO_BOOST_HOME_DEFAULT != true ]; then
      BOOST_OPTION="--boost-install-dir=$DYNAWO_BOOST_HOME"
    else
      BOOST_OPTION=""
    fi
    if [ $DYNAWO_LIBARCHIVE_HOME_DEFAULT != true ]; then
      LIBARCHIVE_OPTION="--libarchive-install-dir=$DYNAWO_LIBARCHIVE_HOME"
    else
      LIBARCHIVE_OPTION=""
    fi
    case "$DYNAWO_BUILD_TYPE_THIRD_PARTY" in
      Debug)
        if [ $DYNAWO_GTEST_HOME_DEFAULT != true ]; then
          GTEST_OPTION="--gtest-install-dir=$DYNAWO_GTEST_HOME"
        else
          GTEST_OPTION=""
        fi
        ;;
      *)
        GTEST_OPTION=""
        ;;
    esac

    bash toolchain.sh --build-type=$DYNAWO_BUILD_TYPE_THIRD_PARTY \
      --sundials-install-dir=$DYNAWO_SUNDIALS_INSTALL_DIR \
      --suitesparse-install-dir=$DYNAWO_SUITESPARSE_INSTALL_DIR \
      --adept-install-dir=$DYNAWO_ADEPT_INSTALL_DIR \
      --nicslu-install-dir=$DYNAWO_NICSLU_INSTALL_DIR \
      --libzip-install-dir=$DYNAWO_LIBZIP_INSTALL_DIR \
      --libxml-install-dir=$DYNAWO_LIBXML_INSTALL_DIR \
      --libiidm-install-dir=$DYNAWO_LIBIIDM_INSTALL_DIR \
      --xercesc-install-dir=$DYNAWO_XERCESC_INSTALL_DIR \
      --sundials-build-dir=$DYNAWO_SUNDIALS_BUILD_DIR \
      --suitesparse-build-dir=$DYNAWO_SUITESPARSE_BUILD_DIR \
      --nicslu-build-dir=$DYNAWO_NICSLU_BUILD_DIR \
      --adept-build-dir=$DYNAWO_ADEPT_BUILD_DIR \
      --libzip-build-dir=$DYNAWO_LIBZIP_BUILD_DIR \
      --libxml-build-dir=$DYNAWO_LIBXML_BUILD_DIR \
      --libiidm-build-dir=$DYNAWO_LIBIIDM_BUILD_DIR \
      --xercesc-build-dir=$DYNAWO_XERCESC_BUILD_DIR \
      $BOOST_OPTION $LIBARCHIVE_OPTION $GTEST_OPTION

    RETURN_CODE=$?
    return ${RETURN_CODE}
  fi
}

# Very simple check to see if each third party has installed something or not
is_3rd_party_version_installed() {
  third_party_folders=(adept libiidm libxml libzip suitesparse sundials xerces-c)
  for folder in ${third_party_folders[*]}; do
    if [ ! -d "$DYNAWO_THIRD_PARTY_INSTALL_DIR_VERSION/$folder" ]; then
      return 1
    fi
    if [[ ! -d "$DYNAWO_THIRD_PARTY_INSTALL_DIR_VERSION/$folder/lib" && ! -d "$DYNAWO_THIRD_PARTY_INSTALL_DIR_VERSION/$folder/lib64" ]]; then
      return 1
    fi
    if [ ! -d "$DYNAWO_THIRD_PARTY_INSTALL_DIR_VERSION/$folder/include" ]; then
      return 1
    fi
    if [[ -z "$(find $DYNAWO_THIRD_PARTY_INSTALL_DIR_VERSION/$folder/lib \( -name "*.$DYNAWO_SHARED_LIBRARY_SUFFIX" -o -name "*.a" \) 2> /dev/null)" && -z "$(find $DYNAWO_THIRD_PARTY_INSTALL_DIR_VERSION/$folder/lib64 \( -name "*.$DYNAWO_SHARED_LIBRARY_SUFFIX" -o -name "*.a" \) 2> /dev/null)" ]]; then
      return 1
    fi
    if [[ -z "$(find $DYNAWO_THIRD_PARTY_INSTALL_DIR_VERSION/$folder/include -name "*.h")" && -z "$(find $DYNAWO_THIRD_PARTY_INSTALL_DIR_VERSION/$folder/include -name "*.hpp")" ]]; then
      return 1
    fi
  done
  return 0
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

  CMAKE_OPTIONNAL=""
  if [ $DYNAWO_BOOST_HOME_DEFAULT != true ]; then
    CMAKE_OPTIONNAL="-DBOOST_ROOT=$DYNAWO_BOOST_HOME"
  fi
  if [ $DYNAWO_ZLIB_HOME_DEFAULT != true ]; then
    CMAKE_OPTIONNAL="$CMAKE_OPTIONNAL -DZLIB_ROOT=$DYNAWO_ZLIB_HOME"
  fi
  if [ $DYNAWO_LIBARCHIVE_HOME_DEFAULT != true ]; then
    CMAKE_OPTIONNAL="$CMAKE_OPTIONNAL -DLIBARCHIVE_HOME=$DYNAWO_LIBARCHIVE_HOME"
  fi
  case $DYNAWO_BUILD_TYPE in
    Tests|TestCoverage)
      if [ $DYNAWO_GTEST_HOME_DEFAULT != true ]; then
        CMAKE_OPTIONNAL="$CMAKE_OPTIONNAL -DGTEST_ROOT=$DYNAWO_GTEST_HOME"
      fi
      if [ $DYNAWO_GMOCK_HOME_DEFAULT != true ]; then
        CMAKE_OPTIONNAL="$CMAKE_OPTIONNAL -DGMOCK_HOME=$DYNAWO_GMOCK_HOME"
      fi
      ;;
    *)
      ;;
  esac

  cmake -DLIBRARY_TYPE=$DYNAWO_LIBRARY_TYPE \
    -DCMAKE_C_COMPILER:PATH=$DYNAWO_C_COMPILER \
    -DCMAKE_CXX_COMPILER:PATH=$DYNAWO_CXX_COMPILER \
    -DCMAKE_BUILD_TYPE:STRING=$DYNAWO_BUILD_TYPE \
    -DDYNAWO_HOME:PATH=$DYNAWO_HOME \
    -DCMAKE_INSTALL_PREFIX:PATH=$DYNAWO_INSTALL_DIR \
    -DUSE_ADEPT:BOOL=$DYNAWO_USE_ADEPT \
    -DINSTALL_OPENMODELICA:PATH=$DYNAWO_INSTALL_OPENMODELICA \
    -DOPENMODELICA_VERSION:STRING=$DYNAWO_OPENMODELICA_VERSION \
    -DCXX11_ENABLED:BOOL=$DYNAWO_CXX11_ENABLED \
    -DBOOST_ROOT_DEFAULT:STRING=$DYNAWO_BOOST_HOME_DEFAULT \
    -DBOOST_USE_STATIC=$DYNAWO_BOOST_USE_STATIC \
    -DDYNAWO_DEBUG_COMPILER_OPTION:STRING="$DYNAWO_DEBUG_COMPILER_OPTION" \
    -DADEPT_HOME=$DYNAWO_ADEPT_INSTALL_DIR \
    -DSUNDIALS_HOME=$DYNAWO_SUNDIALS_INSTALL_DIR \
    -DSUITESPARSE_HOME=$DYNAWO_SUITESPARSE_INSTALL_DIR \
    -DNICSLU_HOME=$DYNAWO_NICSLU_INSTALL_DIR \
    -DLIBZIP_HOME=$DYNAWO_LIBZIP_INSTALL_DIR \
    $CMAKE_OPTIONNAL \
    -G "$DYNAWO_CMAKE_GENERATOR" \
    "-DCMAKE_PREFIX_PATH=$DYNAWO_LIBXML_HOME;$DYNAWO_LIBIIDM_HOME" \
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
  build_3rd_party_version || error_exit "Error during 3rd parties installation."
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
    make -j $DYNAWO_NB_PROCESSORS_USED && make -j $DYNAWO_NB_PROCESSORS_USED install
  else
    cmake --build $DYNAWO_BUILD_DIR $DYNAWO_CMAKE_BUILD_OPTION --config $DYNAWO_BUILD_TYPE && cmake --build $DYNAWO_BUILD_DIR --target install --config $DYNAWO_BUILD_TYPE
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

build_user() {
  build_omcDynawo || error_exit "Error during OpenModelica installation."
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
  build_3rd_party_version || error_exit "Error during build_3rd_party_version."
  if [ ! -d "$DYNAWO_BUILD_DIR" ]; then
    config_dynawo || error_exit "Error during config_dynawo."
  fi
  ## for unit test, no need to generate modelica models
  build_dynawo_core || error_exit "Error during build_dynawo_core."
  build_dynawo_models_cpp || error_exit "Error during build_dynawo_models_cpp."

  tests=$@
  if [ -z "$tests" ]; then
    cmake --build $DYNAWO_BUILD_DIR --target tests --config Tests
  else
    cmake --build $DYNAWO_BUILD_DIR --target ${tests} --config Tests
  fi
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

list_tests() {
  build_3rd_party_version > /dev/null 2>&1 || error_exit "Error during build_3rd_party_version."
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
  build_3rd_party_version || error_exit "Error during build_3rd_party_version."
  if [ ! -d "$DYNAWO_BUILD_DIR" ]; then
    config_dynawo || error_exit "Error during config_dynawo."
  fi
  ## for unit test, no need to generate modelica models
  build_dynawo_core || error_exit "Error during build_dynawo_core."
  build_dynawo_models_cpp || error_exit "Error during build_dynawo_models_cpp."

  tests=$@

  cmake --build $DYNAWO_BUILD_DIR --target reset-coverage --config TestCoverage || error_exit "Error during make reset-coverage."
  if [ -z "$tests" ]; then
    cmake --build $DYNAWO_BUILD_DIR --target tests-coverage --config TestCoverage || error_exit "Error during make tests-coverage."
  else
    for test in ${tests}; do
      cmake --build $DYNAWO_BUILD_DIR --target ${test}-coverage --config TestCoverage || error_exit "Error during make ${test}-coverage."
    done
  fi
  cmake --build $DYNAWO_BUILD_DIR --target export-coverage --config TestCoverage
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
    nb_warnings=$(wc -l $DYNAWO_INSTALL_DIR/doxygen/warnings.txt | awk '{print $1}')
    if [ ${nb_warnings} -ne 0 ]; then
      echo "===================================="
      echo "| Result of doxygen doc generation |"
      echo "===================================="
      echo " nbWarnings = ${nb_warnings} > 0 => doc is incomplete"
      echo " edit ${DYNAWO_INSTALL_DIR}/doxygen/warnings.txt  to have more details"
      error_exit "Doxygen doc is not complete"
    fi
  fi
}

# Compile Dynawo Modelica library doc
build_modelica_doc() {
  error_exit "Not available for the moment."
  # python $DYNAWO_MODEL_DOCUMENTATION_DIR/latex/model_documentation.py --model_file=$DYNAWO_MODEL_DOCUMENTATION_DIR/latex/models.txt --outputDir=$DYNAWO_HOME/documents/ModelicaDocumentation/resources || error_exit "Error during LaTeX file generation"
  # Do it twice to generate cross references and Contents section
  # pdflatex -halt-on-error -output-directory $DYNAWO_HOME/documentation/ModelicaDocumentation $DYNAWO_HOME/documentation/ModelicaDocumentation/resources/model_documentation.tex
  # pdflatex -halt-on-error -output-directory $DYNAWO_HOME/documentation/ModelicaDocumentation $DYNAWO_HOME/documentation/ModelicaDocumentation/resources/model_documentation.tex
  # test_modelica_doc
}

test_modelica_doc() {
  if [ -f "$DYNAWO_HOME/documentation/ModelicaDocumentation/resources/model_documentation.tex" ] ; then
    nb_diff=$(diff $DYNAWO_HOME/documentation/ModelicaDocumentation/resources/model_documentation.tex $DYNAWO_MODEL_DOCUMENTATION_DIR/latex/ref.tex | wc -l)
    if [ ${nb_diff} -ne 0 ]; then
      error_exit "The generated LaTeX file does not correspond to the reference"
    fi
  else
    error_exit "Dynawo Modelica library LaTeX file not found"
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
  python $DYNAWO_CURVES_TO_HTML_DIR/curvesToHtml.py --jobsFile=$(python -c "import os; print(os.path.realpath('$1'))") --withoutOffset --htmlBrowser="$DYNAWO_BROWSER" || return 1
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

flat_model() {
  error_exit "Not available for the moment."
  # python $DYNAWO_MODEL_DOCUMENTATION_DIR/model_documentation.py --model=$@ --outputDir=/tmp/dynawo/doxygen --outputFormat=Modelica
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
  python -u $DYNAWO_NRT_DIR/nrt.py $@
  FAILED_CASES_NUM=$?

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
}

nrt_diff() {
  python $DYNAWO_NRT_DIFF_DIR/nrtDiff.py $@
}

nrt_ref() {
  python $DYNAWO_NRT_DIFF_DIR/defineTestReference.py $@
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
  if [ "$DYNAWO_LIBRARY_TYPE" = "SHARED" ]; then
    if [ "`uname`" = "Linux" ]; then
      path=$(ldd $DYNAWO_INSTALL_DIR/bin/dynawo | grep "$1" | cut -d '>' -f 2 | awk '{print $1}' | sed "s/lib$1.*//g"  | uniq)
    elif [ "`uname`" = "Darwin" ]; then
      path=$(otool -L $DYNAWO_INSTALL_DIR/bin/dynawo | grep "$1" | awk '{print $1}' | sed "s/lib$1.*//g"  | uniq)
    else
      echo "OS not supported."
      exit 1
    fi
  elif [ "$DYNAWO_LIBRARY_TYPE" = "STATIC" ]; then
    LIBRARY_SUFFIX="a"
    if [ ! -f "$DYNAWO_BUILD_DIR/CMakeCache.txt" ]; then
      error_exit "$DYNAWO_BUILD_DIR should not be deleted before deploy to be able to determine include system paths used during compilation."
    fi
    path=$(cat $DYNAWO_BUILD_DIR/CMakeCache.txt | grep -i "${1}_LIBRARY_DIR_RELEASE:PATH" | cut -d '=' -f 2)
  else
    error_exit "Wrong type of library build: $DYNAWO_LIBRARY_TYPE, either SHARED or STATIC."
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

deploy_dynawo() {
  DYNAWO_VERSION=$(version) || error_exit "Error with version."
  version=$(echo $DYNAWO_VERSION | cut -f1 -d' ')
  rm -rf $DYNAWO_DEPLOY_DIR

  # check coding
  check_coding_files

  current_dir=$PWD
  mkdir -p $DYNAWO_DEPLOY_DIR || error_exit "Impossible to create $DYNAWO_DEPLOY_DIR."
  cd $DYNAWO_DEPLOY_DIR
  mkdir -p lib

  cp -P $DYNAWO_SUNDIALS_INSTALL_DIR/lib*/*.* lib/
  cp -P $DYNAWO_ADEPT_INSTALL_DIR/lib/*.* lib/
  cp -P $DYNAWO_SUITESPARSE_INSTALL_DIR/lib/*.* lib/
  if [ -d "$DYNAWO_NICSLU_INSTALL_DIR/lib" ]; then
    if [ ! -z "$(ls -A $DYNAWO_NICSLU_INSTALL_DIR/lib)" ]; then
      cp -P $DYNAWO_NICSLU_INSTALL_DIR/lib/*.* lib/
    fi
  fi
  cp -P $DYNAWO_LIBZIP_HOME/lib/*.* lib/
  cp -P $DYNAWO_LIBXML_HOME/lib/*.* lib/
  cp -P $DYNAWO_LIBIIDM_HOME/lib/*.* lib/

  if [ ! -d "$DYNAWO_DEPLOY_DIR" ]; then
    error_exit "$DYNAWO_DEPLOY_DIR does not exist."
  fi
  cd $DYNAWO_DEPLOY_DIR

  mkdir -p include
  cp -n -R -P $DYNAWO_SUNDIALS_INSTALL_DIR/include/* include/
  cp -n -R $DYNAWO_ADEPT_INSTALL_DIR/include/* include/
  cp -n -P $DYNAWO_SUITESPARSE_INSTALL_DIR/include/*.* include/
  if [ -d "$DYNAWO_NICSLU_INSTALL_DIR/include" ]; then
    if [ ! -z "$(ls -A $DYNAWO_NICSLU_INSTALL_DIR/include)" ]; then
      cp -n -P $DYNAWO_NICSLU_INSTALL_DIR/include/*.* include/
    fi
  fi
  cp -n -R -P $DYNAWO_LIBZIP_HOME/include/libzip include/
  cp -n -R -P $DYNAWO_LIBXML_HOME/include/xml include/
  cp -n -R -P $DYNAWO_LIBIIDM_HOME/include/IIDM include/

  mkdir -p share
  cp -R -P $DYNAWO_LIBXML_HOME/share/cmake share/
  cp -R -P $DYNAWO_LIBIIDM_HOME/share/cmake share/
  cp -R -P $DYNAWO_LIBIIDM_HOME/share/iidm share/

  for file in $(grep -rl $DYNAWO_LIBXML_HOME share/cmake/*); do
    sed -i "s|$DYNAWO_LIBXML_HOME|$DYNAWO_DEPLOY_DIR|" $file
  done
  for file in $(grep -rl $DYNAWO_XERCESC_INSTALL_DIR share/cmake/*); do
    sed -i "s|$DYNAWO_XERCESC_INSTALL_DIR|$DYNAWO_DEPLOY_DIR|" $file
  done
  for file in $(grep -rl $DYNAWO_LIBIIDM_HOME share/cmake/*); do
    sed -i "s|$DYNAWO_LIBIIDM_HOME|$DYNAWO_DEPLOY_DIR|" $file
  done
  for file in $(grep -rl $DYNAWO_LIBXML_HOME share/cmake/*); do
    sed -i "s|$DYNAWO_LIBXML_HOME|$DYNAWO_DEPLOY_DIR|" $file
  done

  mkdir -p OpenModelica/bin/
  mkdir -p OpenModelica/include/
  mkdir -p OpenModelica/lib/omc/
  cp -P $DYNAWO_INSTALL_OPENMODELICA/bin/omc* OpenModelica/bin
  cp -P -R $DYNAWO_INSTALL_OPENMODELICA/include/omc OpenModelica/include/
  cp -P -R $DYNAWO_INSTALL_OPENMODELICA/lib/* OpenModelica/lib/
  cp -P $DYNAWO_INSTALL_OPENMODELICA/lib/omc/*.mo OpenModelica/lib/omc/
  cp -P -R $DYNAWO_INSTALL_OPENMODELICA/lib/omlibrary OpenModelica/lib/

  if [ "$DYNAWO_LIBRARY_TYPE" = "SHARED" ]; then
    LIBRARY_SUFFIX=$DYNAWO_SHARED_LIBRARY_SUFFIX
  elif [ "$DYNAWO_LIBRARY_TYPE" = "STATIC" ]; then
    LIBRARY_SUFFIX="a"
  else
    error_exit "Wrong type of library build: $DYNAWO_LIBRARY_TYPE, either SHARED or STATIC."
  fi

  # BOOST
  if [ $DYNAWO_BOOST_HOME_DEFAULT != true ]; then
    boost_system_folder=$DYNAWO_BOOST_HOME/lib
    boost_system_folder_include=$DYNAWO_BOOST_HOME/include
  else
    boost_system_folder=$(find_lib_system_path boost) || error_exit "Path for boost could not be found for deploy."
    boost_system_folder_include=$(find_include_system_path Boost_INCLUDE_DIR) || error_exit "Path for boost include could not be found for deploy."
  fi
  if [ -f "$DYNAWO_BUILD_DIR/CMakeCache.txt" ]; then
    for lib_boost in $(grep -o "libboost.*.$LIBRARY_SUFFIX" $DYNAWO_BUILD_DIR/CMakeCache.txt | tr ';' '\n' | grep -o "libboost.*.$LIBRARY_SUFFIX" | sort | uniq); do
      cp -P ${boost_system_folder}/${lib_boost}* lib/
    done
  else
    error_exit "$DYNAWO_BUILD_DIR should not be deleted before deploy to be able to determine boost libraries used during compilation."
  fi
  if [ -f "$boost_system_folder/libboost_iostreams.$LIBRARY_SUFFIX" ]; then
    cp -P $boost_system_folder/libboost_iostreams*.$LIBRARY_SUFFIX lib/
  fi
  cp -n -P -R $boost_system_folder_include/boost include/

  # XERCESC
  cp -P $DYNAWO_XERCESC_INSTALL_DIR/lib/libxerces-c*.* lib/
  cp -n -r $DYNAWO_XERCESC_INSTALL_DIR/include/* include/

  # ZLIB
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
  fi

  # DYNAWO
  mkdir -p bin
  cp -r $DYNAWO_INSTALL_DIR/bin/* bin/
  cp -r $DYNAWO_INSTALL_DIR/lib/* lib/
  cp -n -r $DYNAWO_INSTALL_DIR/include/* include/
  cp -r $DYNAWO_INSTALL_DIR/share/* share/
  cp -r $DYNAWO_INSTALL_DIR/ddb .

  mkdir -p sbin
  cp $DYNAWO_INSTALL_DIR/sbin/*.py sbin/
  cp $DYNAWO_INSTALL_DIR/sbin/cleanCompileModelicaModel sbin/
  cp $DYNAWO_INSTALL_DIR/sbin/compileCppModelicaModelInDynamicLib sbin/
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
  cp -r $DYNAWO_HOME/util/nrt_diff/*.py sbin/nrt/nrt_diff
  cp -r $DYNAWO_NRT_DIR/nrt.py sbin/nrt/.
  cp -r $DYNAWO_NRT_DIR/resources sbin/nrt/.

  rm -f lib/*.la
  find OpenModelica/lib -name "*.la" -exec rm {} \;

  cd $current_dir
}

copy_sources() {
  mkdir -p $DYNAWO_DEPLOY_DIR/sources || error_exit "Impossible to create $DYNAWO_DEPLOY_DIR."
  if [ -e "$DYNAWO_HOME/.git" ]; then
    for file in $(git ls-files); do
      tar cf - $file | (cd $DYNAWO_DEPLOY_DIR/sources && tar xf -)
    done
  fi
}

binary_rpath_for_darwin() {
  if [ "`uname`" = "Darwin" ]; then
    version=$($DYNAWO_DEPLOY_DIR/bin/dynawo --version | cut -d ' ' -f 1)
    bins=("bin/dynawo" "bin/dynawo-$version" "sbin/dumpModel" "sbin/compileModelicaModel" "sbin/dumpSolver" "sbin/generate-preassembled" "sbin/generate-preassembled-$version")

    for bin in ${bins[@]}; do
      for lib_path in $(otool -l $DYNAWO_DEPLOY_DIR/$bin | grep RPATH -A2 | grep path | awk '{print $2}' | grep -v "@.*path"); do
        install_name_tool -delete_rpath $lib_path $DYNAWO_DEPLOY_DIR/$bin
      done

      install_name_tool -add_rpath @loader_path/../lib $DYNAWO_DEPLOY_DIR/$bin 2> /dev/null

      for lib_path in $(otool -l $DYNAWO_DEPLOY_DIR/$bin | grep -A2 LC_LOAD_DYLIB | grep dylib | grep name |awk '{print $2}' | grep -v "@.*path" | grep -v "^/usr/lib/" | grep -v "^/usr/local/lib/" | grep -v "^/System"); do
        install_name_tool -change $lib_path @rpath/$(echo $lib_path | awk -F'/' '{print $(NF)}') $DYNAWO_DEPLOY_DIR/$bin
      done
    done

    for lib in $(find $DYNAWO_DEPLOY_DIR/lib -name "*.dylib"); do
      for lib_path in $(otool -l $lib | grep RPATH -A2 | grep path | awk '{print $2}' | grep -v "@.*path"); do
        install_name_tool -delete_rpath $lib_path $lib
      done
    done

    for lib in $(find $DYNAWO_DEPLOY_DIR/OpenModelica/lib -name "*.dylib"); do
      install_name_tool -id @rpath/$(basename $lib) $lib
      for lib_path in $(otool -l $lib | grep -A2 LC_LOAD_DYLIB | grep dylib | grep name |awk '{print $2}' | grep -v "@.*path" | grep -v "^/usr/lib/" | grep -v "^/usr/local/lib/" | grep -v "^/System"); do
        omc_lib_path=$DYNAWO_DEPLOY_DIR/OpenModelica/$(otool -l $DYNAWO_DEPLOY_DIR/OpenModelica/bin/omc | grep "@loader_path" | grep -o "lib/.*" | cut -d ' ' -f 1)
        if [ ! -d "$omc_lib_path" ]; then
          error_exit "Directory $omc_lib_path does not exist."
        fi
        if [ -f "$lib_path" ]; then
          cp $lib_path $omc_lib_path || error_exit "Copy of $lib_path into $omc_lib_path failed."
          for lib_path_dylib in $(otool -l $omc_lib_path/$(basename $lib_path) | grep -A2 LC_LOAD_DYLIB | grep dylib | grep name |awk '{print $2}' | grep -v "@.*path" | grep -v "^/usr/lib/" | grep -v "^/usr/local/lib/" | grep -v "^/System"); do
            install_name_tool -change $lib_path_dylib @rpath/$(echo $lib_path_dylib | awk -F'/' '{print $(NF)}') $omc_lib_path/$(basename $lib_path)
          done
          install_name_tool -id @rpath/$(basename $lib_path) $omc_lib_path/$(basename $lib_path)
          install_name_tool -change $lib_path @rpath/$(echo $lib_path | awk -F'/' '{print $(NF)}') $lib
        else
          echo "Warning: could not find $lib_path, you may have issues with this library at runtime."
        fi
      done
    done
  fi
}

create_distrib_with_omc() {
  # Set Dynawo distrib version
  DYNAWO_VERSION=$(version) || error_exit "Error with version."
  version=$(echo $DYNAWO_VERSION | cut -f1 -d' ')

  ZIP_FILE=Dynawo_omc_V$version.zip

  # check coding
  check_coding_files

  # Deploy Dynawo
  deploy_dynawo

  if [ "$DYNAWO_COMPILER" = "GCC" ]; then
    gcc_version=$($DYNAWO_C_COMPILER -dumpversion)
    if [ $(echo $gcc_version | cut -d '.' -f 1) -lt 5 ]; then
      sed -i 's/FLAGS="$FLAGS -std=c++98"/FLAGS="$FLAGS -std=c++98 -D_GLIBCXX_USE_CXX11_ABI=0"/' $DYNAWO_DEPLOY_DIR/sbin/compileCppModelicaModelInDynamicLib
    elif [ $(echo $gcc_version | cut -d '.' -f 1) -eq 5 -a $(echo $gcc_version | cut -d '.' -f 2) -lt 1 ]; then
      sed -i 's/FLAGS="$FLAGS -std=c++98"/FLAGS="$FLAGS -std=c++98 -D_GLIBCXX_USE_CXX11_ABI=0"/' $DYNAWO_DEPLOY_DIR/sbin/compileCppModelicaModelInDynamicLib
    fi
  fi

  copy_sources

  ln -s $DYNAWO_DEPLOY_DIR/sources/nrt/data $DYNAWO_DEPLOY_DIR/testcases

  if [ ! -x "$(command -v zip)" ]; then
    error_exit "You need to install zip command line utility."
  fi

  if [ "`uname`" = "Linux" ]; then
    if [ -x "$(command -v chrpath)" ]; then
      if [ "$DYNAWO_LIBRARY_TYPE" = "SHARED" ]; then
        chrpath -d $DYNAWO_DEPLOY_DIR/lib/libamd.so
        chrpath -d $DYNAWO_DEPLOY_DIR/lib/libbtf.so
        chrpath -d $DYNAWO_DEPLOY_DIR/lib/libcolamd.so
        chrpath -d $DYNAWO_DEPLOY_DIR/lib/libklu.so
        chrpath -d $DYNAWO_DEPLOY_DIR/lib/libsuitesparseconfig.so
      fi
    fi
  fi

  binary_rpath_for_darwin

  # create distribution
  if [ ! -d "$DYNAWO_DEPLOY_DIR" ]; then
    error_exit "$DYNAWO_DEPLOY_DIR does not exist."
  fi
  cd $DYNAWO_DEPLOY_DIR
  zip -r -y $ZIP_FILE bin/ lib/ sources/ testcases/

  zip -r -y $ZIP_FILE share/iidm share/xsd share/*.dic share/*.par

  # need with omc binary
  zip -r -g -y $ZIP_FILE ddb/ include/ sbin/

  zip -r -g -y $ZIP_FILE OpenModelica

  # move distribution in distribution directory
  DISTRIB_DIR=$DYNAWO_HOME/distributions
  mkdir -p $DISTRIB_DIR
  mv $ZIP_FILE $DISTRIB_DIR
}

create_distrib() {
  # Set Dynawo distrib version
  DYNAWO_VERSION=$(version) || error_exit "Error with version."
  version=$(echo $DYNAWO_VERSION | cut -f1 -d' ')

  ZIP_FILE=Dynawo_V$version.zip

  # check coding
  check_coding_files

  # Deploy Dynawo
  deploy_dynawo

  copy_sources

  if [ "`uname`" = "Darwin" ]; then
    version=$($DYNAWO_DEPLOY_DIR/bin/dynawo --version | cut -d ' ' -f 1)
    bins=("bin/dynawo" "bin/dynawo-$version" "sbin/dumpModel" "sbin/compileModelicaModel" "sbin/dumpSolver" "sbin/generate-preassembled" "sbin/generate-preassembled-$version")

    for bin in ${bins[@]}; do
      for lib_path in $(otool -l $DYNAWO_DEPLOY_DIR/$bin | grep `id -n -u` | grep path | awk '{print $2}'); do
        install_name_tool -delete_rpath $lib_path $DYNAWO_DEPLOY_DIR/$bin
      done

      install_name_tool -add_rpath @loader_path/../lib $DYNAWO_DEPLOY_DIR/$bin 2> /dev/null

      for lib_path in $(otool -l $DYNAWO_DEPLOY_DIR/$bin | grep `id -n -u` | grep name | awk '{print $2}'); do
        install_name_tool -change $lib_path @rpath/$(echo $lib_path | awk -F'/' '{print $(NF)}') $DYNAWO_DEPLOY_DIR/$bin
      done
    done

    for lib in $(find $DYNAWO_DEPLOY_DIR/lib -name "*.dylib"); do
      for lib_path in $(otool -l $lib | grep `id -n -u` | grep path | awk '{print $2}'); do
        install_name_tool -delete_rpath $lib_path $lib
      done
    done
  fi

  # create distribution
  if [ ! -d "$DYNAWO_DEPLOY_DIR" ]; then
    error_exit "$DYNAWO_DEPLOY_DIR does not exist."
  fi
  cd $DYNAWO_DEPLOY_DIR
  zip -r -y $ZIP_FILE bin/ lib/ share/ sources/
  zip -r -g -y $ZIP_FILE ddb/*.$DYNAWO_SHARED_LIBRARY_SUFFIX ddb/*.desc.xml

  # move distribution in distribution directory
  DISTRIB_DIR=$DYNAWO_HOME/distributions
  mkdir -p $DISTRIB_DIR
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
    build_3rd_party_version || error_exit
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

  do_not_unset="DYNAWO_BUILD_TYPE DYNAWO_COMPILER DYNAWO_CXX11_ENABLED DYNAWO_HOME DYNAWO_LIBRARY_TYPE DYNAWO_INSTALL_OPENMODELICA \
DYNAWO_SRC_OPENMODELICA DYNAWO_ZLIB_HOME DYNAWO_LIBARCHIVE_HOME DYNAWO_BOOST_HOME DYNAWO_GTEST_HOME DYNAWO_GMOCK_HOME"

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
  unset DYNAWO_CXX11_ENABLED
  unset DYNAWO_HOME
  unset DYNAWO_INSTALL_OPENMODELICA
  unset DYNAWO_LIBRARY_TYPE
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

if [ "`uname`" = "Linux" ]; then
  TOTAL_CPU=$(grep -c \^processor /proc/cpuinfo)
elif [ "`uname`" = "Darwin" ]; then
  TOTAL_CPU=$(sysctl hw | grep ncpu | awk '{print $(NF)}')
else
  echo "OS not supported."
  exit 1
fi

if [ -n "$BASH_VERSION" ]; then
  SCRIPT=$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$(pwd)"/"$(basename ${BASH_SOURCE[0]})")
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
    build_3rd_party || error_exit "Error while building 3rd parties"
    ;;

  build-3rd-party-version)
    build_3rd_party_version || error_exit "Error while building 3rd party version"
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

  build-dynawo-core)
    build_dynawo_core || error_exit "Failed to build Dynawo core"
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

  build-modelica-doc)
    build_modelica_doc || error_exit "Error while building Dynawo Modelica library documentation"
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

  clean-doc)
    clean_doc || error_exit "Error during the clean of Dynawo documentation"
    ;;

  clean-dynawo)
    clean_dynawo || error_exit "Error while cleaning Dynawo"
    ;;

  clean-nrt-doc)
    clean_nrt_doc || error_exit "Error during the clean of Dynawo nrt documentation"
    ;;

  clean-old-branches)
    clean_old_branches || error_exit "Error during the cleaning of old branches build/install/nrt"
    ;;

  clean-omcDynawo)
    clean_omcDynawo || error_exit "Error during the cleaning of omcDynawo"
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

  config-dynawo)
    config_dynawo || error_exit "Error while configuring Dynawo"
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
    create_distrib_with_omc || error_exit "Error while building Dynawo distribution"
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

  flat-model)
    flat_model ${ARGS} || error_exit "Failed to generate Modelica model documentation"
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

  jobs-with-curves)
    jobs_with_curves ${ARGS} || error_exit "Dynawo job with curves failed"
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

  nrt-diff)
    nrt_diff ${ARGS} || error_exit "Error during Dynawo's NRT Diff execution"
    ;;

  nrt-ref)
    nrt_ref ${ARGS} || error_exit "Error during Dynawo's NRT ref execution"
    ;;

  nrt-doc)
    open_nrt_doc || error_exit "Error during the opening of Dynawo nrt documentation"
    ;;

  reset-environment)
    reset_environment_variables_full || error_exit "Failed to reset environment variables"
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
    ;;
esac
