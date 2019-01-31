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
  exit 1
}

error() {
  echo "${1:-"Unknown Error"}" 1>&2
}

usage="Usage: `basename $0` [option] -- program to deal with Dynawo debugging environment

where [option] can be:

    =========== Building Dynawo
    build-omcDynawo                   build the openModelica compiler for dynawo (need to have OpenModelica sources)
    build-3rd-party                   build 3rd party softwares (SuiteSparse, Sundials and Adept)
    config-dynawo                     configure Dynawo's compiling environment using CMake
    build-dynawo                      build Dynawo and install preassembled models
    build-dynawo-core                 build Dynawo without preassembled models
    build-doc                         build all doxygen documentation
    build-modelica-doc                build all dynawo modelica library document
    list-tests                        print all available unittest target
    clean-tests                       remove all objects needed for unittest
    clean-tests-coverage              remove all objects needed for unittest-coverage
    build-tests ([args])              build and launch Dynawo's unittest (launch all tests if [args] is empty)
    build-tests-coverage ([args])     build/launch Dynawo's unittest and generate code coverage report (launch all tests if [args] is empty)

    launch-tests-coverage-sonar       launch ALL Dynawo's unittest and generate code coverage report (specific target for sonar toolchain)

    build-all                         call in this order build-3rd-party, config-dynawo, build-dynawo, build-doc

    distrib                           create distribution of dynawo
    distrib-omc                       create distribution with omc binary

    clean-omcDynawo                   remove the OpenModelica compiler for dynawo
    clean-3rd-party                   remove all 3rd party softwares(SuiteSparse, Sundials and Adept) objects
    clean-dynawo                      remove Dynawo's objects
    clean-all                         call clean-3rd-party, clean-dynawo
    uninstall-3rd-party               uninstall all 3rd party softwares(SuiteSparse, Sundials and Adept)
    uninstall-dynawo                  uninstall Dynawo
    uninstall-all                     call uninstall-3rd-party, uninstall-dynawo
    clean-old-branches                remove old build/install/nrt results from merge branches

    deploy                            deploy the current version of dynawo binaries/libraries/includes to be used as a release by an another project

    =========== Dynawo main launching options
    jobs ([args])                     call Dynawo's launcher with given arguments setting LD_LIBRARY_PATH correctly
    jobs-valgrind ([args])            call Dynawo's launcher with valgrind with given arguments setting LD_LIBRARY_PATH correctly
    jobs-valgrind-callgrind ([args])  call Dynawo's launcher with valgrind using callgrind tool with given arguments setting LD_LIBRARY_PATH correctly
    jobs-valgrind-dhat ([args])  call Dynawo's launcher with valgrind using dhat tool with given arguments setting LD_LIBRARY_PATH correctly
    jobs-valgrind-massif ([args])     call Dynawo's launcher with valgrind measuring the memory used by DYNAWO
    jobs-gdb ([args])                 call Dynawo's launcher with debugger with given arguments setting LD_LIBRARY_PATH correctly
    jobs-with-curves ([args])         call Dynawo's launcher with curves output visualization with given arguments setting LD_LIBRARY_PATH correctly

    =========== Dynawo utilities
    clean-build-dynawo                clean, then configure and build Dynawo
    clean-build-all                   clean, then configure and build 3rd party libraries, Dynawo
    clean-build-3rd-party             clean then build 3rd party libraries
    version-validation                clean all built items, then build them all and run non-regression tests
    dump-model ([args])               call dumpModel executable with given arguments setting LD_LIBRARY_PATH correctly
    compileModelicaOMC([args])        call compilerModelicaOMC with given arguments
    generate-preassembled             generate a preassembled model
    generate-preassembled-gdb         generate a preassembled model with debugger

    =========== Others
    compileModelicaOMCHelp            show the compilerModelica's help
    curves-visu ([args])              visualize curves output from Dynawo in an HTML file
    doc-dynawo                        open Dynawo's documentation into chosen browser
    flat-model ([args])               generate and display the (full) flat Modelica model
    nrt ([-p regex] [-n name_filter]) run (filtered) non-regression tests and open the result in chosen browser
    nrt-diff ([args])                 make a diff between two non-regression test outputs
    version                           show dynawo version
    help                              show this message"

HERE=$PWD
SCRIPT=$(readlink -f $0)
TOTAL_CPU=$(grep -c \^processor /proc/cpuinfo)

