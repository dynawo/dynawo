# Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.

function(SetPatchCommands projectName)

  set(TmpDirName "$ENV{DYNAWO_HOME}/dynawo/3rdParty")
  if(NOT IS_DIRECTORY "${TmpDirName}")
      message(FATAL_ERROR "Path to patches should be a directory: it is not! : '${TmpDirName}'")
  endif()

  set(PatchFile "${TmpDirName}/${projectName}/patch/common/${projectName}.patch")
  if(EXISTS ${PatchFile})
    if(UNIX)
      set(paquet_all_comp_patch
        patch -p1 --forward --no-backup-if-mismatch -r /dev/null -i ${PatchFile} || echo -n
        PARENT_SCOPE
      )
    else()
      set(paquet_all_comp_patch
        git apply -p1 ${PatchFile} --reverse --check 2> nul ||
        git apply --ignore-whitespace --whitespace=nowarn -p1 ${PatchFile}
        PARENT_SCOPE
      )
    endif()
  else()
    set(paquet_all_comp_patch
        ${CMAKE_COMMAND} -E echo No common patch for ${projectName}.
      PARENT_SCOPE
    )
  endif()

  set(PatchFile "${TmpDirName}/${projectName}/patch/${CMAKE_CXX_COMPILER_ID}/${projectName}.patch")
  if(EXISTS ${PatchFile})
    if(UNIX)
      set(paquet_compiler_patch
        patch -p1 --forward --no-backup-if-mismatch -r /dev/null -i ${PatchFile} || echo -n
        PARENT_SCOPE
      )
    else()
      set(paquet_compiler_patch
        git apply -p1 ${PatchFile} --reverse --check 2> nul ||
        git apply --ignore-whitespace --whitespace=nowarn -p1 ${PatchFile}
        PARENT_SCOPE
      )
    endif()
  else()
      set(paquet_compiler_patch
      ${CMAKE_COMMAND} -E echo No compiler patch for ${projectName}.
      PARENT_SCOPE
    )
  endif()

endfunction()
