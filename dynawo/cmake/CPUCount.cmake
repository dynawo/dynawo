# Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.

if(NOT DEFINED CPU_COUNT OR CPU_COUNT LESS_EQUAL 0)
  if(DEFINED ENV{DYNAWO_NB_PROCESSORS_USED})
    set(CPU_COUNT "$ENV{DYNAWO_NB_PROCESSORS_USED}")
  endif()
  if(NOT DEFINED CPU_COUNT OR CPU_COUNT LESS_EQUAL 0)
    include(ProcessorCount)
    ProcessorCount(CPU_COUNT)
    if(NOT DEFINED CPU_COUNT OR CPU_COUNT LESS_EQUAL 0)
      set(CPU_COUNT 1)
    endif()
  endif()
  set(CMAKE_BUILD_FLAGS -j${CPU_COUNT})
endif()