export_var_env_force() {
  var=$@
  name=${var%=*}
  value=${var##*=}

  if eval "[ \$$name ]"; then
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

export_git_branch() {
  current_dir=$PWD
  cd $DYNAWO_HOME
  branch_name=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
  if [[ "${branch_name}" == "" ]]; then
    branch_ref=$(git rev-parse --short HEAD)
    branch_name="detached_"${branch_ref}
  fi
  export_var_env BRANCH_NAME=${branch_name}
  cd $current_dir
}

# Export variables needed for Dynawo
set_environment() {
  # Force build type when building tests (or tests coverage)
  case $1 in
  build-tests-coverage)
    export_var_env_force BUILD_TYPE=TestCoverage
    export_var_env_force USE_XSD_VALIDATION=true
    ;;
  launch-tests-coverage-sonar)
    export_var_env_force BUILD_TYPE=TestCoverage
    export_var_env_force USE_XSD_VALIDATION=true
    ;;
  build-tests)
    export_var_env_force BUILD_TYPE=Tests
    export_var_env_force USE_XSD_VALIDATION=true
    ;;
  list-tests)
    export_var_env_force BUILD_TYPE=Tests
    export_var_env_force USE_XSD_VALIDATION=true
    ;;
  clean-tests)
    export_var_env_force BUILD_TYPE=Tests
    export_var_env_force USE_XSD_VALIDATION=true
    ;;
  clean-tests-coverage)
    export_var_env_force BUILD_TYPE=TestCoverage
    export_var_env_force USE_XSD_VALIDATION=true
    ;;
  *)
    ;;
  esac

  # Find build type for thid party libraries
  export_var_env_force BUILD_TYPE_THIRD_PARTY=$BUILD_TYPE
  case $BUILD_TYPE_THIRD_PARTY in
  Tests | TestCoverage)
    export_var_env_force BUILD_TYPE_THIRD_PARTY="Debug"
    ;;
  *)
    ;;
  esac

  # Compiler, to have default with gcc
  if [ -z "$COMPILER" ]; then
    export_var_env COMPILER=GCC
  fi

  # Set path to compilers
  set_compiler

  # Build_config
  export_var_env BUILD_TYPE=UNDEFINED
  export_var_env CXX11_ENABLED=UNDEFINED
  export_var_env USE_ADEPT=UNDEFINED

  export COMPILER_VERSION=$($C_COMPILER -dumpversion)

  # Dynawo
  export_var_env DYNAWO_HOME=UNDEFINED
  export_git_branch
  export_var_env DYNAWO_SRC_DIR=$DYNAWO_HOME/dynawo
  export_var_env DYNAWO_DEPLOY_DIR=$DYNAWO_HOME/deploy/$COMPILER_NAME$COMPILER_VERSION/

  jenkins_mode=$(printenv | grep "JENKINS_MODE" | wc -l)

  if [ ${jenkins_mode} -ne 0 ]; then
    export_var_env DYNAWO_BUILD_DIR=$DYNAWO_HOME/build/$COMPILER_NAME$COMPILER_VERSION/dynawo
    export_var_env DYNAWO_INSTALL_DIR=$DYNAWO_HOME/install/$COMPILER_NAME$COMPILER_VERSION/dynawo
  else
    export_var_env DYNAWO_BUILD_DIR=$DYNAWO_HOME/build/$COMPILER_NAME$COMPILER_VERSION/$BRANCH_NAME/$BUILD_TYPE/dynawo
    export_var_env DYNAWO_INSTALL_DIR=$DYNAWO_HOME/install/$COMPILER_NAME$COMPILER_VERSION/$BRANCH_NAME/$BUILD_TYPE/dynawo
  fi

  # External libs
  export_var_env_default LIBARCHIVE_HOME=UNDEFINED
  export_var_env_default BOOST_ROOT=UNDEFINED
  export_var_env_default GTEST_ROOT=UNDEFINED

  # Third parties
  export_var_env THIRD_PARTY_SRC_DIR=$DYNAWO_SRC_DIR/3rdParty
  export_var_env THIRD_PARTY_BUILD_DIR=$DYNAWO_HOME/build/3rdParty/$COMPILER_NAME$COMPILER_VERSION
  export_var_env THIRD_PARTY_INSTALL_DIR=$DYNAWO_HOME/install/3rdParty/$COMPILER_NAME$COMPILER_VERSION
  if [ "${CXX11_ENABLED,,}" = "yes" -o "${CXX11_ENABLED,,}" = "true" -o "${CXX11_ENABLED,,}" = "on" ]; then
    export_var_env_force THIRD_PARTY_BUILD_DIR_VERSION=$THIRD_PARTY_BUILD_DIR/$BUILD_TYPE_THIRD_PARTY-cxx11
    export_var_env_force THIRD_PARTY_INSTALL_DIR_VERSION=$THIRD_PARTY_INSTALL_DIR/$BUILD_TYPE_THIRD_PARTY-cxx11
  else
    export_var_env_force THIRD_PARTY_BUILD_DIR_VERSION=$THIRD_PARTY_BUILD_DIR/$BUILD_TYPE_THIRD_PARTY
    export_var_env_force THIRD_PARTY_INSTALL_DIR_VERSION=$THIRD_PARTY_INSTALL_DIR/$BUILD_TYPE_THIRD_PARTY
  fi

  export_var_env_force SUITESPARSE_BUILD_DIR=$THIRD_PARTY_BUILD_DIR_VERSION/suitesparse
  export_var_env_force NICSLU_BUILD_DIR=$THIRD_PARTY_BUILD_DIR_VERSION/nicslu
  export_var_env_force SUNDIALS_BUILD_DIR=$THIRD_PARTY_BUILD_DIR_VERSION/sundials
  export_var_env_force ADEPT_BUILD_DIR=$THIRD_PARTY_BUILD_DIR_VERSION/adept
  export_var_env_force XERCESC_BUILD_DIR=$THIRD_PARTY_BUILD_DIR_VERSION/xerces-c

  export_var_env_force SUITESPARSE_INSTALL_DIR=$THIRD_PARTY_INSTALL_DIR_VERSION/suitesparse
  export_var_env_force NICSLU_INSTALL_DIR=$THIRD_PARTY_INSTALL_DIR_VERSION/nicslu
  export_var_env_force SUNDIALS_INSTALL_DIR=$THIRD_PARTY_INSTALL_DIR_VERSION/sundials
  export_var_env_force ADEPT_INSTALL_DIR=$THIRD_PARTY_INSTALL_DIR_VERSION/adept
  export_var_env_force XERCESC_INSTALL_DIR=$THIRD_PARTY_INSTALL_DIR_VERSION/xerces-c

  export_var_env_force LIBIIDM_HOME=$THIRD_PARTY_INSTALL_DIR_VERSION/libiidm
  export_var_env_force LIBIIDM_INSTALL_DIR=$LIBIIDM_HOME
  export_var_env_force LIBIIDM_BUILD_DIR=$THIRD_PARTY_BUILD_DIR_VERSION/libiidm

  export_var_env_force LIBZIP_HOME=$THIRD_PARTY_INSTALL_DIR_VERSION/libzip
  export_var_env_force LIBZIP_INSTALL_DIR=$LIBZIP_HOME
  export_var_env_force LIBZIP_BUILD_DIR=$THIRD_PARTY_BUILD_DIR_VERSION/libzip

  export_var_env_force LIBXML_HOME=$THIRD_PARTY_INSTALL_DIR_VERSION/libxml
  export_var_env_force LIBXML_INSTALL_DIR=$LIBXML_HOME
  export_var_env_force LIBXML_BUILD_DIR=$THIRD_PARTY_BUILD_DIR_VERSION/libxml

  # Miscellaneous
  export_var_env USE_XSD_VALIDATION=true
  export_var_env DYNAWO_LOCALE=en_GB # or fr_FR
  export_var_env BROWSER=firefox
  export_var_env TEXT_EDITOR=vi
  export_var_env NRT_DIR=$DYNAWO_HOME/nrt
  export_var_env RESULTS_SHOW=true
  export_var_env CURVES_TO_HTML_DIR=$DYNAWO_HOME/util/curvesToHtml
  export_var_env DYNAWO_MODEL_DOCUMENTATION_DIR=$DYNAWO_HOME/util/modelDocumentation
  export_var_env DYNAWO_SCRIPTS_DIR=$DYNAWO_INSTALL_DIR/sbin/

  # Only used until now by nrt
  export_var_env NB_PROCESSORS_USED=1
  if [ $NB_PROCESSORS_USED -gt $TOTAL_CPU ]; then
    error_exit "PROCESSORS_USED ($NB_PROCESSORS_USED) is higher than the number of cpu of the system ($TOTAL_CPU)"
  fi

  # OpenModelica config
  export_var_env OPENMODELICA_VERSION=1_9_4
  export_var_env SRC_OPENMODELICA=UNDEFINED
  export_var_env INSTALL_OPENMODELICA=UNDEFINED

  # Export library path, path and other standard environment variables
  set_standardEnvironmentVariables

  set_commit_hook

  set_cpplint
}

