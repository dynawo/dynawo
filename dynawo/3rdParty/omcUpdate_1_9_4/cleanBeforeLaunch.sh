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
#-------------------
# 0- Initializations
#-------------------
# Default values
SRC_OPENMODELICA=""
RM="/bin/rm -v -f"
MV="/bin/mv -v"
RMDIR="/bin/rm -rf"
OS="lnx"

while (($#)); do
  case $1 in
    --openmodelica-dir=*)
      SRC_OPENMODELICA=`echo $1 | sed -e 's/--openmodelica-dir=//g'`
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

# Restore original file
# ------------------------------
restore_original_file() {
  if [ -f "${1}.orig" ]; then
    $MV ${1}.orig ${1}
  fi
}

# OMC specific architecture
# ------------------------------
architecture_omc() {
  # omc directories
  COMPILER_DIR="OMCompiler/Compiler"
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
  SIMULATION_DATA_FILE="simulation_data.h"
  BOOT_FILE="LoadCompilerSources.mos"
  CONFIGURE_FILE="configure.ac"
  LIBRARIES_MAKEFILE="Makefile"
  MAKEFILE_LIBS="Makefile.libs"
  TASK_GRAPH_RESULTS_CMP_FILE="TaskGraphResultsCmp.cpp"
  MAKEFILE_IN="Makefile.in"

  test_directory ${SRC_OPENMODELICA}

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
}

restore_files() {
  restore_original_file ${fileMetaModelicaRemoveSimple}
  restore_original_file ${cmakelistsFile}
  restore_original_file ${fileModelicaBuiltin}
  restore_original_file ${fileMetaModelicaScript}
  restore_original_file ${fileCodegenCFunctionsTpl}
  restore_original_file ${fileCodegenCTpl}
  restore_original_file ${bootFile}
  restore_original_file ${ConfigureFile}
  restore_original_file ${MakefileLibraries}
  restore_original_file ${MakefileLibs}
  restore_original_file ${SimulationDataFile}
  restore_original_file ${TaskGraphResultsCmpFile}
  restore_original_file ${MakefileIn}
}

remove_created_files() {
  file1="${SRC_BACKEND}${ps}XMLCreateDynawo.mo"
  $RM ${file1}
}

remove_patch_files() {
  # ... Remove patch files
  patchFile="${SRC_OPENMODELICA}${ps}RemoveSimpleEquations-mo.patch"
  $RM ${patchFile}

  patchFile="${SRC_OPENMODELICA}${ps}CMakeListsCompiler-txt.patch"
  $RM ${patchFile}

  patchFile="${SRC_OPENMODELICA}${ps}ModelicaBuiltin-mo.patch"
  $RM ${patchFile}

  patchFile="${SRC_OPENMODELICA}${ps}CevalScriptBackend-mo.patch"
  $RM ${patchFile}

  patchFile="${SRC_OPENMODELICA}${ps}CodegenCFunctions-tpl.patch"
  $RM ${patchFile}

  patchFile="${SRC_OPENMODELICA}${ps}CodegenC-tpl.patch"
  $RM ${patchFile}

  patchFile="${SRC_OPENMODELICA}${ps}simulation_data-h.patch"
  $RM ${patchFile}

  patchFile="${SRC_OPENMODELICA}${ps}LoadCompilerSources-mos.patch"
  $RM ${patchFile}

  patchFile="${SRC_OPENMODELICA}${ps}configure-ac.patch"
  $RM ${patchFile}

  patchFile="${SRC_OPENMODELICA}${ps}TaskGraphResultsCmp.cpp.patch"
  $RM ${patchFile}

  patchFile="${SRC_OPENMODELICA}${ps}Makefile.in.patch"
  $RM ${patchFile}
}

architecture_omc
restore_files
remove_created_files
remove_patch_files

exit 0
