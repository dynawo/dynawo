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

# Specific resources directory
#-------------------------------------------------------
DIR_RESOURCE="${PWD}"

function init {
  patchFiles=(`ls ${DIR_RESOURCE}${ps}*.patch`)
  patchFilesInOM=()
  patchedFiles=()
  addedFile=(${SRC_OPENMODELICA}${ps}OMCompiler${ps}Compiler${ps}BackEnd${ps}XMLCreateDynawo.mo)

  for patchFile in "${patchFiles[@]}"; do
    file=`echo $patchFile | sed 's|'"${DIR_RESOURCE}"'|'"${SRC_OPENMODELICA}"'|g'`
    patchFilesInOM+=($file)
    patchedFile=`grep "+++" $patchFile |  awk '{print $2;}'`
    patchedFiles+=(${SRC_OPENMODELICA}${ps}${patchedFile})
  done
}
