# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

include(FindGit)
find_package(Git)

if(GIT_FOUND)
  if(EXISTS "${GIT_SOURCE_DIR}")
    # extract working copy information for SOURCE_DIR into MY_XXX variables
    execute_process(COMMAND git rev-parse --abbrev-ref HEAD
      WORKING_DIRECTORY ${GIT_SOURCE_DIR}
      OUTPUT_VARIABLE GIT_BRANCH
      OUTPUT_STRIP_TRAILING_WHITESPACE
      )
    execute_process(COMMAND git log -1 --format=%h
      WORKING_DIRECTORY ${GIT_SOURCE_DIR}
      OUTPUT_VARIABLE GIT_COMMIT_HASH
      OUTPUT_STRIP_TRAILING_WHITESPACE
      )
  else()
    set(GIT_BRANCH "Unknown")
    set(GIT_COMMIT_HASH "0")
  endif()
else(GIT_FOUND)
  set(GIT_BRANCH "Unknown")
  set(GIT_COMMIT_HASH "-1")
endif()

file(WRITE ${OUTPUT_DIR}/gitversion.h.txt
  "//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
#define DYNAWO_GIT_BRANCH \"${GIT_BRANCH}\"\n#define DYNAWO_GIT_HASH \"${GIT_COMMIT_HASH}\"\n")
# copy the file to the final header only if the version changes
# reduces needless rebuilds
execute_process(COMMAND ${CMAKE_COMMAND} -E copy_if_different
                        ${OUTPUT_DIR}/gitversion.h.txt ${OUTPUT_DIR}/gitversion.h)
message(STATUS "gitversion.h generated in ${OUTPUT_DIR}")
