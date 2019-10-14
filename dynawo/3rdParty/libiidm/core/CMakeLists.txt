# Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Libiidm, a library to model IIDM networks and allows importing and exporting them to files.

project(libiidm CXX)

set(CPACK_COMPONENT_IIDM-CORE_DISPLAY_NAME "LibIIDM core")
set(CPACK_COMPONENT_IIDM-CORE_DESCRIPTION
  "Core library. Provides Network modeling including general extension support."
)
set(CPACK_COMPONENT_IIDM-CORE_REQUIRED ON)

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/include/IIDM/version.h.in
  ${CMAKE_CURRENT_SOURCE_DIR}/include/IIDM/version.h
)

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/include/IIDM/config.h.in
  ${CMAKE_CURRENT_SOURCE_DIR}/include/IIDM/config.h
)

add_library(
  iidm
  src/Network.cpp
  src/Extension.cpp

  src/components/Identifiable.cpp
  src/components/Connectable.cpp
  src/components/Connection.cpp
  src/components/ConnectionPoint.cpp

  src/components/ExternalComponent.cpp

  src/components/Substation.cpp
  src/components/Line.cpp
  src/components/TieLine.cpp
  src/components/HvdcLine.cpp

  src/components/VoltageLevel.cpp

  src/components/BusBarSection.cpp
  src/components/Bus.cpp
  src/components/Switch.cpp

  src/components/Generator.cpp
  src/components/DanglingLine.cpp
  src/components/Load.cpp
  src/components/ShuntCompensator.cpp
  src/components/StaticVarCompensator.cpp
  src/components/VscConverterStation.cpp
  src/components/LccConverterStation.cpp

  src/components/Transformer2Windings.cpp
  src/components/Transformer3Windings.cpp

  src/components/CurrentLimit.cpp
  src/components/ReactiveInformations.cpp
  src/components/TapChanger.cpp
  src/components/TerminalReference.cpp


  src/builders/NetworkBuilder.cpp

  src/builders/BusBarSectionBuilder.cpp
  src/builders/BusBuilder.cpp

  src/builders/LineBuilder.cpp
  src/builders/TieLineBuilder.cpp
  src/builders/HvdcLineBuilder.cpp

  src/builders/SubstationBuilder.cpp

  src/builders/SwitchBuilder.cpp
  src/builders/Transformer2WindingsBuilder.cpp
  src/builders/Transformer3WindingsBuilder.cpp

  src/builders/VoltageLevelBuilder.cpp

  src/builders/GeneratorBuilder.cpp
  src/builders/DanglingLineBuilder.cpp
  src/builders/LoadBuilder.cpp
  src/builders/ShuntCompensatorBuilder.cpp
  src/builders/StaticVarCompensatorBuilder.cpp
  src/builders/LccConverterStationBuilder.cpp
  src/builders/VscConverterStationBuilder.cpp
)

target_include_directories(iidm
  PUBLIC
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:${LibIIDM_INSTALL_INCLUDE}>
)

set_target_properties(iidm
  PROPERTIES
    VERSION ${IIDM_VERSION}
    SOVERSION ${IIDM_SOVERSION}
    WINDOWS_EXPORT_ALL_SYMBOLS TRUE
)

install(TARGETS iidm EXPORT libiidm-core-config
  PUBLIC_HEADER DESTINATION ${LibIIDM_INSTALL_INCLUDE}
  ARCHIVE DESTINATION ${LibIIDM_INSTALL_LIBRARIES}
  LIBRARY DESTINATION ${LibIIDM_INSTALL_LIBRARIES}
  RUNTIME DESTINATION ${LibIIDM_INSTALL_BINARIES}
  RESOURCE DESTINATION ${IIDM_SHARE_PATH}
  COMPONENT iidm-core
)

install(DIRECTORY include/IIDM
  DESTINATION ${LibIIDM_INSTALL_INCLUDE}
  COMPONENT iidm-core
  FILES_MATCHING PATTERN "*.h"
)

install(EXPORT libiidm-core-config
  DESTINATION ${LibIIDM_INSTALL_CMAKE}
  FILE libiidm-core-targets.cmake
  COMPONENT iidm-core
)

include(CMakePackageConfigHelpers)
configure_package_config_file(libiidm-core-config.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/libiidm-core-config.cmake
  INSTALL_DESTINATION ${LibIIDM_INSTALL_CMAKE}
  PATH_VARS
    LibIIDM_INSTALL_INCLUDE
    LibIIDM_INSTALL_LIBRARIES
    LibIIDM_INSTALL_BINARIES
  NO_CHECK_REQUIRED_COMPONENTS_MACRO
)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/libiidm-core-config.cmake
  DESTINATION ${LibIIDM_INSTALL_CMAKE}
  COMPONENT iidm-core
)


add_custom_target(install-core
  DEPENDS iidm
  COMMAND
    "${CMAKE_COMMAND}" -DCMAKE_INSTALL_COMPONENT=iidm-core -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
)

if( BUILD_SAMPLES )
  add_subdirectory(samples)
endif()
