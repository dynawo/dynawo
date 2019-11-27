# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

if (NOT (CMAKE_BUILD_TYPE STREQUAL "Debug" OR CMAKE_BUILD_TYPE STREQUAL "Tests"))
  message(WARNING "Unit tests should be launched with debug or tests configuration")
endif()

IF(MSVC)
  add_definitions(-D_DEBUG_)
  add_definitions(-DGTEST_LINKED_AS_SHARED_LIBRARY)
else()
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -O0 -D_DEBUG_")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -O0")
endif()

function(add_test test-target)
  add_dependencies(tests ${test-target})
endfunction()

add_custom_target(tests
  COMMENT "launch each unit test")
