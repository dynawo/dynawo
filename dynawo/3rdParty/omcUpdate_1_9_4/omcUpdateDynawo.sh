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
#set -x
#
##########################################################################
#     GENERATION OF the OMC binary for DYNAWO
##########################################################################
#
# Script : omcUpdateDynawo.sh
# -----
##########################################################################
#
#-------------------
# 0- Initializations
#-------------------
# Default values
SRC_OPENMODELICA=""
INSTALL_OPENMODELICA=""
INSTALL_METAMODELICA=""
NB_PROCESSORS_USED=1

while (($#)); do
  case $1 in
    --openmodelica-dir=*)
      SRC_OPENMODELICA=`echo $1 | sed -e 's/--openmodelica-dir=//g'`
      ;;
    --openmodelica-install=*)
      INSTALL_OPENMODELICA=`echo $1 | sed -e 's/--openmodelica-install=//g'`
      ;;
    --nbProcessors=*)
      NB_PROCESSORS_USED=`echo $1 | sed -e 's/--nbProcessors=//g'`
      ;;
    *)
      break
      ;;
  esac
  shift
done
echo "SRC_OPENMODELICA=$SRC_OPENMODELICA"
echo "INSTALL_OPENMODELICA=$INSTALL_OPENMODELICA"

# Specific resources directory
#-------------------------------------------------------
DIR_RESOURCE="${PWD}"

OS="lnx"

# 0.1- Usefull commands
#-------------------------
BASENAME="basename"
CD="cd"
CP="cp -v"
MV="mv -f"
MKDIR="mkdir -p"
RMDIR="/bin/rm -rf"
RM="/bin/rm -f"
SED="sed"
MAKE="make"

#+++++++++++++++++++++++++++++++++++
# Routines
#+++++++++++++++++++++++++++++++++++

# Error messages about files
#----------------------------------
message_file() {
  echo
  echo "%% Error : File $1 doesn't exist"
  echo "==> Stop procedure"
  echo
  exit 2
}

# Error messages about directories
#-------------------------------------
message_directory() {
  echo
  echo "%% Error : Directory $1 doesn't exist"
  echo "==> Stop procedure"
  echo
  exit 1
}

# File existence test
#----------------------------
test_file() {
  if [ ! -f "$1" ]; then
    message_file $1
  fi
}

# Directory existence test
# ------------------------------
test_directory() {
  if [ ! -d "$1" ]; then
    message_directory $1
  fi
}

error_exit() {
  echo "${1:-"Unknown Error"}" 1>&2
  exit 1
}

# Print and launch command
# -----------------------------
launch_command() {
  echo " -------------------------------------------------------"
  echo " ** Launching command :"
  echo  $*
  $* || error_exit "Error in build-omcDynawo with command $*."
  echo " -------------------------------------------------------"
  echo ""
}

