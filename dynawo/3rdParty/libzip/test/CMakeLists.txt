# Copyright (c) 2013-2019, RTE (http://www.rte-france.com)
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Libzip, a library to handle zip archives.

if (NOT GTEST_FOUND)
    message(FATAL_ERROR "Google Test is needed to build the tests.")
endif ()

set(UNIT_TEST_SOURCES
    test1.cpp
    test2.cpp)

add_executable(unittest ${UNIT_TEST_SOURCES})
target_link_libraries(unittest $<$<NOT:$<CXX_COMPILER_ID:MSVC>>:pthread> ${GTEST_BOTH_LIBRARIES})
if (LIBZIP_BUILD_SHARED)
  target_link_libraries(unittest ${CMAKE_PROJECT_NAME})
elseif(LIBZIP_BUILD_STATIC)
  target_link_libraries(unittest ${CMAKE_PROJECT_NAME}-static)
endif ()

add_custom_target(tests unittest DEPENDS unittest COMMENT "Running unit tests...")
