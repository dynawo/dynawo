# Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Libiidm, a library to model IIDM networks and allows importing and exporting them to files.

project(libiidm_xml CXX)

set(CPACK_COMPONENTS_ALL ${CPACK_COMPONENTS_ALL} iidm-xml PARENT_SCOPE)

set(CPACK_COMPONENT_IIDM-XML_DISPLAY_NAME "XML support")
set(CPACK_COMPONENT_IIDM-XML_DESCRIPTION
  "XML support library for core library."
)
set(CPACK_COMPONENT_IIDM-XML_DEPENDS iidm-core)

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/include/IIDM/xml/version.h.in
  ${CMAKE_CURRENT_SOURCE_DIR}/include/IIDM/xml/version.h
)

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/include/IIDM/xml/config.h.in
  ${CMAKE_CURRENT_SOURCE_DIR}/include/IIDM/xml/config.h
)

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/include/internals/config.h.in
  ${CMAKE_CURRENT_SOURCE_DIR}/include/internals/config.h
)

set(IIDM_XML_SOURCES
  src/export.cpp
  src/export/attributes_helper.cpp
  src/export/export_functions.cpp

  src/ExecUtils.cpp

  src/import.cpp
  src/import/IIDMDocumentHandler.cpp

  src/import/iidm_namespace.cpp
  src/import/ExtensionHandler.cpp

  src/import/ConnectableHandler.cpp

  src/import/NetworkHandler.cpp
  src/import/LinesHandler.cpp
  src/import/HvdcLineHandler.cpp
  src/import/SubstationHandler.cpp

  src/import/Transformer2WindingsHandler.cpp
  src/import/Transformer3WindingsHandler.cpp

  src/import/VoltageLevelHandler.cpp

  src/import/BusHandler.cpp
  src/import/BusBarSectionHandler.cpp
  src/import/SwitchHandler.cpp

  src/import/BatteryHandler.cpp
  src/import/GeneratorHandler.cpp
  src/import/DanglingLineHandler.cpp
  src/import/LoadHandler.cpp
  src/import/ShuntCompensatorHandler.cpp
  src/import/StaticVarCompensatorHandler.cpp
  src/import/VscConverterStationHandler.cpp
  src/import/LccConverterStationHandler.cpp

  src/import/CurrentLimitsHandler.cpp
  src/import/TapChangerHandler.cpp
  src/import/ReactiveInformationsHandler.cpp
)

add_library(iidm-xml ${IIDM_XML_SOURCES})

target_include_directories(iidm-xml
  PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
)

target_link_libraries(iidm-xml
  iidm
  XMLSAXFormatter${LibXML_LINK_SUFFIX}
  XMLSAXParser${LibXML_LINK_SUFFIX}
)

set_target_properties(iidm-xml
  PROPERTIES
    VERSION ${IIDM_VERSION_STRING}
    SOVERSION ${IIDM_SOVERSION}
    WINDOWS_EXPORT_ALL_SYMBOLS TRUE
)

install(TARGETS iidm-xml EXPORT libiidm-xml-config
  PUBLIC_HEADER DESTINATION ${LibIIDM_INSTALL_INCLUDE}
  ARCHIVE DESTINATION ${LibIIDM_INSTALL_LIBRARIES}
  LIBRARY DESTINATION ${LibIIDM_INSTALL_LIBRARIES}
  RUNTIME DESTINATION ${LibIIDM_INSTALL_BINARIES}
  RESOURCE DESTINATION ${IIDM_SHARE_PATH}
  COMPONENT iidm-xml
)

# installed config file for find_package
install(EXPORT libiidm-xml-config
  DESTINATION ${LibIIDM_INSTALL_CMAKE}
  FILE libiidm-xml-targets.cmake
  COMPONENT iidm-xml
)

include(CMakePackageConfigHelpers)
configure_package_config_file(libiidm-xml-config.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/libiidm-xml-config.cmake
  INSTALL_DESTINATION ${LibIIDM_INSTALL_CMAKE}
  PATH_VARS
    LibIIDM_INSTALL_INCLUDE
    LibIIDM_INSTALL_LIBRARIES
    LibIIDM_INSTALL_BINARIES
  NO_CHECK_REQUIRED_COMPONENTS_MACRO
)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/libiidm-xml-config.cmake
  DESTINATION ${LibIIDM_INSTALL_CMAKE}
  COMPONENT iidm-xml
)


install(DIRECTORY include/IIDM
  DESTINATION ${LibIIDM_INSTALL_INCLUDE}
  COMPONENT iidm-xml
  FILES_MATCHING PATTERN "*.h"
)

#install(DIRECTORY ...) append the last part of input paths to the destination path. Adding a "/" prevents this.
install(DIRECTORY share/
  DESTINATION ${IIDM_SHARE_PATH}
  COMPONENT iidm-xml
)

add_custom_target(install-xml
  DEPENDS iidm-xml
  COMMAND
    "${CMAKE_COMMAND}" -DCMAKE_INSTALL_COMPONENT=iidm-xml -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
)


add_custom_target(extensions-xml)
add_dependencies(extensions-xml extensions)

add_custom_target(install-extensions-xml DEPENDS install-extensions)

if( BUILD_SAMPLES )
  add_library(iidm-xml-testing ${IIDM_XML_SOURCES})

  target_compile_definitions(iidm-xml-testing PRIVATE IIDM_TESTING)

  target_include_directories(iidm-xml-testing
    PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  )

  target_link_libraries(iidm-xml-testing
    iidm
    XMLSAXFormatter${LibXML_LINK_SUFFIX}
    XMLSAXParser${LibXML_LINK_SUFFIX}
  )

  set_target_properties(iidm-xml-testing
    PROPERTIES
      VERSION ${IIDM_VERSION_STRING}
      SOVERSION ${IIDM_VERSION_MAJOR}
      WINDOWS_EXPORT_ALL_SYMBOLS TRUE
  )

  add_custom_command(TARGET iidm-xml-testing PRE_BUILD
    COMMAND ${CMAKE_COMMAND} -E
      copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/share/xsd ${CMAKE_BINARY_DIR}/${IIDM_SHARE_PATH}/xsd
    COMMENT "copying xsd to test directory"
    VERBATIM
  )

  add_subdirectory(samples)
endif()
