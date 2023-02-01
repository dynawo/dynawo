# Copyright (c) 2021, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

set(TEST_UTILS_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(TEST_UTILS_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(TEST_UTILS_SOURCES
    initXml.cpp
    )

add_library(dynawo_Test_utils SHARED ${TEST_UTILS_SOURCES})

target_link_libraries(dynawo_Test_utils
  PRIVATE
    dynawo_Common
    GTest::gmock_main
    GTest::gtest_main
  PUBLIC
    XMLSAXParser${LibXML_LINK_SUFFIX}
    LibXml2::LibXml2
)

set_target_properties(dynawo_Test_utils PROPERTIES VERSION ${TEST_UTILS_VERSION_STRING}
                                                 SOVERSION ${TEST_UTILS_VERSION_MAJOR})

install(TARGETS dynawo_Test_utils EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
