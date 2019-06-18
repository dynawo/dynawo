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

ps="/"
if [ \( ! -z "${OS}" \) -a \( "${OS}" = "Window_NT" \) ]; then
  ps="\\"
fi

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

source utils.sh
init

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
  for patchedFile in "${patchedFiles[@]}"; do
    test_file ${patchedFile}
  done
}

# Dynawo specific architecture
#-------------------------------
architecture_dynawo() {
  for patchFile in "${patchFiles[@]}"; do
    test_file ${patchFile}
  done
  for file in "${addedFile[@]}"; do
    filename=$(basename $file)
    test_file ${DIR_RESOURCE}${ps}${filename}
  done
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
  for patchedFile in "${patchedFiles[@]}"; do
    save_file_if_not_exist ${patchedFile}
  done
  save_file_if_not_exist ${SRC_OPENMODELICA}${ps}libraries${ps}Makefile
  save_file_if_not_exist ${SRC_OPENMODELICA}${ps}libraries${ps}Makefile.libs
}

# Update sources
# -----------------------
update_sources() {
  # copy new file
  for file in "${addedFile[@]}"; do
    filename=$(basename $file)
    $CP ${DIR_RESOURCE}${ps}${filename} ${file}
  done

  $CD ${SRC_OPENMODELICA}
  for patchFile in "${patchFiles[@]}"; do
    $CP ${patchFile} .
    patch -p0 < ${patchFile}
  done
  $CP ${DIR_RESOURCE}${ps}libraries-Makefile ${SRC_OPENMODELICA}${ps}libraries${ps}Makefile
  $CP ${DIR_RESOURCE}${ps}Makefile.libs ${SRC_OPENMODELICA}${ps}libraries${ps}Makefile.libs
}

#++++++++++++++
# Main program
#++++++++++++++
script=$0

ps="/"

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
  sed -i '/@APP@/d' Makefile.in || { echo "Error while updating OMC sources for Darwin."; exit 1; }
  popd
fi

#---------------------------
# 5- OMC binary creation
#---------------------------
create_omc_dynawo
