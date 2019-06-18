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

source utils.sh
init

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
  for patchedFile in "${patchedFiles[@]}"; do
    test_file ${patchedFile}
  done
}

restore_files() {
  for patchedFile in "${patchedFiles[@]}"; do
    restore_original_file ${patchedFile}
  done
  restore_original_file ${SRC_OPENMODELICA}${ps}libraries${ps}Makefile.libs
}

remove_created_files() {
  for file in "${addedFile[@]}"; do
    $RM ${file}
  done
}

remove_patch_files() {
  # ... Remove patch files
  for patchFile in "${patchFilesInOM[@]}"; do
    $RM ${patchFile}
  done
}

architecture_omc
restore_files
remove_created_files
remove_patch_files
