# Copyright (c) 2013-2019, RTE (http://www.rte-france.com)
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Libzip, a library to handle zip archives.

set(libzip_SOURCES
    ZipEntry.cpp
    ZipException.cpp
    ZipFileFactory.cpp
    ZipFile.cpp
    ZipFlattenPolicy.cpp
    ZipInputStream.cpp
    ZipOutputStream.cpp)

include(LibZipVersion)
GetLibZipVersion()

unset(LibArchive_INCLUDE_DIR CACHE)
unset(LibArchive_LIBRARY CACHE)
find_package(LibArchive 2.8.0 REQUIRED)

add_library(${CMAKE_PROJECT_NAME} SHARED ${libzip_SOURCES})
target_include_directories(${CMAKE_PROJECT_NAME} PUBLIC ${LibArchive_INCLUDE_DIRS})

set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES SOVERSION ${LibZIP_SOVERSION} VERSION ${LibZIP_VERSION} WINDOWS_EXPORT_ALL_SYMBOLS TRUE)
target_link_libraries(${CMAKE_PROJECT_NAME} ${LibArchive_LIBRARIES})

install(TARGETS ${CMAKE_PROJECT_NAME} RUNTIME DESTINATION ${BIN_INSTALL_DIR} LIBRARY DESTINATION ${LIB_INSTALL_DIR} ARCHIVE DESTINATION ${LIB_INSTALL_DIR} COMPONENT libraries)

install(DIRECTORY ../include/libzip DESTINATION ${INCLUDE_INSTALL_DIR} PATTERN ".svn" EXCLUDE)