set_standardEnvironmentVariables() {
  export LD_LIBRARY_PATH=$NICSLU_INSTALL_DIR/lib:$SUITESPARSE_INSTALL_DIR/lib:$SUNDIALS_INSTALL_DIR/lib:$LIBZIP_HOME/lib:$LIBXML_HOME/lib:$LIBIIDM_HOME/lib:$DYNAWO_INSTALL_DIR/lib:$ADEPT_INSTALL_DIR/lib:$XERCESC_INSTALL_DIR/lib:$LD_LIBRARY_PATH

  if [ $LIBARCHIVE_HOME_DEFAULT != true ]; then
    export LD_LIBRARY_PATH=$LIBARCHIVE_HOME/lib:$LD_LIBRARY_PATH
  fi

  if [ $BOOST_ROOT_DEFAULT != true ]; then
    export LD_LIBRARY_PATH=$BOOST_ROOT/lib:$LD_LIBRARY_PATH
  fi

  if [ ! -x "$(command -v getconf)" ]; then
    error_exit "You need to install getconf command line utility."
  fi

  if [ $GTEST_ROOT_DEFAULT != true ]; then
    if (( "$(getconf LONG_BIT)" == 64 )); then
      export LD_LIBRARY_PATH=$GTEST_ROOT/lib64:$LD_LIBRARY_PATH
    elif (( "$(getconf LONG_BIT)" == 32 )); then
      export LD_LIBRARY_PATH=$GTEST_ROOT/lib:$LD_LIBRARY_PATH
    else
      error_exit "Not enable to find which integer size your CPU architecture have."
    fi
  fi

  export PATH=$INSTALL_OPENMODELICA/bin:$PATH
  export PYTHONPATH=$PYTHONPATH:$SCRIPTS_DIR
  export DYNAWO_RESOURCES_DIR=$DYNAWO_INSTALL_DIR/share:$DYNAWO_INSTALL_DIR/share/xsd
}

set_compiler() {
  if [ "$COMPILER" = "GCC" ]; then
    export_var_env_force COMPILER_NAME=$(echo $COMPILER | tr "[A-Z]" "[a-z]")
  elif [ "$COMPILER" = "CLANG" ]; then
    export_var_env_force COMPILER_NAME=$(echo $COMPILER | tr "[A-Z]" "[a-z]")
  else
    error_exit "COMPILER environment variable needs to be GCC or CLANG."
  fi
  export_var_env_force C_COMPILER=$(command -v $COMPILER_NAME)
  export_var_env_force CXX_COMPILER=$(command -v ${COMPILER_NAME%cc}++) # Trick to remove cc from gcc and leave clang alone, because we want fo find g++ and clang++
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
    if [ -d ".git" ]; then
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
fi"
  if [ -f "$DYNAWO_HOME/.git/hooks/pre-commit" ]; then
    current_file=$(cat $DYNAWO_HOME/.git/hooks/pre-commit)
    if [ "$hook_file_master" != "$current_file" ]; then
      echo "$hook_file_master" > $DYNAWO_HOME/.git/hooks/pre-commit
    fi
    if [ ! -x "$DYNAWO_HOME/.git/hooks/pre-commit" ]; then
      chmod +x $DYNAWO_HOME/.git/hooks/pre-commit
    fi
  else
    if [ -d ".git" ]; then
      echo "$hook_file_master" > $DYNAWO_HOME/.git/hooks/pre-commit
      chmod +x $DYNAWO_HOME/.git/hooks/pre-commit
    fi
  fi

  if [ "$(git config --get core.commentchar)" == "#" ]; then
    git config core.commentchar % || error_exit "You need to change git config commentchar from # to %."
  fi
}

