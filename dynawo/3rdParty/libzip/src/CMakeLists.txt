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

if (LIBZIP_BUILD_SHARED)
    unset(LibArchive_INCLUDE_DIR CACHE)
    unset(LibArchive_LIBRARY CACHE)
    find_package(LibArchive 2.8.0 REQUIRED)

    add_library(${CMAKE_PROJECT_NAME} SHARED ${libzip_SOURCES})
    target_include_directories(${CMAKE_PROJECT_NAME} PUBLIC ${LibArchive_INCLUDE_DIRS})

    set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES SOVERSION ${LibZIP_SOVERSION} VERSION ${LibZIP_VERSION} WINDOWS_EXPORT_ALL_SYMBOLS TRUE)
    target_link_libraries(${CMAKE_PROJECT_NAME} ${LibArchive_LIBRARIES})

    install(TARGETS ${CMAKE_PROJECT_NAME} RUNTIME DESTINATION ${BIN_INSTALL_DIR} LIBRARY DESTINATION ${LIB_INSTALL_DIR} ARCHIVE DESTINATION ${LIB_INSTALL_DIR} COMPONENT libraries)
endif ()

if (LIBZIP_BUILD_STATIC)
    if(MSVC)
      set(CMAKE_FIND_LIBRARY_SUFFIXES_bak "${CMAKE_FIND_LIBRARY_SUFFIXES}")
      if(LIBRARY_TYPE STREQUAL "STATIC")
        if(CMAKE_BUILD_TYPE STREQUAL "Debug")
          set(CMAKE_FIND_LIBRARY_SUFFIXES "staticd${CMAKE_FIND_LIBRARY_SUFFIXES_bak}")
        else()
          set(CMAKE_FIND_LIBRARY_SUFFIXES "static${CMAKE_FIND_LIBRARY_SUFFIXES_bak}")
        endif()
      endif()
    endif()
    find_package(ZLIB 1.2.3 REQUIRED)
    set_property(TARGET ZLIB::ZLIB APPEND PROPERTY
      IMPORTED_LOCATION "${ZLIB_LIBRARY}")

    if(MSVC)
      if(LIBRARY_TYPE STREQUAL "STATIC")
        set(CMAKE_FIND_LIBRARY_SUFFIXES "_static${CMAKE_FIND_LIBRARY_SUFFIXES_bak}")
      endif()
    endif()
    find_package(LibArchive 2.8.0 REQUIRED)
    if(MSVC)
      set(CMAKE_FIND_LIBRARY_SUFFIXES "${CMAKE_FIND_LIBRARY_SUFFIXES_bak}")
    endif()

    add_library(${CMAKE_PROJECT_NAME}-static STATIC ${libzip_SOURCES})
    target_include_directories(${CMAKE_PROJECT_NAME}-static PUBLIC ${LibArchive_INCLUDE_DIRS})

    set_target_properties(${CMAKE_PROJECT_NAME}-static PROPERTIES OUTPUT_NAME ${CMAKE_PROJECT_NAME} COMPILE_DEFINITIONS LIBARCHIVE_STATIC)

    target_link_libraries(${CMAKE_PROJECT_NAME}-static ${LibArchive_LIBRARIES} ${ZLIB_LIBRARIES})

    install(TARGETS ${CMAKE_PROJECT_NAME}-static ARCHIVE DESTINATION ${LIB_INSTALL_DIR} COMPONENT libraries)
endif ()

install(DIRECTORY ../include/libzip DESTINATION ${INCLUDE_INSTALL_DIR} PATTERN ".svn" EXCLUDE)