# OMC specific architecture
#-------------------------------
architecture_omc() {
  # omc directories
  COMPILER_DIR="OMCompiler/Compiler"
  OMCOMPILER_DIR="OMCompiler"
  COMPILER_RUNTIME_DIR="OMCompiler/Compiler/runtime"
  SIMULATION_RUNTIME_C_DIR="OMCompiler/SimulationRuntime/c"
  BACKEND_DIR="BackEnd"
  FRONTEND_DIR="FrontEnd"
  SCRIPT_DIR="Script"
  TEMPLATE_DIR="Template"
  BOOT_DIR="boot"
  LIBRARIES_DIR="libraries"

  # files concerned by modifications
  METAMODELICA_REMOVE_SIMPLE_FILE="RemoveSimpleEquations.mo"
  CMAKELISTS="CMakeLists.txt"
  MODELICA_BUILTIN_FILE="ModelicaBuiltin.mo"
  METAMODELICA_SCRIPT_FILE="CevalScriptBackend.mo"
  CODEGENCFUNCTIONS_TPL_FILE="CodegenCFunctions.tpl"
  CODEGENC_TPL_FILE="CodegenC.tpl"
  BOOT_FILE="LoadCompilerSources.mos"
  CONFIGURE_FILE="configure.ac"
  LIBRARIES_MAKEFILE="Makefile"
  MAKEFILE_LIBS="Makefile.libs"
  SIMULATION_DATA_FILE="simulation_data.h"
  TASK_GRAPH_RESULTS_CMP_FILE="TaskGraphResultsCmp.cpp"
  MAKEFILE_IN="Makefile.in"

  test_directory ${SRC_OPENMODELICA}
  mkdir -p ${INSTALL_OPENMODELICA}

  SRC_COMPILER="${SRC_OPENMODELICA}${ps}${COMPILER_DIR}"
  test_directory ${SRC_COMPILER}

  SRC_BACKEND="${SRC_COMPILER}${ps}${BACKEND_DIR}"
  test_directory ${SRC_BACKEND}

  SRC_FRONTEND="${SRC_COMPILER}${ps}${FRONTEND_DIR}"
  test_directory ${SRC_FRONTEND}

  SRC_SCRIPT="${SRC_COMPILER}${ps}${SCRIPT_DIR}"
  test_directory ${SRC_SCRIPT}

  SRC_TEMPLATE="${SRC_COMPILER}${ps}${TEMPLATE_DIR}"
  test_directory ${SRC_TEMPLATE}

  SRC_BOOT="${SRC_COMPILER}${ps}${BOOT_DIR}"
  test_directory ${SRC_BOOT}

  SRC_LIBRARIES="${SRC_OPENMODELICA}${ps}${LIBRARIES_DIR}"
  test_directory ${SRC_LIBRARIES}

  fileMetaModelicaRemoveSimple="${SRC_BACKEND}${ps}${METAMODELICA_REMOVE_SIMPLE_FILE}"
  test_file ${fileMetaModelicaRemoveSimple}

  cmakelistsFile="${SRC_COMPILER}${ps}${CMAKELISTS}"
  test_file ${cmakelistsFile}

  fileModelicaBuiltin="${SRC_FRONTEND}${ps}${MODELICA_BUILTIN_FILE}"
  test_file ${fileModelicaBuiltin}

  fileMetaModelicaScript="${SRC_SCRIPT}${ps}${METAMODELICA_SCRIPT_FILE}"
  test_file ${fileMetaModelicaScript}

  fileCodegenCFunctionsTpl="${SRC_TEMPLATE}${ps}${CODEGENCFUNCTIONS_TPL_FILE}"
  test_file ${fileCodegenCFunctionsTpl}

  fileCodegenCTpl="${SRC_TEMPLATE}${ps}${CODEGENC_TPL_FILE}"
  test_file ${fileCodegenCTpl}

  bootFile="${SRC_BOOT}${ps}${BOOT_FILE}"
  test_file ${bootFile}

  ConfigureFile="${SRC_OPENMODELICA}${ps}${CONFIGURE_FILE}"
  test_file ${ConfigureFile}

  MakefileLibraries="${SRC_LIBRARIES}${ps}${LIBRARIES_MAKEFILE}"
  test_file ${MakefileLibraries}

  MakefileLibs="${SRC_LIBRARIES}${ps}${MAKEFILE_LIBS}"
  test_file ${MakefileLibs}

  SimulationDataFile="${SRC_OPENMODELICA}${ps}${SIMULATION_RUNTIME_C_DIR}${ps}${SIMULATION_DATA_FILE}"
  test_file ${SimulationDataFile}

  TaskGraphResultsCmpFile="${SRC_OPENMODELICA}${ps}${COMPILER_RUNTIME_DIR}${ps}${TASK_GRAPH_RESULTS_CMP_FILE}"
  test_file ${TaskGraphResultsCmpFile}

  MakefileIn="${SRC_OPENMODELICA}${ps}${MAKEFILE_IN}"
  test_file ${MakefileIn}

  ConfigureOMCompiler="${SRC_OPENMODELICA}${ps}${OMCOMPILER_DIR}${ps}${CONFIGURE_FILE}"
  test_file ${ConfigureOMCompiler}
}

