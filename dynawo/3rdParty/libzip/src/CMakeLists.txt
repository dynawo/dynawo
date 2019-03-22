# Copyright (c) 2013-2019, RTE (http://www.rte-france.com)
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Libzip, a library to handle zip archives.

set(libzip_SOURCES
    ZipEntryImpl.cpp
    ZipExceptionImpl.cpp
    ZipFileFactory.cpp
    ZipFileImpl.cpp
    ZipFlattenPolicy.cpp
    ZipInputStream.cpp
    ZipOutputStream.cpp)

include(LibZipVersion)
GetLibZipVersion()

if (LIBZIP_BUILD_SHARED)
    add_library(${CMAKE_PROJECT_NAME} SHARED ${libzip_SOURCES})
    set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES SOVERSION ${LibZIP_SOVERSION} VERSION ${LibZIP_VERSION})

    target_link_libraries(${CMAKE_PROJECT_NAME} ${LibArchive_LIBRARY})

    install(TARGETS ${CMAKE_PROJECT_NAME} LIBRARY DESTINATION ${LIB_INSTALL_DIR} COMPONENT libraries)
endif ()

if (LIBZIP_BUILD_STATIC)
    add_library(${CMAKE_PROJECT_NAME}-static STATIC ${libzip_SOURCES})
    set_target_properties(${CMAKE_PROJECT_NAME}-static PROPERTIES OUTPUT_NAME ${CMAKE_PROJECT_NAME})

    target_link_libraries(${CMAKE_PROJECT_NAME}-static ${LibArchive_LIBRARY})

    install(TARGETS ${CMAKE_PROJECT_NAME}-static ARCHIVE DESTINATION ${LIB_INSTALL_DIR} COMPONENT libraries)
endif ()

install(DIRECTORY ../include/libzip DESTINATION ${INCLUDE_INSTALL_DIR} PATTERN ".svn" EXCLUDE)