set_cpplint() {
  export_var_env CPPLINT_DOWNLOAD_URL=https://github.com/cpplint/cpplint/archive
  CPPLINT_VERSION=1.3.0
  CPPLINT_ARCHIVE=$CPPLINT_VERSION.tar.gz

  CPPLINT_FILE=cpplint.py
  CPPLINT_DIR=$DYNAWO_HOME/cpplint

  if [ ! -f "$CPPLINT_DIR/$CPPLINT_FILE" ]; then
    if [ -x "$(command -v wget)" ]; then
      wget --timeout 10 --tries 3 ${CPPLINT_DOWNLOAD_URL}/${CPPLINT_ARCHIVE} -P "$CPPLINT_DIR" || error_exit "Error while downloading cpplint."
    elif [ -x "$(command -v curl)" ]; then
      curl -L --connect-timeout 10 --retry 2 ${CPPLINT_DOWNLOAD_URL}/${CPPLINT_ARCHIVE} --output "$CPPLINT_DIR/$CPPLINT_ARCHIVE" || error_exit "Error while downloading cpplint."
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

display_environmentVariables() {
  set -x
  set_standardEnvironmentVariables
  set +x
}

# Build openModelica compiler
build_omcDynawo() {
  export_var_env MODELICA_LIB=3.2.2
  cd $DYNAWO_SRC_DIR/3rdParty/omcUpdate_$OPENMODELICA_VERSION
  bash checkoutOpenModelica.sh --openmodelica-dir=$SRC_OPENMODELICA --openmodelica-version=$OPENMODELICA_VERSION --modelica-version=$MODELICA_LIB || error_exit "OpenModelica source code is not well checked-out."
  bash cleanBeforeLaunch.sh --openmodelica-dir=$SRC_OPENMODELICA
  bash omcUpdateDynawo.sh --openmodelica-dir=$SRC_OPENMODELICA --openmodelica-install=$INSTALL_OPENMODELICA --nbProcessors=$NB_PROCESSORS_USED
}

# Clean openModelica compiler
clean_omcDynawo() {
  cd $DYNAWO_SRC_DIR/3rdParty/omcUpdate_$OPENMODELICA_VERSION
  bash cleanBeforeLaunch.sh --openmodelica-dir=$SRC_OPENMODELICA --openmodelica-install=$INSTALL_OPENMODELICA
}

# Build third parties
build_3rd_party() {
  # Save BUILD_TYPE and CXX11_ENABLED as I force it to change to build all 3rd party combination
  INITIAL_BUILD_TYPE=$BUILD_TYPE
  INITIAL_CXX11_ENABLED=$CXX11_ENABLED

  export_var_env_force BUILD_TYPE=Release
  export_var_env_force CXX11_ENABLED=NO
  set_environment "No-Mode"
  build_third_party_version || error_exit

  export_var_env_force CXX11_ENABLED=YES
  set_environment "No-Mode"
  build_third_party_version || error_exit

  export_var_env_force BUILD_TYPE=Debug
  export_var_env_force CXX11_ENABLED=NO
  set_environment "No-Mode"
  build_third_party_version || error_exit

  export_var_env_force CXX11_ENABLED=YES
  set_environment "No-Mode"
  build_third_party_version || error_exit

  # Come back to initial environement
  export_var_env_force BUILD_TYPE=$INITIAL_BUILD_TYPE
  export_var_env_force CXX11_ENABLED=$INITIAL_CXX11_ENABLED
  set_environment $MODE

  NICSLU_ARCHIVE=_nicslu301.zip
  if [ ! -f "$DYNAWO_SRC_DIR/3rdParty/nicslu/$NICSLU_ARCHIVE" ]; then
    echo ""
    echo "Nicslu was not installed. You can download it from http://nicslu.weebly.com/ and copy/paste the zip obtained in $DYNAWO_SRC_DIR/3rdParty/nicslu."
    echo ""
  fi
}

# Build a speficic verison of third party libraries
build_third_party_version() {
  if [ ! -d "$THIRD_PARTY_BUILD_DIR_VERSION" ]; then
    cd $DYNAWO_SRC_DIR/3rdParty
    bash toolchain.sh
    RETURN_CODE=$?
    return ${RETURN_CODE}
  fi
}

# clean third parties
clean_3rd_party() {
  if [ -d "$THIRD_PARTY_BUILD_DIR" ]; then
    rm -rf $THIRD_PARTY_BUILD_DIR
  fi
}

# uninstall third parties
uninstall_3rd_party() {
  if [ -d "$THIRD_PARTY_INSTALL_DIR" ]; then
    rm -rf $THIRD_PARTY_INSTALL_DIR
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
  cmake -DCMAKE_C_COMPILER:PATH=$C_COMPILER -DCMAKE_CXX_COMPILER:PATH=$CXX_COMPILER -DCMAKE_BUILD_TYPE:STRING=$BUILD_TYPE -DDYNAWO_HOME:PATH=$DYNAWO_HOME -DCMAKE_INSTALL_PREFIX:PATH=$DYNAWO_INSTALL_DIR $DYNAWO_SRC_DIR -DUSE_ADEPT:BOOL=$USE_ADEPT -DINSTALL_OPENMODELICA:PATH=$INSTALL_OPENMODELICA -DCXX11_ENABLED:BOOL=$CXX11_ENABLED -DBOOST_ROOT_DEFAULT:STRING=$BOOST_ROOT_DEFAULT -DOPENMODELICA_VERSION:STRING=$OPENMODELICA_VERSION -G "Unix Makefiles" "-DCMAKE_PREFIX_PATH=$LIBXML_HOME;$LIBIIDM_HOME"
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

# show the compiler Modelica help
compileModelicaOMCHelp() {
  $DYNAWO_INSTALL_DIR/bin/launcher --compile --help
}

# Compile a modelica model
compileModelicaOMC() {
  $DYNAWO_INSTALL_DIR/bin/launcher --compile $@
}

# Compile Dynawo core (without models)
build_dynawo_core() {
  cd $DYNAWO_BUILD_DIR
  make -j$NB_PROCESSORS_USED && make -j$NB_PROCESSORS_USED install && make -j$NB_PROCESSORS_USED models-cpp
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

# Compile Dynawo (core + models)
build_dynawo() {
  cd $DYNAWO_BUILD_DIR
  build_dynawo_core || error_exit
  make -j$NB_PROCESSORS_USED models || error_exit
  make -j$NB_PROCESSORS_USED solvers
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

# Compile Dynawo and its dependencies
build_all() {
  if [ ! -d "$THIRD_PARTY_BUILD_DIR" ]; then
    build_3rd_party || error_exit
  fi
  config_dynawo || error_exit
  build_dynawo || error_exit
  build_test_doc || error_exit
}

build_tests() {
  if [ ! -d "$THIRD_PARTY_BUILD_DIR" ]; then
    build_3rd_party || error_exit
  fi
  if [ ! -d "$DYNAWO_BUILD_DIR" ]; then
    config_dynawo || error_exit
  fi
  ## for unit test, no need to generate modelica models
  build_dynawo_core || error_exit

  tests=$@
  if [ -z "$tests" ]; then
    make tests
  else
    make ${tests}
  fi
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

list_tests() {
  echo "===================================="
  echo " List of available unittests target"
  echo "===================================="
  config_dynawo > /dev/null 2>&1 || error_exit
  make help | grep -Ei 'tests' | grep -Eiv 'pre-tests'
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

build_tests_coverage() {
  if [ ! -d "$THIRD_PARTY_BUILD_DIR" ]; then
    build_3rd_party || error_exit
  fi
  if [ ! -d "$DYNAWO_BUILD_DIR" ]; then
    config_dynawo || error_exit
  fi
  ## for unit test, no need to generate modelica models
  build_dynawo_core || error_exit

  tests=$@

  make reset-coverage || error_exit
  if [ -z "$tests" ]; then
    make tests-coverage || error_exit
  else
    for test in ${tests}; do
      make ${test}-coverage || error_exit
    done
  fi
  make export-coverage
  RETURN_CODE=$?
  if [ ${RETURN_CODE} -ne 0 ]; then
    exit ${RETURN_CODE}
  fi
  if [ "$RESULTS_SHOW" = true ] ; then
    $BROWSER $DYNAWO_BUILD_DIR/coverage/index.html
  fi
}

launch_tests_coverage_sonar() {
  if [ ! -d "$THIRD_PARTY_BUILD_DIR" ]; then
    build_3rd_party || error_exit
  fi
  if [ ! -d "$DYNAWO_BUILD_DIR" ]; then
    config_dynawo || error_exit
  fi
  ## for unit test, no need to generate modelica models
  build_dynawo_core || error_exit

  make reset-coverage-sonar || error_exit
  make tests-coverage-sonar || error_exit
  make export-coverage-sonar || error_exit
  if [ "$RESULTS_SHOW" = true ] ; then
    $BROWSER $DYNAWO_BUILD_DIR/coverage-sonar/index.html
  fi
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

# Compile Dynawo doc
build_test_doc() {
  build_doc || error_exit
  test_doxygen_doc || error_exit
}

build_doc() {
  cd $DYNAWO_BUILD_DIR
  mkdir -p $DYNAWO_INSTALL_DIR/doxygen/
  make -j $NB_PROCESSORS_USED doc
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

test_doxygen_doc() {
  if [ -f "$DYNAWO_INSTALL_DIR/doxygen/warnings.txt"  ] ; then
    nb_warnings=$(wc -l $DYNAWO_INSTALL_DIR/doxygen/warnings.txt | cut -f1 -d' ')
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
echo #    python $MODEL_DOCUMENTATION_DIR/latex/model_documentation.py --model_file=$MODEL_DOCUMENTATION_DIR/latex/models.txt --outputDir=$DYNAWO_HOME/documents/ModelicaDocumentation/resources || error_exit "Error during LaTeX file generation"
    #Do it twice to generate cross references and Contents section
#    pdflatex -halt-on-error -output-directory $DYNAWO_HOME/documents/ModelicaDocumentation $DYNAWO_HOME/documents/ModelicaDocumentation/resources/model_documentation.tex
#    pdflatex -halt-on-error -output-directory $DYNAWO_HOME/documents/ModelicaDocumentation $DYNAWO_HOME/documents/ModelicaDocumentation/resources/model_documentation.tex
#    test_modelica_doc
}

test_modelica_doc() {
  if [ -f "$DYNAWO_HOME/documents/ModelicaDocumentation/resources/model_documentation.tex" ] ; then
    nb_diff=$(diff $DYNAWO_HOME/documents/ModelicaDocumentation/resources/model_documentation.tex $MODEL_DOCUMENTATION_DIR/latex/ref.tex | wc -l)
    if [ ${nb_diff} -ne 0 ]; then
      error_exit "The generated LaTeX file does not correspond to the reference"
    fi
  else
    error_exit "Dynawo Modelica library LaTeX file not found"
  fi
}

jobs() {
  $DYNAWO_INSTALL_DIR/bin/launcher $@
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

generate_preassembled() {
  $DYNAWO_INSTALL_DIR/bin/launcher --dydlib $*
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

generate_preassembled_gdb() {
  $DYNAWO_INSTALL_DIR/bin/launcher --dydlib-gdb $*
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

install_jquery() {
  export_var_env JQUERY_DOWNLOAD_URL=https://github.com/jquery/jquery/archive
  JQUERY_VERSION=1.3.2
  JQUERY_ARCHIVE=$JQUERY_VERSION.tar.gz

  export_var_env FLOT_DOWNLOAD_URL=https://github.com/flot/flot/archive
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
        wget --timeout 10 --tries 3 ${JQUERY_DOWNLOAD_URL}/${JQUERY_ARCHIVE} -P $JQUERY_BUILD_DIR || error_exit "Error while downloading Jquery."
      elif [ -x "$(command -v curl)" ]; then
        curl -L --connect-timeout 10 --retry 2 ${JQUERY_DOWNLOAD_URL}/${JQUERY_ARCHIVE} -o $JQUERY_BUILD_DIR/${JQUERY_ARCHIVE} || error_exit "Error while downloading Jquery."
      else
        error_exit "You need to install either wget or curl."
      fi
    fi
    if [ -f "$JQUERY_BUILD_DIR/${JQUERY_ARCHIVE}" ]; then
      if [ ! -d "$JQUERY_BUILD_DIR/jquery-$JQUERY_VERSION" ]; then
        tar xzf $JQUERY_BUILD_DIR/${JQUERY_ARCHIVE} -C $JQUERY_BUILD_DIR
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
          wget --timeout 10 --tries 3 ${FLOT_DOWNLOAD_URL}/${FLOT_ARCHIVE} -P $JQUERY_BUILD_DIR || error_exit "Error while downloading Flot."
        elif [ -x "$(command -v curl)" ]; then
          curl --connect-timeout 10 --retry 2 ${FLOT_DOWNLOAD_URL}/${FLOT_ARCHIVE} --output $JQUERY_BUILD_DIR/${FLOT_ARCHIVE} || error_exit "Error while downloading Flot."
        else
          error_exit "You need to install either wget or curl."
        fi
      fi
      if [ -f "$JQUERY_BUILD_DIR/${FLOT_ARCHIVE}" ]; then
        if [ ! -d "flot-$FLOT_VERSION" ]; then
          tar xzf $JQUERY_BUILD_DIR/${FLOT_ARCHIVE} -C $JQUERY_BUILD_DIR
        fi
        if [ -d "$JQUERY_BUILD_DIR/flot-$FLOT_VERSION" ]; then
          if expr match "$file" "arrow-.*" >/dev/null; then
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
  jobs $@ || error "Dynawo job failed."
  echo "Generating curves visualization pages"
  curves_visu $@ || error_exit "Error during curves visualisation page generation"
  echo "End of generating curves visualization pages"
}

curves_visu() {
  python $CURVES_TO_HTML_DIR/curvesToHtml.py --jobsFile=$(readlink -f $@) --withoutOffset --htmlBrowser=$BROWSER || return 1
}

dump_model() {
  $DYNAWO_INSTALL_DIR/bin/launcher --dump-model $@
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

doc_dynawo() {
  if [ ! -f "$DYNAWO_INSTALL_DIR/doxygen/html/index.html" ]; then
    echo "Doxygen documentation not yet generated"
    echo "Generating ..."
    build_test_doc
    RETURN_CODE=$?
    if [ ${RETURN_CODE} -ne 0 ]; then
      exit ${RETURN_CODE}
    fi
    echo "... end of doc generation"
  fi
  $BROWSER $DYNAWO_INSTALL_DIR/doxygen/html/index.html
}

flat_model() {
echo #  python $MODEL_DOCUMENTATION_DIR/model_documentation.py --model=$@ --outputDir=/tmp/dynawo/doxygen --outputFormat=Modelica
}

version() {
  $DYNAWO_INSTALL_DIR/bin/launcher --version
  RETURN_CODE=$?
  return ${RETURN_CODE}
}

nrt() {
  export_var_env NRT_DIFF_DIR=$DYNAWO_HOME/util/nrt_diff
  export_var_env ENV_DYNAWO=$SCRIPT
  python -u $NRT_DIR/nrt.py $@
  FAILED_CASES_NUM=$?

  jenkins_mode=$(printenv | grep "JENKINS_MODE" | wc -l)

  if [ ${jenkins_mode} -ne 0 ]; then
    if [ ! -f "$NRT_DIR/output/report.html" ]; then
      error_exit "No report was generated by the non regression test script"
    fi
  else
    if [ ! -f "$NRT_DIR/output/$BRANCH_NAME/report.html" ]; then
      error_exit "No report was generated by the non regression test script"
    fi
    if [ "$RESULTS_SHOW" = true ] ; then
      $BROWSER $NRT_DIR/output/$BRANCH_NAME/report.html &
    fi
  fi

  if [ ${FAILED_CASES_NUM} -ne 0 ]; then
    error_exit "${FAILED_CASES_NUM} non regression tests failed"
  fi
}

nrt_diff() {
  NRT_DIFF_DIR=$DYNAWO_HOME/util/nrt_diff
  python $NRT_DIFF_DIR/nrtDiff.py $1 $2
}

checkCodingFiles() {
  # html escape .dic files for dictionary
  for dicfile in $(find $DYNAWO_INSTALL_DIR -iname '*.dic')
  do
    iconv -t iso8859-1 -f utf-8 -o $dicfile $dicfile
  done
}

findLibSystemPath() {
  if [ -z "$1" ]; then
    error_exit "You need to give the name of the library to search."
  fi
  ldd $DYNAWO_INSTALL_DIR/bin/dynawo | grep "$1" | cut -d '>' -f 2 | awk '{print $1}' | sed "s/lib$1.*//g"  | uniq
}

findIncludeSystemPath() {
  if [ -z "$1" ]; then
    error_exit "You need to give the name of the library to search."
  fi
  cat $DYNAWO_BUILD_DIR/CMakeCache.txt | grep "$1":PATH | cut -d '=' -f 2
}

deploy_dynawo() {
  DYNAWO_VERSION=$(version)
  version=$(echo $DYNAWO_VERSION | cut -f1 -d' ')
  rm -rf $DYNAWO_DEPLOY_DIR

  # check coding
  checkCodingFiles

  current_dir=$PWD
  mkdir -p $DYNAWO_DEPLOY_DIR
  cd $DYNAWO_DEPLOY_DIR
  mkdir -p 3rdParty/sundials/lib
  mkdir -p 3rdParty/adept/lib
  mkdir -p 3rdParty/suitesparse/lib
  mkdir -p 3rdParty/nicslu/lib
  mkdir -p extraLibs/BOOST/lib/
  mkdir -p extraLibs/XERCESC/lib/
  mkdir -p extraLibs/LIBARCHIVE/lib/
  mkdir -p extraLibs/LIBIIDM/lib/
  mkdir -p extraLibs/LIBZIP/lib
  mkdir -p extraLibs/LIBXML/lib
  cp -P $SUNDIALS_INSTALL_DIR/lib/*.* 3rdParty/sundials/lib/
  cp -P $ADEPT_INSTALL_DIR/lib/*.* 3rdParty/adept/lib/
  cp -P $SUITESPARSE_INSTALL_DIR/lib/*.* 3rdParty/suitesparse/lib/
  if [ -d "$NICSLU_INSTALL_DIR/lib" ]; then
    if [ ! -z "$(ls -A $NICSLU_INSTALL_DIR/lib)" ]; then
      cp -P $NICSLU_INSTALL_DIR/lib/*.* 3rdParty/nicslu/lib/
    fi
  fi
  cp -P $LIBZIP_HOME/lib/*.* extraLibs/LIBZIP/lib/
  cp -P $LIBXML_HOME/lib/*.* extraLibs/LIBXML/lib/
  cp -P $LIBIIDM_HOME/lib/*.* extraLibs/LIBIIDM/lib/

  mkdir -p 3rdParty/sundials/include
  mkdir -p 3rdParty/adept/include
  mkdir -p 3rdParty/suitesparse/include
  mkdir -p 3rdParty/nicslu/include
  mkdir -p extraLibs/BOOST/include
  mkdir -p extraLibs/LIBARCHIVE/include
  mkdir -p extraLibs/LIBIIDM/include
  mkdir -p extraLibs/LIBZIP/include
  mkdir -p extraLibs/LIBXML/include
  cp -R -P $SUNDIALS_INSTALL_DIR/include/* 3rdParty/sundials/include/
  cp -P $ADEPT_INSTALL_DIR/include/*.* 3rdParty/adept/include/
  cp -P $SUITESPARSE_INSTALL_DIR/include/*.* 3rdParty/suitesparse/include/
  if [ -d "$NICSLU_INSTALL_DIR/include" ]; then
    if [ ! -z "$(ls -A $NICSLU_INSTALL_DIR/include)" ]; then
      cp -P $NICSLU_INSTALL_DIR/include/*.* 3rdParty/nicslu/include/
    fi
  fi
  cp -R -P $LIBZIP_HOME/include/libzip extraLibs/LIBZIP/include/
  cp -R -P $LIBXML_HOME/include/xml extraLibs/LIBXML/include/
  cp -R -P $LIBIIDM_HOME/include/IIDM extraLibs/LIBIIDM/include/

  mkdir -p extraLibs/LIBIIDM/share
  mkdir -p extraLibs/LIBXML/share
  cp -R -P $LIBXML_HOME/share/cmake extraLibs/LIBXML/share/
  cp -R -P $LIBIIDM_HOME/share/cmake extraLibs/LIBIIDM/share/
  cp -R -P $LIBIIDM_HOME/share/iidm extraLibs/LIBIIDM/share/

  mkdir -p 3rdParty/openmodelica/bin/
  mkdir -p 3rdParty/openmodelica/include/
  mkdir -p 3rdParty/openmodelica/lib/omc/
  cp -P $INSTALL_OPENMODELICA/bin/omc* 3rdParty/openmodelica/bin
  cp -P -R $INSTALL_OPENMODELICA/include/omc/ 3rdParty/openmodelica/include/
  cp -P -R $INSTALL_OPENMODELICA/lib/* 3rdParty/openmodelica/lib/
  cp -P $INSTALL_OPENMODELICA/lib/omc/*.mo 3rdParty/openmodelica/lib/omc/
  cp -P -R $INSTALL_OPENMODELICA/lib/omlibrary 3rdParty/openmodelica/lib/

  ##############
  #    BOOST   #
  ##############
  # for dynawo
  if [ $BOOST_ROOT_DEFAULT != true ]; then
    cp -P $BOOST_ROOT/lib/libboost_*.so* extraLibs/BOOST/lib/
    cp -P -R $BOOST_ROOT/include/boost/ extraLibs/BOOST/include/
  else
    boost_system_folder=$(findLibSystemPath boost)
    cp -P ${boost_system_folder}libboost_*.so* extraLibs/BOOST/lib/
    boost_system_folder_include=$(findIncludeSystemPath Boost_INCLUDE_DIR)
    cp -P -R $boost_system_folder_include/boost extraLibs/BOOST/include/
  fi

  # XERCESC
  cp -P $XERCESC_INSTALL_DIR/lib/libxerces-c*.so* extraLibs/XERCESC/lib/

  # LIBARCHIVE
  if [ $LIBARCHIVE_HOME_DEFAULT != true ]; then
    cp -P $LIBARCHIVE_HOME/lib/libarchive*.so* extraLibs/LIBARCHIVE/lib/
    cp $LIBARCHIVE_HOME/include/archive_entry.h extraLibs/LIBARCHIVE/include/
    cp $LIBARCHIVE_HOME/include/archive.h extraLibs/LIBARCHIVE/include/
  else
    libarchive_system_folder=$(findLibSystemPath archive)
    cp -P ${libarchive_system_folder}libarchive*.so* extraLibs/LIBARCHIVE/lib/
    libarchive_system_folder_include=$(findIncludeSystemPath LibArchive_INCLUDE_DIR)
    cp $libarchive_system_folder_include/archive_entry.h extraLibs/LIBARCHIVE/include/
    cp $libarchive_system_folder_include/archive.h extraLibs/LIBARCHIVE/include/
  fi

  # DYNAWO
  cp -r $DYNAWO_INSTALL_DIR/bin/ $DYNAWO_INSTALL_DIR/lib/ $DYNAWO_INSTALL_DIR/include/ $DYNAWO_INSTALL_DIR/share/ .
  mkdir -p ddb/
  cp -r $DYNAWO_INSTALL_DIR/ddb .

  mkdir -p sbin
  cp $DYNAWO_INSTALL_DIR/sbin/*.py sbin/
  cp $DYNAWO_INSTALL_DIR/sbin/cleanCompilerModelicaOMC sbin/
  cp $DYNAWO_INSTALL_DIR/sbin/compileLibModelicaOMC sbin/
  cp $DYNAWO_INSTALL_DIR/sbin/compilerModelicaOMC sbin/
  cp $DYNAWO_INSTALL_DIR/sbin/dumpModel sbin/
  cp $DYNAWO_INSTALL_DIR/sbin/dydLibGenerator sbin/
  cp $DYNAWO_INSTALL_DIR/sbin/dumpSolver sbin/
  cp $DYNAWO_INSTALL_DIR/sbin/dydLibGenerator-${version} bin/
    
  if [ -d "$DYNAWO_INSTALL_DIR/doxygen" ]; then
    mkdir -p doxygen
    cp -r $DYNAWO_INSTALL_DIR/doxygen/html doxygen/.
    cp $DYNAWO_INSTALL_DIR/doxygen/Dynawo.tag doxygen/.
  fi
    
  cp -r $CURVES_TO_HTML_DIR sbin/.
  mkdir -p sbin/nrt
  cp -r $DYNAWO_HOME/util/nrt_diff sbin/nrt/.
  cp -r $NRT_DIR/nrt.py sbin/nrt/.
  cp -r $NRT_DIR/resources sbin/nrt/.

  cd $current_dir
}

create_distrib_with_omc(){
   # Set Dynawo distrib version
  DYNAWO_VERSION=$(version)
  version=$(echo $DYNAWO_VERSION | cut -f1 -d' ')

  ZIP_FILE=Dynawo_omc_V$version.zip

  # check coding
  checkCodingFiles

  # Deploy Dynawo
  deploy_dynawo

  if [ ! -x "$(command -v zip)" ]; then
    error_exit "You need to install zip command line utility."
  fi

  # create distribution
  cd $DYNAWO_DEPLOY_DIR
  zip -r -y $ZIP_FILE bin/ lib/ share/

  # need with omc binary
  zip -r -g -y $ZIP_FILE ddb/ include/ sbin/

  zip -r -g -y $ZIP_FILE 3rdParty/*/lib -x \*.a
  zip -r -g -y $ZIP_FILE 3rdParty/adept/include -x \*.a
  zip -r -g -y $ZIP_FILE 3rdParty/openmodelica/bin -x \*.a
  zip -r -g -y $ZIP_FILE 3rdParty/openmodelica/include -x \*.a
  zip -r -g -y $ZIP_FILE extraLibs/*/lib -x \*.a
  zip -r -g -y $ZIP_FILE extraLibs/BOOST/include -x \*.a

  # move distribution in distribution directory
  DISTRIB_DIR=$DYNAWO_HOME/distributions
  mkdir -p $DISTRIB_DIR
  mv $ZIP_FILE $DISTRIB_DIR
}

create_distrib(){
  # Set Dynawo distrib version
  DYNAWO_VERSION=$(version)
  version=$(echo $DYNAWO_VERSION | cut -f1 -d' ')

  ZIP_FILE=Dynawo_V$version.zip

  # check coding
  checkCodingFiles

  # Deploy Dynawo
  deploy_dynawo

  # create distribution
  cd $DYNAWO_DEPLOY_DIR
  zip -r -y $ZIP_FILE bin/ lib/ share/
  zip -r -g -y $ZIP_FILE ddb/*.so ddb/*.desc.xml

  # Add lib to zip file
  zip -r -g -y $ZIP_FILE 3rdParty/adept/lib -x \*.a
  zip -r -g -y $ZIP_FILE 3rdParty/suitesparse/lib -x \*.a
  zip -r -g -y $ZIP_FILE 3rdParty/sundials/lib -x \*.a
  if [ -d "3rdParty/nicslu/lib" ]; then
    zip -r -g -y $ZIP_FILE 3rdParty/nicslu/lib -x \*.a
  fi
  zip -r -g -y $ZIP_FILE extraLibs/LIBZIP/lib -x \*.a
  zip -r -g -y $ZIP_FILE extraLibs/LIBXML/lib -x \*.a
  zip -r -g -y $ZIP_FILE extraLibs/LIBIIDM/lib -x \*.a
  zip -r -g -y $ZIP_FILE extraLibs/LIBARCHIVE/lib -x \*.a
  zip -r -g -y $ZIP_FILE extraLibs/XERCESC/lib -x \*.a
  zip -r -g -y $ZIP_FILE extraLibs/BOOST/lib -x \*.a

  # move distribution in distribution directory
  DISTRIB_DIR=$DYNAWO_HOME/distributions
  mkdir -p $DISTRIB_DIR
  mv $ZIP_FILE $DISTRIB_DIR
}

## force build_type for specific cases
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
  distrib)
    create_distrib || error_exit "Error while building Dynawo distribution"
    ;;

  distrib-omc)
    create_distrib_with_omc || error_exit "Error while building Dynawo distribution"
    ;;

  clean-omcDynawo)
    clean_omcDynawo
    ;;

  build-omcDynawo)
    build_omcDynawo || error_exit "Failed to build OMC for Dynawo"
    ;;

  clean-3rd-party)
    clean_3rd_party || error_exit "Error while cleaning 3rd parties"
    ;;

  clean-dynawo)
    clean_dynawo || error_exit "Error while cleaning Dynawo"
    ;;

  clean-all)
    clean_all || error_exit
    ;;

  uninstall-3rd-party)
    uninstall_3rd_party || error_exit "Error while uninstalling 3rd parties"
    ;;

  uninstall-dynawo)
    uninstall_dynawo || error_exit "Error while uninstalling Dynawo"
    ;;

  uninstall-all)
    uninstall_all || error_exit "Error while uninstalling all"
    ;;

  build-3rd-party)
    build_3rd_party || error_exit "Error while building 3rd parties"
    ;;

  compileModelicaOMCHelp)
    compileModelicaOMCHelp || error_exit
    ;;

  compileModelicaOMC)
    compileModelicaOMC ${ARGS} || error_exit "Failed to compile Modelica model"
    ;;

  config-dynawo)
    config_dynawo || error_exit "Error while configuring Dynawo"
    ;;

  build-dynawo)
    config_dynawo ||  error_exit "Error while configuring Dynawo"
    build_dynawo || error_exit "Error while building Dynawo"
    ;;

  build-dynawo-core)
    build_dynawo_core || error_exit "Failed to build Dynawo core"
    ;;

  build-doc)
    build_test_doc || error_exit "Error while building doxygen documenation"
    ;;

  build-modelica-doc)
    build_modelica_doc || error_exit "Error while building Dynawo Modelica library documentation"
    ;;

  build-all)
    build_all || error_exit
    ;;

  build-tests)
    build_tests ${ARGS}|| error_exit
    ;;

  build-tests-coverage)
    build_tests_coverage ${ARGS}|| error_exit
    ;;

  launch-tests-coverage-sonar)
    launch_tests_coverage_sonar || error_exit
    ;;

  list-tests)
    list_tests || error_exit
    ;;

  clean-tests)
    clean_tests || error_exit
    ;;

  clean-tests-coverage)
    clean_tests_coverage || error_exit
    ;;

  clean-build-all)
    clean_build_all || error_exit
    ;;

  clean-build-dynawo)
    clean_build_dynawo || error_exit
    ;;

  clean-build-3rd-party)
    clean_build_3rd_party || error_exit
    ;;

  jobs)
    jobs ${ARGS} || error_exit "Dynawo job failed"
    ;;

  jobs-valgrind)
    jobs --valgrind ${ARGS} || error_exit "Dynawo job failed"
    ;;

  jobs-valgrind-callgrind)
    jobs --valgrind-callgrind ${ARGS} || error_exit "Dynawo job failed"
    ;;

  jobs-valgrind-dhat)
    jobs --valgrind-dhat ${ARGS} || error_exit "Dynawo job failed"
    ;;

  jobs-valgrind-massif)
    jobs --valgrind-massif ${ARGS} || error_exit "Dynawo job failed"
    ;;

  jobs-gdb)
    jobs --gdb ${ARGS} || error_exit "Dynawo job failed"
    ;;

  jobs-with-curves)
    jobs_with_curves ${ARGS} || error_exit "Dynawo job with curves failed"
    ;;

  dump-model)
    dump_model ${ARGS} || error_exit "Error during model's description dump"
    ;;

  doc-dynawo)
    doc_dynawo || error_exit "Error during dynawo doc visualisation"
    ;;

  flat-model)
    flat_model ${ARGS} || error_exit "Failed to generate Modelica model documentation"
    ;;

  nrt)
    nrt ${ARGS} || error_exit "Error during Dynawo's non regression tests execution"
    ;;

  nrt-diff)
    nrt_diff ${ARGS} || error_exit "Error during Dynawo's NRT Diff execution"
    ;;

  curves-visu)
    curves_visu ${ARGS} || error_exit "Error during curves visualisation page generation"
    ;;

  display-environment)
    display_environmentVariables || error_exit "Failed to display environment variables"
    ;;

  version)
    version || error_exit "Error during version visualisation"
    ;;

  version-validation)
    version_validation || error_exit "The current version does not fulfill the standard quality check"
    ;;

  generate-preassembled)
    generate_preassembled ${ARGS} || error_exit "Error during the generation of a preassembled model"
    ;;

  generate-preassembled-gdb)
    generate_preassembled_gdb ${ARGS} || error_exit "Error during the generation of a preassembled model"
    ;;

  clean-old-branches)
    clean_old_branches || error_exit "Error during the cleaning of old branches build/install/nrt"
    ;;

  deploy)
    deploy_dynawo || error_exit "Error during the deployment of dynawo"
    ;;

  help)
    echo "$usage"
    ;;

  *)
    echo "$1 is an invalid option"
    echo "$usage"
    ;;
esac