# Dynawo specific architecture
#-------------------------------
architecture_dynawo() {
  fileRessource0="XMLCreateDynawo.mo"
  fileRessource1="RemoveSimpleEquations-mo.patch"
  fileRessource2="CMakeListsCompiler-txt.patch"
  fileRessource3="ModelicaBuiltin-mo.patch"
  fileRessource4="CevalScriptBackend-mo.patch"
  fileRessource5="CodegenCFunctions-tpl.patch"
  fileRessource6="LoadCompilerSources-mos.patch"
  fileRessource7="configure-ac.patch"
  fileRessource8="libraries-Makefile"
  fileRessource9="Makefile.libs"
  fileRessource10="CodegenC-tpl.patch"
  fileRessource11="simulation_data-h.patch"
  fileRessource12="TaskGraphResultsCmp.cpp.patch"
  fileRessource13="Makefile.in.patch"
  fileRessource14="configure-ac-omcompiler.patch"

  # File existence tests
  #-----------------------------
  file0="${DIR_RESOURCE}${ps}${fileRessource0}"
  test_file ${file0}

  file1="${DIR_RESOURCE}${ps}${fileRessource1}"
  test_file ${file1}

  file2="${DIR_RESOURCE}${ps}${fileRessource2}"
  test_file ${file2}

  file3="${DIR_RESOURCE}${ps}${fileRessource3}"
  test_file ${file3}

  file4="${DIR_RESOURCE}${ps}${fileRessource4}"
  test_file ${file4}

  file5="${DIR_RESOURCE}${ps}${fileRessource5}"
  test_file ${file5}

  file6="${DIR_RESOURCE}${ps}${fileRessource6}"
  test_file ${file6}

  file7="${DIR_RESOURCE}${ps}${fileRessource7}"
  test_file ${file7}

  file8="${DIR_RESOURCE}${ps}${fileRessource8}"
  test_file ${file8}

  file9="${DIR_RESOURCE}${ps}${fileRessource9}"
  test_file ${file9}

  file10="${DIR_RESOURCE}${ps}${fileRessource10}"
  test_file ${file10}

  file11="${DIR_RESOURCE}${ps}${fileRessource11}"
  test_file ${file11}

  file12="${DIR_RESOURCE}${ps}${fileRessource12}"
  test_file ${file12}

  file13="${DIR_RESOURCE}${ps}${fileRessource13}"
  test_file ${file13}

  file14="${DIR_RESOURCE}${ps}${fileRessource14}"
  test_file ${file14}
}

# Baner presentation
#--------------------------
print_baner() {
  echo
  echo "     --------------------------------------"
  echo "     Launching of generation of $OMC_NAME"
  echo "     --------------------------------------"
  echo
  echo " Execution of : \"${script}\"."
  echo
  echo
}

#  OMC dynawo binary generation
#---------------------------------
create_omc_dynawo() {
  $CD ${SRC_OPENMODELICA}

  echo
  echo  "================================================================"
  echo  "   ==> Generation of specific executable for OpenModelica"
  echo  "================================================================"
  echo
  cmd1="autoreconf"
  launch_command ${cmd1}

  cmd1="./configure CC=$DYNAWO_C_COMPILER CXX=$DYNAWO_CXX_COMPILER --prefix=${INSTALL_OPENMODELICA} --disable-modelica3d --disable-omnotebook --disable-omshell-terminal --with-qwt=NO"
  launch_command ${cmd1}

  cmd1="${MAKE} -j${NB_PROCESSORS_USED} clean"
  launch_command ${cmd1}

  cmd1="${MAKE} -j${NB_PROCESSORS_USED} omc"
  launch_command ${cmd1}

  create_modelica_3_2_2

  cmd1="${MAKE} -j${NB_PROCESSORS_USED} omlibrary-all"
  launch_command ${cmd1}

  cmd1="${MAKE} install"
  launch_command ${cmd1}

  $CD ${INSTALL_OPENMODELICA}${ps}/bin
  ln -s -f omc omcDynawo
}

# Modelica sources version 3.2.2 creation
# ----------------------------------------
create_modelica_3_2_2() {
  cd ${SRC_OPENMODELICA}/libraries/Modelica
  $MKDIR 'Modelica 3.2.2'
  cp -r Modelica/* 'Modelica 3.2.2'/
  $MKDIR 'ModelicaReference 3.2.2'
  cp -r ModelicaReference/* 'ModelicaReference 3.2.2'/
  $MKDIR 'ModelicaServices 3.2.2'
  cp -r ModelicaServices/* 'ModelicaServices 3.2.2'/
  $MKDIR 'ModelicaTest 3.2.2'
  cp -r ModelicaTest/* 'ModelicaTest 3.2.2'/
  cd ${SRC_OPENMODELICA}
}

# Save file if it is not already saved
# ------------------------------------------
save_file_if_not_exist() {
  echo
  fileSave="$1.orig"
  if [ ! -f "$fileSave" ]; then
    echo " =================== Save original file ==========================="
    $CP $1 $fileSave
    echo " ================================================================="
  fi
  echo
}

# Save original files
# ---------------------------------
save_original_files() {
  save_file_if_not_exist ${fileMetaModelicaRemoveSimple}
  save_file_if_not_exist ${cmakelistsFile}
  save_file_if_not_exist ${fileModelicaBuiltin}
  save_file_if_not_exist ${fileMetaModelicaScript}
  save_file_if_not_exist ${fileCodegenCFunctionsTpl}
  save_file_if_not_exist ${fileCodegenCTpl}
  save_file_if_not_exist ${bootFile}
  save_file_if_not_exist ${ConfigureFile}
  save_file_if_not_exist ${MakefileLibraries}
  save_file_if_not_exist ${MakefileLibs}
  save_file_if_not_exist ${SimulationDataFile}
  save_file_if_not_exist ${TaskGraphResultsCmpFile}
  save_file_if_not_exist ${MakefileIn}
  save_file_if_not_exist ${ConfigureOMCompiler}
}

# Update sources
# -----------------------
update_sources() {
  # copy new file
  $CP ${file0}  ${SRC_BACKEND}

  # patch other files
  $CD ${SRC_OPENMODELICA}
  $CP ${file1} .
  $CP ${file2} .
  $CP ${file3} .
  $CP ${file4} .
  $CP ${file5} .
  $CP ${file6} .
  $CP ${file7} .
  $CP ${file10} .
  $CP ${file11} .
  $CP ${file12} .
  $CP ${file13} .
  $CP ${file14} .

  patch -p0 < ${fileRessource1}
  patch -p0 < ${fileRessource2}
  patch -p0 < ${fileRessource3}
  patch -p0 < ${fileRessource4}
  patch -p0 < ${fileRessource5}
  patch -p0 < ${fileRessource6}
  patch -p0 < ${fileRessource7}
  patch -p0 < ${fileRessource10}
  patch -p0 < ${fileRessource11}
  patch -p0 < ${fileRessource12}
  patch -p1 < ${fileRessource13}
  patch -p0 < ${fileRessource14}

  # replace files in libraries
  $CP ${file8} ${MakefileLibraries}
  $CP ${file9} ${MakefileLibs}
}

#++++++++++++++
# Main program
#++++++++++++++
script=$0

ps="/"
if [ \( ! -z "${OS}" \) -a \( "${OS}" = "Window_NT" \) ]; then
  ps="\\"
fi

#-----------------
# 1- Presentation
#-----------------
print_baner

#--------------------------------------------
# 2- Architecture definition and data check
#--------------------------------------------
architecture_omc
architecture_dynawo

#-------------------------
# 3- Save original files
#-------------------------
save_original_files

#-------------------------------------------------------
# 4- Apply modifications with respect to resource files
#-------------------------------------------------------
update_sources

if [ "`uname`" = "Darwin" ]; then
  pushd $SRC_OPENMODELICA
  if [ -x "$(command -v sed)" ]; then
    if [ -z "$(sed --version 2>&1 | head -1 | grep GNU)" ]; then
      echo "You need GNU version of sed to install OpenModelica. See https://www.gnu.org/software/sed/"
      exit 1
    fi
  fi
  sed -i 's/libstdc++/libc++/' OMCompiler/configure.ac || { echo "Error while updating OMC sources for Darwin."; exit 1; }
  sed -i 's/disable-gcj-support/disable-gcj-support --enable-static/' OMCompiler/Makefile.common || { echo "Error while updating OMC sources for Darwin."; exit 1; }
  sed -i 's#if [ "@APP@" = ".app" ]; then mkdir -p ${INSTALL_APPDIR}; fi##' Makefile.in || { echo "Error while updating OMC sources for Darwin."; exit 1; }
  sed -i 's#if [ "@APP@" = ".app" ]; then cp -a "@OMBUILDDIR@"/Applications/* $(INSTALL_APPDIR); fi##' Makefile.in || { echo "Error while updating OMC sources for Darwin."; exit 1; }
  if [ -x "/usr/bin/clang++" ]; then
    sed -i '155 s#$# CXX="/usr/bin/clang++"#' OMCompiler/Makefile.common || { echo "Error while updating OMC sources for Darwin."; exit 1; }
  else
    echo "/usr/bin/clang++ is not available as compiler. We only support clang on MacOs."
    exit 1
  fi
  popd
fi

#---------------------------
# 5- OMC binary creation
#---------------------------
create_omc_dynawo

#--------
# 7- End
#--------
exit 0
