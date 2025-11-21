# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

# Minimum required (for ExternalProject_Add)
cmake_minimum_required(VERSION 3.12 FATAL_ERROR)

if (POLICY CMP0167)
  cmake_policy(SET CMP0167 NEW)
endif()

set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel (CMake defaults)")
set(BOOST_ROOT_DEFAULT "true" CACHE STRING "Enable to find boost in system path or not.")
set(FORCE_CXX11_ABI OFF CACHE BOOL "Choose either ON or OFF.")

if(BOOST_ROOT_DEFAULT STREQUAL "true")
  set(Boost_NO_SYSTEM_PATHS FALSE)
else()
  set(Boost_NO_SYSTEM_PATHS TRUE)
endif()

if(NOT DEFINED OPENMODELICA_INSTALL)
  message(FATAL_ERROR "You must define OPENMODELICA_INSTALL variable.")
endif()
set(OPENMODELICA_INSTALL CACHE PATH "Path where OpenModelica (patched for Dynawo) will be installed")

if(NOT DEFINED OPENMODELICA_SRC)
  message(FATAL_ERROR "You must define OPENMODELICA_SRC variable.")
endif()
set(OPENMODELICA_SRC CACHE PATH "Path where OpenModelica sources will be cloned")

if(POLICY CMP0074)
  cmake_policy(SET CMP0074 NEW)
endif()

# Add custom cmake modules to the path
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../cmake")

project(Dynawo-3rd-parties CXX C) # language is required to identify compiler ID and version

if(MSVC)
  if(NOT DEFINED OMDEV_HOME)
    message(FATAL_ERROR "You must define OMDEV_HOME variable.")
  endif()
  set(OMDEV_HOME CACHE PATH "Path where an OMDev installation will be done (only for Windows)")
endif()

set(DOWNLOAD_DIR ${CMAKE_INSTALL_PREFIX}/src CACHE PATH "Directory where 3rd parties are downloaded.")
set(TMP_DIR ${CMAKE_INSTALL_PREFIX}/tmp CACHE PATH "Directory where 3rd parties temporary files are created.")

set(BOOST_ROOT        CACHE PATH "Path where a Boost installation already exists")
set(GTEST_ROOT        CACHE PATH "Path where a GoogleTest installation already exists")
set(LIBARCHIVE_HOME   CACHE PATH "Path where a LibArchive installation already exists")
set(ZLIB_ROOT         CACHE PATH "Path where a ZLib installation already exists")
set(LIBXML2_HOME      CACHE PATH "Path where a libxml2 installation already exists")

if(NOT MSVC)
  set(CXX_STDFLAG "-std=c++11")
endif()

# Try to get the number of processors (core/thread)
include(${CMAKE_CURRENT_SOURCE_DIR}/../cmake/CPUCount.cmake)
if(NOT DEFINED CPU_COUNT)
  message(FATAL_ERROR "CPUCount.cmake: file not found.")
endif()

include(ExternalProject)

# Sources of external projects
set(zlib_version_required 1.2.3)
set(zlib_version         1.2.11)
set(zlib_name            zlib-${zlib_version}.tar.gz)
if(DEFINED ENV{DYNAWO_ZLIB_DOWNLOAD_URL})
  set(zlib_prefix_url $ENV{DYNAWO_ZLIB_DOWNLOAD_URL})
else()
  set(zlib_prefix_url https://sourceforge.net/projects/libpng/files/zlib)
endif()
set(zlib_url             ${zlib_prefix_url}/${zlib_version}/${zlib_name})
set(zlib_md5             1C9F62F0778697A09D36121EAD88E08E)

set(boost_version        1.70.0)
set(boost_md5            fea771fe8176828fabf9c09242ee8c26)
if('${CMAKE_CXX_COMPILER_ID}' STREQUAL 'GNU')
  if (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 11)
    set(boost_version 1.73.0)
    set(boost_md5          4036cd27ef7548b8d29c30ea10956196)
  endif()
endif()

if(APPLE)
  set(boost_version 1.83.0)
  set(boost_md5          e9d8ddf56ec35aa926b3fae04d22b8ad)
endif()

if(MSVC)
  if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 19.44)
    set(boost_version 1.78.0)
    set(boost_md5          c2f6428ac52b0e5a3c9b2e1d8cc832b5)
  endif()
endif()

string(REPLACE "." "_" boost_version_ ${boost_version})
set(boost_name           boost_${boost_version_}.tar.gz)
if(DEFINED ENV{DYNAWO_BOOST_DOWNLOAD_URL})
  set(boost_prefix_url $ENV{DYNAWO_BOOST_DOWNLOAD_URL})
else()
  set(boost_prefix_url https://sourceforge.net/projects/boost/files/boost)
endif()

set(boost_url            ${boost_prefix_url}/${boost_version}/${boost_name})

set(googletest_version   1.8.1)
set(googletest_name      googletest-release-${googletest_version}.tar.gz)
if(DEFINED ENV{DYNAWO_GOOGLETEST_DOWNLOAD_URL})
  set(googletest_prefix_url $ENV{DYNAWO_GOOGLETEST_DOWNLOAD_URL})
else()
  set(googletest_prefix_url https://github.com/google/googletest/archive)
endif()
set(googletest_url       ${googletest_prefix_url}/release-${googletest_version}.tar.gz)
set(googletest_md5       2E6FBEB6A91310A16EFE181886C59596)

set(libarchive_version_required 2.8.0)
set(libarchive_version        3.5.1)
set(libarchive_md5            742a47936955f280b9dc712ac544f8ec)
set(libarchive_name      libarchive-${libarchive_version}.tar.gz)
if(DEFINED ENV{DYNAWO_LIBARCHIVE_DOWNLOAD_URL})
  set(libarchive_prefix_url $ENV{DYNAWO_LIBARCHIVE_DOWNLOAD_URL})
else()
  set(libarchive_prefix_url https://github.com/libarchive/libarchive/archive)
endif()
set(libarchive_url       ${libarchive_prefix_url}/v${libarchive_version}.tar.gz)

set(adept_version        2.1.1)
set(adept_name           adept-${adept_version}.tar.gz)
if(DEFINED ENV{DYNAWO_ADEPT_DOWNLOAD_URL})
  set(adept_prefix_url $ENV{DYNAWO_ADEPT_DOWNLOAD_URL})
else()
  set(adept_prefix_url http://www.met.reading.ac.uk/clouds/adept)
endif()
set(adept_url            ${adept_prefix_url}/${adept_name})
set(adept_md5            327306b9cc14a82df15c54c498cb0480)

set(suitesparse_version  5.10.1)
set(suitesparse_name     SuiteSparse-${suitesparse_version}.tar.gz)
if(DEFINED ENV{DYNAWO_SUITESPARSE_DOWNLOAD_URL})
  set(suitesparse_prefix_url $ENV{DYNAWO_SUITESPARSE_DOWNLOAD_URL})
else()
  set(suitesparse_prefix_url https://github.com/DrTimothyAldenDavis/SuiteSparse/archive)
endif()
set(suitesparse_url      ${suitesparse_prefix_url}/v${suitesparse_version}.tar.gz)
set(suitesparse_md5      68bb912f3cf3d2b01f30ebafef690302)

set(sundials_version     6.3.0)
set(sundials_name        sundials-${sundials_version}.tar.gz)
if(DEFINED ENV{DYNAWO_SUNDIALS_DOWNLOAD_URL})
  set(sundials_prefix_url $ENV{DYNAWO_SUNDIALS_DOWNLOAD_URL})
else()
  set(sundials_prefix_url https://github.com/LLNL/sundials/releases/download)
endif()
set(sundials_url         ${sundials_prefix_url}/v${sundials_version}/${sundials_name})
set(sundials_md5         6be7057c88990021de5b08109eb2f133)

set(omdev_git            https://openmodelica.org/git/OMDev.git)
set(omdev_tag            origin/OM113maintenance)

set(openmodelica_version 1.13.2)
if(DEFINED ENV{DYNAWO_OPENMODELICA_GIT_URL})
  set(openmodelica_prefix_url $ENV{DYNAWO_OPENMODELICA_GIT_URL})
else()
  set(openmodelica_prefix_url https://github.com)
endif()
set(openmodelica_git     ${openmodelica_prefix_url}/OpenModelica/OpenModelica.git)
set(openmodelica_tag     v${openmodelica_version})

set(modelicalib_version  3.2.3)
set(modelicalib_name     ModelicaStandardLibrary-${modelicalib_version}.tar.gz)
if(DEFINED ENV{DYNAWO_MODELICALIB_DOWNLOAD_URL})
  set(modelicalib_prefix_url $ENV{DYNAWO_MODELICALIB_DOWNLOAD_URL})
else()
  set(modelicalib_prefix_url https://github.com/modelica/ModelicaStandardLibrary/archive)
endif()
set(modelicalib_url      ${modelicalib_prefix_url}/v${modelicalib_version}.tar.gz)
set(modelicalib_md5      3ccc266305a0eeab365932688bce011f)

# Get patch command for a project
# There may be a common patch and/or a patch for a specific compiler
message("Compiler patch subdirectory: ${CMAKE_CXX_COMPILER_ID}")
function(GetPatchCommand projectName)
  if(UNIX)
    set(nullFile /dev/null)
  else()
    set(nullFile nul)
  endif()
  set(commonPatchFile "${CMAKE_CURRENT_SOURCE_DIR}/${projectName}/patch/common/${projectName}.patch")
  if(EXISTS ${commonPatchFile})
    if(UNIX)
      set(commonPatchCommand patch -p1 --forward --no-backup-if-mismatch -r ${nullFile} -i ${commonPatchFile} || echo -n)
    else()
      set(commonPatchCommand git apply -p1 ${commonPatchFile} --reverse --check 2> ${nullFile} || git apply --ignore-whitespace --whitespace=nowarn -p1 ${commonPatchFile})
    endif()
  endif()
  set(compilerPatchFile "${CMAKE_CURRENT_SOURCE_DIR}/${projectName}/patch/${CMAKE_CXX_COMPILER_ID}/${projectName}.patch")
  if(EXISTS ${compilerPatchFile})
    if(UNIX)
      set(compilerPatchCommand patch -p1 --forward --no-backup-if-mismatch -r ${nullFile} -i ${compilerPatchFile} || echo -n)
    else()
      set(compilerPatchCommand git apply -p1 ${compilerPatchFile} --reverse --check 2> ${nullFile} || git apply --ignore-whitespace --whitespace=nowarn -p1 ${compilerPatchFile})
    endif()
  endif()
  if(DEFINED commonPatchCommand)
    set(${projectName}_patch_common ${commonPatchCommand} PARENT_SCOPE)
  else()
    set(${projectName}_patch_common ${CMAKE_COMMAND} -E echo No common patch. PARENT_SCOPE)
  endif()
  if(DEFINED compilerPatchCommand)
    set(${projectName}_patch_compiler ${compilerPatchCommand} PARENT_SCOPE)
  else()
    set(${projectName}_patch_compiler ${CMAKE_COMMAND} -E echo No compiler patch. PARENT_SCOPE)
  endif()
endfunction()

# Build system thirparties if not available
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
  # clear cache variables to force find
  unset(GTEST_INCLUDE_DIR CACHE)
  unset(GTEST_LIBRARY CACHE)
  unset(GTEST_MAIN_LIBRARY CACHE)

  find_package(GTest ${googletest_version} QUIET)

  if(GTEST_FOUND)
    add_custom_target(googletest)
  else()
    ExternalProject_Add(googletest
      INSTALL_DIR         ${CMAKE_INSTALL_PREFIX}/googletest
      DOWNLOAD_DIR        ${CMAKE_CURRENT_SOURCE_DIR}/googletest
      TMP_DIR             ${TMP_DIR}
      STAMP_DIR           ${DOWNLOAD_DIR}/googletest-stamp-release
      SOURCE_DIR          ${DOWNLOAD_DIR}/googletest-src-release
      BINARY_DIR          ${DOWNLOAD_DIR}/googletest-build-release
      DOWNLOAD_NAME       ${googletest_name}
      URL                 ${googletest_url}
      URL_MD5             ${googletest_md5}

      CMAKE_CACHE_ARGS    -DCMAKE_CXX_COMPILER:STRING=${CMAKE_CXX_COMPILER}

      CMAKE_ARGS          -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
                          -DCMAKE_BUILD_TYPE:STRING=Release
                          -DBUILD_SHARED_LIBS=ON
                          -Dgtest_force_shared_crt:BOOL=ON
                          -DCMAKE_POLICY_VERSION_MINIMUM=3.5
                          -DCMAKE_MACOSX_RPATH=True
                          -DCMAKE_SKIP_BUILD_RPATH=False
                          -DCMAKE_BUILD_WITH_INSTALL_RPATH=False
                          -DCMAKE_INSTALL_RPATH=<INSTALL_DIR>/lib
                          -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=True
    )
    ExternalProject_Add(googletest_debug
            INSTALL_DIR         ${CMAKE_INSTALL_PREFIX}/googletest
            DOWNLOAD_DIR        ${CMAKE_CURRENT_SOURCE_DIR}/googletest
            TMP_DIR             ${TMP_DIR}
            STAMP_DIR           ${DOWNLOAD_DIR}/googletest-stamp-debug
            SOURCE_DIR          ${DOWNLOAD_DIR}/googletest-src-debug
            BINARY_DIR          ${DOWNLOAD_DIR}/googletest-build-debug
            DOWNLOAD_NAME       ${googletest_name}
            URL                 ${googletest_url}
            URL_MD5             ${googletest_md5}

            CMAKE_CACHE_ARGS    -DCMAKE_CXX_COMPILER:STRING=${CMAKE_CXX_COMPILER}
                                -DCMAKE_CXX_FLAGS_INIT:STRING=$<$<CONFIG:Debug>:-O0>

            CMAKE_ARGS          -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
                                -DCMAKE_BUILD_TYPE:STRING=Debug
                                -DBUILD_SHARED_LIBS=ON
                                -Dgtest_force_shared_crt:BOOL=ON
                                -DCMAKE_POLICY_VERSION_MINIMUM=3.5
                                -DCMAKE_MACOSX_RPATH=True
                                -DCMAKE_SKIP_BUILD_RPATH=False
                                -DCMAKE_BUILD_WITH_INSTALL_RPATH=False
                                -DCMAKE_INSTALL_RPATH=<INSTALL_DIR>/lib
                                -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=True
    )
    ExternalProject_Get_Property(googletest install_dir)
    set(GTEST_ROOT ${install_dir} CACHE PATH "Path to GoogleTest installation" FORCE)
  endif()
else()
  add_custom_target(googletest)
endif()

# clear cache variables to force find
unset(LibArchive_INCLUDE_DIR CACHE)
unset(LibArchive_LIBRARY CACHE)

# FindLibArchive.cmake doesn't know a LIBARCHIVE_HOME
list(APPEND CMAKE_PREFIX_PATH ${LIBARCHIVE_HOME})

# ...nor search for the static lib
set(CMAKE_FIND_LIBRARY_SUFFIXES_bak "${CMAKE_FIND_LIBRARY_SUFFIXES}")
find_package(LibArchive ${libarchive_version_required} QUIET)
set(CMAKE_FIND_LIBRARY_SUFFIXES "${CMAKE_FIND_LIBRARY_SUFFIXES_bak}")

if(LibArchive_FOUND)
  add_custom_target(libarchive)
else()
  # clear cache variables to force find
  unset(ZLIB_INCLUDE_DIR CACHE)
  unset(ZLIB_LIBRARY_DEBUG CACHE)
  unset(ZLIB_LIBRARY_RELEASE CACHE)

  GetPatchCommand(zlib)
  find_package(ZLIB ${zlib_required_version} QUIET)
  set(CMAKE_FIND_LIBRARY_SUFFIXES "${CMAKE_FIND_LIBRARY_SUFFIXES_bak}")

  if(ZLIB_FOUND)
    add_custom_target(zlib)
  else()
    ExternalProject_Add(zlib
      INSTALL_DIR         ${CMAKE_INSTALL_PREFIX}/zlib
      DOWNLOAD_DIR        ${CMAKE_CURRENT_SOURCE_DIR}/zlib
      TMP_DIR             ${TMP_DIR}
      STAMP_DIR           ${DOWNLOAD_DIR}/zlib-stamp
      SOURCE_DIR          ${DOWNLOAD_DIR}/zlib
      BINARY_DIR          ${DOWNLOAD_DIR}/zlib-build
      PATCH_COMMAND       ${zlib_patch_common}
      COMMAND             ${zlib_patch_compiler}
      URL                 ${zlib_url}
      URL_MD5             ${zlib_md5}

      CMAKE_CACHE_ARGS    -DCMAKE_C_COMPILER:STRING=${CMAKE_C_COMPILER}
                          -DCMAKE_C_FLAGS_INIT:STRING=$<$<BOOL:${UNIX}>:-fPIC>\ $<$<CONFIG:Debug>:-O0>

      CMAKE_ARGS          -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
                          -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
                          -DBUILD_SHARED_LIBS:BOOL=ON # always build shared, required for WIN32 compilation
    )
    ExternalProject_Get_Property(zlib install_dir)
    set(ZLIB_ROOT ${install_dir} CACHE PATH "Path to ZLib installation" FORCE)
  endif()

  GetPatchCommand(libarchive)
  ExternalProject_Add(libarchive
    DEPENDS             zlib
    INSTALL_DIR         ${CMAKE_INSTALL_PREFIX}/libarchive
    DOWNLOAD_DIR        ${CMAKE_CURRENT_SOURCE_DIR}/libarchive
    TMP_DIR             ${TMP_DIR}
    STAMP_DIR           ${DOWNLOAD_DIR}/libarchive-stamp
    SOURCE_DIR          ${DOWNLOAD_DIR}/libarchive
    BINARY_DIR          ${DOWNLOAD_DIR}/libarchive-build
    DOWNLOAD_NAME       ${libarchive_name}
    URL                 ${libarchive_url}
    URL_MD5             ${libarchive_md5}
    PATCH_COMMAND       ${libarchive_patch_common}
    COMMAND             ${libarchive_patch_compiler}

    CMAKE_CACHE_ARGS    -DCMAKE_C_COMPILER:STRING=${CMAKE_C_COMPILER}
                        "-DCMAKE_C_FLAGS_INIT:STRING=$<$<BOOL:${UNIX}>:-w -fPIC -O3> $<$<CONFIG:Debug>:-O0>"

    CMAKE_ARGS          -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
                        -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
                        -DBUILD_SHARED_LIBS:BOOL=ON
                        -DZLIB_ROOT:PATH=${ZLIB_ROOT}
                        -DENABLE_WERROR=OFF
                        -DENABLE_TEST:BOOL=OFF
                        -Wno-dev
                        -DENABLE_NETTLE=OFF
                        -DENABLE_OPENSSL=OFF
                        -DENABLE_ZSTD=OFF
                        -DENABLE_LZ4=OFF
                        -DENABLE_LZO=OFF
                        -DENABLE_LZMA=OFF
                        -DENABLE_BZip2=OFF
                        -DENABLE_LIBXML2=OFF
                        -DENABLE_EXPAT=OFF
                        -DENABLE_PCREPOSIX=OFF
                        -DENABLE_CNG=OFF
                        -DCMAKE_POLICY_VERSION_MINIMUM=3.5
                        -DCMAKE_MACOSX_RPATH=True
                        -DCMAKE_SKIP_BUILD_RPATH=False
                        -DCMAKE_BUILD_WITH_INSTALL_RPATH=False
                        -DCMAKE_INSTALL_RPATH=<INSTALL_DIR>/lib
                        -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=True
  )
  ExternalProject_Get_Property(libarchive install_dir)
  if(APPLE)
    ExternalProject_Add_Step(libarchive install-macos
      DEPENDEES install
      COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/libarchive/rpath.sh ${CMAKE_INSTALL_PREFIX}/libarchive
    )
  endif()
  set(LIBARCHIVE_HOME ${install_dir} CACHE PATH "Path to LibArchive installation" FORCE)
endif()

# clear cache variables to force find
unset(Boost_DIR CACHE)
unset(Boost_INCLUDE_DIR CACHE)

set(BUILD_SHARED_LIBS ON)
set(Boost_USE_STATIC_RUNTIME False)
# find Boost in two steps to avoid warnings 'Imported targets and dependency information not available for Boost version'
find_package(Boost ${boost_version} QUIET)

if(Boost_FOUND)
  find_package(Boost ${boost_version} QUIET
    COMPONENTS date_time filesystem program_options serialization system log iostreams thread regex chrono atomic
  )
endif()

if(MSVC)
  if(CMAKE_CXX_COMPILER_VERSION EQUAL 19.0.23026.0)
    GetPatchCommand(boost)
  else()
    set(boost_patch_compiler ${CMAKE_COMMAND} -E echo No compiler patch.)
  endif()
endif()
if(Boost_FOUND)
  add_custom_target(boost)
else()
  if(MSVC)
    ExternalProject_Add(boost
      INSTALL_DIR         ${CMAKE_INSTALL_PREFIX}/boost
      DOWNLOAD_DIR        ${CMAKE_CURRENT_SOURCE_DIR}/boost
      TMP_DIR             ${TMP_DIR}
      STAMP_DIR           ${DOWNLOAD_DIR}/boost-stamp
      SOURCE_DIR          ${DOWNLOAD_DIR}/boost
      URL                 ${boost_url}
      URL_MD5             ${boost_md5}
      PATCH_COMMAND       ${boost_patch_compiler}
      BUILD_IN_SOURCE     1

      CONFIGURE_COMMAND   <SOURCE_DIR>/bootstrap.bat msvc

      BUILD_COMMAND       <SOURCE_DIR>/b2
                          -j${CPU_COUNT}
                          -sNO_BZIP2=1
                          install
                          --prefix=<INSTALL_DIR>
                          --libdir=<INSTALL_DIR>/bin
                          --disable-icu
                          --with-date_time
                          --with-filesystem
                          --with-program_options
                          --with-serialization
                          --with-system
                          --with-log
                          --with-iostreams
                          --layout=system
                          architecture=x86
                          address-model=64
                          variant=$<IF:$<CONFIG:Debug>,debug,release>
                          link=shared
                          runtime-link=shared
                          stage

      INSTALL_COMMAND     ""
    )

  else()
    set(TmpVar "--with-libraries=date_time,filesystem,program_options,serialization,system,log,iostreams")

    ExternalProject_Add(boost
      INSTALL_DIR         ${CMAKE_INSTALL_PREFIX}/boost
      DOWNLOAD_DIR        ${CMAKE_CURRENT_SOURCE_DIR}/boost
      TMP_DIR             ${TMP_DIR}
      STAMP_DIR           ${DOWNLOAD_DIR}/boost-stamp
      SOURCE_DIR          ${DOWNLOAD_DIR}/boost
      URL                 ${boost_url}
      URL_MD5             ${boost_md5}
      BUILD_IN_SOURCE     1

      CONFIGURE_COMMAND   <SOURCE_DIR>/bootstrap.sh
                          --without-icu
                          ${TmpVar}

      BUILD_COMMAND       <SOURCE_DIR>/b2
                          -j${CPU_COUNT}
                          -sNO_BZIP2=1
                          cxxflags=-fPIC
                          $<$<BOOL:${FORCE_CXX11_ABI}>:cxxflags=-D_GLIBCXX_USE_CXX11_ABI=1>
                          install
                          --prefix=<INSTALL_DIR>
                          $<$<BOOL:${APPLE}>:toolset=clang>
                          --disable-icu variant=$<IF:$<CONFIG:Debug>,debug,release>
                          link=shared
                          stage

      INSTALL_COMMAND     ""
    )
    unset(TmpVar)
    if(APPLE)
      ExternalProject_Add_Step(boost install-macos
        DEPENDEES install
        COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/boost/rpath.sh ${CMAKE_INSTALL_PREFIX}/boost
      )
    endif()
  endif()
  ExternalProject_Get_Property(boost install_dir)
  set(BOOST_ROOT ${install_dir} CACHE PATH "Path to Boost installation" FORCE)
endif()

# Build COTS thirdparties
set(ADEPT_HOME ${CMAKE_INSTALL_PREFIX}/adept)
find_package(Adept QUIET)
unset(ADEPT_HOME)

GetPatchCommand(adept)
if(Adept_FOUND)
  add_custom_target(adept)
  set(ADEPT_HOME ${CMAKE_INSTALL_PREFIX}/adept)
else()
  if(MSVC OR APPLE)
    ExternalProject_Add(adept
      INSTALL_DIR         ${CMAKE_INSTALL_PREFIX}/adept
      DOWNLOAD_DIR        ${CMAKE_CURRENT_SOURCE_DIR}/adept
      TMP_DIR             ${TMP_DIR}
      STAMP_DIR           ${DOWNLOAD_DIR}/adept-stamp
      SOURCE_DIR          ${DOWNLOAD_DIR}/adept
      BINARY_DIR          ${DOWNLOAD_DIR}/adept-build
      URL                 ${adept_url}
      URL_MD5             ${adept_md5}
      PATCH_COMMAND       ${adept_patch_common}
      COMMAND             ${adept_patch_compiler}

      CMAKE_CACHE_ARGS    -DCMAKE_CXX_COMPILER:STRING=${CMAKE_CXX_COMPILER}
                          -DCMAKE_CXX_FLAGS_INIT:STRING=${CXX_STDFLAG}

      CMAKE_ARGS          -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
                          -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
                          -DBUILD_SHARED_LIBS=ON
                          -DCMAKE_MACOSX_RPATH=True
                          -DCMAKE_SKIP_BUILD_RPATH=False
                          -DCMAKE_BUILD_WITH_INSTALL_RPATH=False
                          -DCMAKE_INSTALL_RPATH=<INSTALL_DIR>/lib
                          -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=True
                          -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    )
  else()
    ExternalProject_Add(adept
      INSTALL_DIR         ${CMAKE_INSTALL_PREFIX}/adept
      DOWNLOAD_DIR        ${CMAKE_CURRENT_SOURCE_DIR}/adept
      TMP_DIR             ${TMP_DIR}
      STAMP_DIR           ${DOWNLOAD_DIR}/adept-stamp
      SOURCE_DIR          ${DOWNLOAD_DIR}/adept
      URL                 ${adept_url}
      URL_MD5             ${adept_md5}
      PATCH_COMMAND       ${adept_patch_common}
      COMMAND             ${adept_patch_compiler}
      BUILD_IN_SOURCE     1

      CONFIGURE_COMMAND   <SOURCE_DIR>/configure
                          "CXX=${CMAKE_CXX_COMPILER}"
                          "CXXFLAGS=${CXX_STDFLAG} -fPIC $<IF:$<CONFIG:Release>,-O3,-O0> $<$<BOOL:${FORCE_CXX11_ABI}>:-D_GLIBCXX_USE_CXX11_ABI=1>"
                          --prefix=<INSTALL_DIR>
                          --disable-static
                          --enable-shared
                          --disable-openmp
                          --without-blas
                          --without-lapack
    )
  endif()
  ExternalProject_Get_Property(adept install_dir)
  set(ADEPT_HOME ${install_dir})
endif()

set(SUITESPARSE_HOME ${CMAKE_INSTALL_PREFIX}/suitesparse)
find_package(SuiteSparse QUIET)
unset(SUITESPARSE_HOME)

GetPatchCommand(suitesparse)
if(SuiteSparse_FOUND)
  add_custom_target(suitesparse)
  set(SUITESPARSE_HOME ${CMAKE_INSTALL_PREFIX}/suitesparse)
else()
  ExternalProject_Add(suitesparse
    INSTALL_DIR         ${CMAKE_INSTALL_PREFIX}/suitesparse
    DOWNLOAD_DIR        ${CMAKE_CURRENT_SOURCE_DIR}/suitesparse
    TMP_DIR             ${TMP_DIR}
    STAMP_DIR           ${DOWNLOAD_DIR}/suitesparse-stamp
    SOURCE_DIR          ${DOWNLOAD_DIR}/suitesparse
    BINARY_DIR          ${DOWNLOAD_DIR}/suitesparse-build
    DOWNLOAD_NAME       ${suitesparse_name}
    URL                 ${suitesparse_url}
    URL_MD5             ${suitesparse_md5}
    PATCH_COMMAND       ${suitesparse_patch_common}
    COMMAND             ${suitesparse_patch_compiler}

    CMAKE_CACHE_ARGS    -DCMAKE_C_COMPILER:STRING=${CMAKE_C_COMPILER}
                        -DCMAKE_C_FLAGS_INIT:STRING=$<$<CONFIG:Debug>:-O0>

    CMAKE_ARGS          -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
                        -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
                        -DBUILD_SHARED_LIBS=ON
                        -DCMAKE_POLICY_VERSION_MINIMUM=3.5
                        -DCMAKE_MACOSX_RPATH=True
                        -DCMAKE_SKIP_BUILD_RPATH=False
                        -DCMAKE_BUILD_WITH_INSTALL_RPATH=False
                        -DCMAKE_INSTALL_RPATH=<INSTALL_DIR>/lib
                        -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=True
  )
  ExternalProject_Get_Property(suitesparse install_dir)
  set(SUITESPARSE_HOME ${install_dir})
endif()

set(SUNDIALS_HOME ${CMAKE_INSTALL_PREFIX}/sundials)
find_package(Sundials QUIET)
unset(SUNDIALS_HOME)

GetPatchCommand(sundials)
if(Sundials_FOUND)
  add_custom_target(sundials DEPENDS suitesparse)
  set(SUNDIALS_HOME ${CMAKE_INSTALL_PREFIX}/sundials)
else()
  ExternalProject_Add(sundials
    DEPENDS             suitesparse
    INSTALL_DIR         ${CMAKE_INSTALL_PREFIX}/sundials
    DOWNLOAD_DIR        ${CMAKE_CURRENT_SOURCE_DIR}/sundials
    STAMP_DIR           ${DOWNLOAD_DIR}/sundials-stamp
    SOURCE_DIR          ${DOWNLOAD_DIR}/sundials
    BINARY_DIR          ${DOWNLOAD_DIR}/sundials-build
    TMP_DIR             ${TMP_DIR}
    URL                 ${sundials_url}
    URL_MD5             ${sundials_md5}
    PATCH_COMMAND       ${sundials_patch_common}
    COMMAND             ${sundials_patch_compiler}

    # workaround on Linux: add -lm to check correctly that KLU is functional
    CMAKE_CACHE_ARGS    -DCMAKE_C_COMPILER:STRING=${CMAKE_C_COMPILER}
                        -DCMAKE_C_FLAGS_INIT:STRING=$<$<BOOL:${UNIX}>:-lm>\ $<$<CONFIG:Debug>:-O0>
                        -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON

    CMAKE_ARGS          -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
                        -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
                        -DBUILD_SHARED_LIBS:BOOL=ON # always in shared
                        -DBUILD_STATIC_LIBS:BOOL=OFF
                        -DEXAMPLES_INSTALL:BOOL=OFF
                        -DEXAMPLES_ENABLE_C:BOOL=OFF
                        -DBUILD_CVODES:BOOL=OFF
                        -DBUILD_CVODE:BOOL=OFF
                        -DBUILD_ARKODE:BOOL=OFF
                        -DBUILD_IDAS:BOOL=OFF
                        -DENABLE_KLU:BOOL=ON
                        -DKLU_INCLUDE_DIR:PATH=${SUITESPARSE_HOME}/include
                        -DKLU_LIBRARY_DIR:PATH=${SUITESPARSE_HOME}/lib
                        $<$<BOOL:${MSVC}>:-DCMAKE_INSTALL_LIBDIR=bin>
                        -DCMAKE_POLICY_VERSION_MINIMUM=3.5
                        -DCMAKE_MACOSX_RPATH=True
                        -DCMAKE_SKIP_BUILD_RPATH=False
                        -DCMAKE_BUILD_WITH_INSTALL_RPATH=False
                        -DCMAKE_INSTALL_RPATH=<INSTALL_DIR>/lib
                        -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=True
  )
  ExternalProject_Get_Property(sundials install_dir)
  if(APPLE)
    ExternalProject_Add_Step(sundials install-macos
      DEPENDEES install
      COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/sundials/rpath.sh ${CMAKE_INSTALL_PREFIX}/sundials
    )
  endif()
  set(SUNDIALS_HOME ${install_dir})
endif()

# clear cache variables to force find
unset(OMCompiler CACHE)
unset(OMDevPackage CACHE)

if(NOT APPLE)
  find_program(OMCompiler omcDynawo${CMAKE_EXECUTABLE_SUFFIX} PATHS ${OPENMODELICA_INSTALL}/bin NO_DEFAULT_PATH)

  if(NOT OMCompiler)
    GetPatchCommand(openmodelica)

    if(MSVC)
      find_path(OMDevPackage SETUP_OMDEV.bat PATHS ${OMDEV_HOME} NO_DEFAULT_PATH)
      if(NOT OMDevPackage)
        ExternalProject_Add(omdev
          DOWNLOAD_DIR        ${DOWNLOAD_DIR}
          SOURCE_DIR          ${OMDEV_HOME}
          TMP_DIR             ${TMP_DIR}
          STAMP_DIR           ${DOWNLOAD_DIR}/omdev-stamp
          GIT_REPOSITORY      ${omdev_git}
          GIT_TAG             ${omdev_tag}
          GIT_SHALLOW         1
          UPDATE_DISCONNECTED 1
          BUILD_IN_SOURCE     1
          CONFIGURE_COMMAND   ""
          BUILD_COMMAND       ""
          INSTALL_COMMAND     ""
          )
          ExternalProject_Get_Property(omdev source_dir)
          set(OMDEV_HOME ${source_dir} CACHE PATH "Path to OMDev installation" FORCE)
      else()
        add_custom_target(omdev)
      endif()

      ExternalProject_Add(openmodelica
        DEPENDS             omdev
        INSTALL_DIR         ${OPENMODELICA_INSTALL}
        DOWNLOAD_DIR        ${DOWNLOAD_DIR}
        TMP_DIR             ${TMP_DIR}
        STAMP_DIR           ${DOWNLOAD_DIR}/openmodelica-stamp
        SOURCE_DIR          ${OPENMODELICA_SRC}
        GIT_REPOSITORY      ${openmodelica_git}
        GIT_TAG             ${openmodelica_tag}
        GIT_SUBMODULES      common;libraries;OMCompiler
        GIT_SHALLOW         1
        UPDATE_DISCONNECTED 1
        PATCH_COMMAND       ${openmodelica_patch_common}
        COMMAND             ${openmodelica_patch_compiler}
        BUILD_IN_SOURCE     1

        # the first call to bash initialize the login profile: at this step, errors like permission denied can be ignored !
        CONFIGURE_COMMAND   ${CMAKE_COMMAND} -E env "OMDEV=${OMDEV_HOME}" ${OMDEV_HOME}/SETUP_OMDEV.bat && ${OMDEV_HOME}/tools/msys/usr/bin/bash.exe --login -c exit

        BUILD_COMMAND       ${CMAKE_COMMAND} -E env "OMDEV=${OMDEV_HOME}" "OPENMODELICAHOME=<SOURCE_DIR>" "MSYS2_PATH_TYPE=inherit" "MSYSTEM=MINGW64"
                                                    ${OMDEV_HOME}/tools/msys/usr/bin/bash.exe
                                                    --login -c "cd $OPENMODELICAHOME && make -f Makefile.omdev.mingw -j$CPU_COUNT omc"

        INSTALL_COMMAND     ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/build <INSTALL_DIR>
                COMMAND     ${CMAKE_COMMAND} -E copy_if_different <INSTALL_DIR>/bin/omc.exe <INSTALL_DIR>/bin/omcDynawo.exe
                COMMAND     ${CMAKE_COMMAND} -E copy_directory ${OMDEV_HOME}/tools/msys/mingw64/bin <INSTALL_DIR>/tools/msys/mingw64/bin
                COMMAND     ${CMAKE_COMMAND} -E copy_directory ${OMDEV_HOME}/tools/msys/mingw64/lib/gcc <INSTALL_DIR>/tools/msys/mingw64/lib/gcc
      )
    else()
      ExternalProject_Add(openmodelica
        INSTALL_DIR         ${OPENMODELICA_INSTALL}
        DOWNLOAD_DIR        ${DOWNLOAD_DIR}
        TMP_DIR             ${TMP_DIR}
        STAMP_DIR           ${DOWNLOAD_DIR}/openmodelica-stamp
        SOURCE_DIR          ${OPENMODELICA_SRC}
        DOWNLOAD_COMMAND    ${CMAKE_CURRENT_SOURCE_DIR}/openmodelica/checkoutOpenModelica.sh --openmodelica-version=${openmodelica_version} --openmodelica-dir=${OPENMODELICA_SRC}
        UPDATE_DISCONNECTED 1
        PATCH_COMMAND       ${openmodelica_patch_common}
        COMMAND             ${openmodelica_patch_compiler}
        BUILD_IN_SOURCE     1
        CONFIGURE_COMMAND   make clean > /dev/null 2>&1 || echo "Fisrt checkout, no clean needed."
                  COMMAND   autoreconf || autoupdate && autoreconf --install
                  COMMAND   <SOURCE_DIR>/configure
                            "CC=${CMAKE_C_COMPILER}"
                            "CXX=${CMAKE_CXX_COMPILER}"
                            "CXXFLAGS=-std=c++11"
                            --prefix=<INSTALL_DIR>
                            --disable-modelica3d
                            --disable-omnotebook
                            --disable-omshell-terminal
                            --with-qwt=NO
                            --with-omc=no
        BUILD_COMMAND       make -j ${CPU_COUNT} omc
        INSTALL_COMMAND     make install
                COMMAND     cd <INSTALL_DIR>/bin && ln -s -f omc omcDynawo
      )
    endif()
    ExternalProject_Get_Property(openmodelica install_dir)
    set(OPENMODELICA_INSTALL ${install_dir} CACHE PATH "Path to OpenModelica installation" FORCE)

    ExternalProject_Add(modelicalib
      INSTALL_DIR         ${OPENMODELICA_INSTALL}/lib/omlibrary
      DOWNLOAD_DIR        ${CMAKE_CURRENT_SOURCE_DIR}/modelicalib
      TMP_DIR             ${TMP_DIR}
      STAMP_DIR           ${DOWNLOAD_DIR}/modelicalib-stamp
      SOURCE_DIR          ${DOWNLOAD_DIR}/modelicalib
      DOWNLOAD_NAME       ${modelicalib_name}
      URL                 ${modelicalib_url}
      URL_MD5             ${modelicalib_md5}
      BUILD_IN_SOURCE     1

      CONFIGURE_COMMAND   ""
      BUILD_COMMAND       ""

      INSTALL_COMMAND     ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/Modelica <INSTALL_DIR>/Modelica
              COMMAND     ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/ModelicaServices <INSTALL_DIR>/ModelicaServices
              COMMAND     ${CMAKE_COMMAND} -E copy_if_different <SOURCE_DIR>/Complex.mo <INSTALL_DIR>/Complex.mo
    )
    ExternalProject_Add_StepDependencies(openmodelica install modelicalib)
  else()
    add_custom_target(openmodelica)
  endif()
endif()

set(LIBZIP_HOME ${CMAKE_INSTALL_PREFIX}/libzip)
find_package(libZIP 1.3.0 QUIET)
unset(LIBZIP_HOME)

if(libZIP_FOUND)
  add_custom_target(libzip DEPENDS libarchive boost googletest)
  set(LIBZIP_HOME ${CMAKE_INSTALL_PREFIX}/libzip)
else()
  # Build Dynawo thirdparties
  ExternalProject_Add(libzip
      DEPENDS             libarchive boost googletest
      INSTALL_DIR         ${CMAKE_INSTALL_PREFIX}/libzip
      DOWNLOAD_DIR        ${DOWNLOAD_DIR}
      TMP_DIR             ${TMP_DIR}
      STAMP_DIR           ${DOWNLOAD_DIR}/libzip-stamp
      BINARY_DIR          ${DOWNLOAD_DIR}/libzip-build
      DOWNLOAD_COMMAND    ""
      SOURCE_DIR          ${CMAKE_CURRENT_SOURCE_DIR}/libzip

      CMAKE_CACHE_ARGS    -DCMAKE_CXX_COMPILER:STRING=${CMAKE_CXX_COMPILER}
                          -DCXX11_ENABLED:BOOL=TRUE

      CMAKE_ARGS          -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
                          -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
                          $<$<BOOL:${FORCE_CXX11_ABI}>:-DCMAKE_CXX_FLAGS=-D_GLIBCXX_USE_CXX11_ABI=1>
                          -DLIBZIP_BUILD_TESTS:BOOL=$<BOOL:${LIBZIP_BUILD_TESTS}>
                          -DLIBZIP_BUILD_SAMPLES:BOOL=$<BOOL:${LIBZIP_BUILD_SAMPLES}>
                          -DLIBARCHIVE_HOME:PATH=${LIBARCHIVE_HOME}
                          -DBOOST_ROOT:PATH=${BOOST_ROOT}
                          $<$<BOOL:${MSVC}>:-DBOOST_LIBRARYDIR=${BOOST_ROOT}/bin>
                          -DCMAKE_PREFIX_PATH:PATH=${ZLIB_ROOT}
                          $<$<BOOL:${LIBZIP_BUILD_TESTS}>:-DGTEST_ROOT:PATH=${GTEST_ROOT}>
                          -DCMAKE_POLICY_VERSION_MINIMUM=3.5
  )
  ExternalProject_Get_Property(libzip install_dir)
  set(LIBZIP_HOME ${install_dir})
endif()

set(XERCESC_HOME      CACHE PATH "Path where a Xerces-C installation already exists")     # Start install XERCESC

set(xercesc_version      3.2.2)
set(xercesc_name         xerces-c-${xercesc_version}.tar.gz)
string(REGEX MATCH "([0-9]+)\\.[0-9]+\\.[0-9]+" _ ${xercesc_version})
if(DEFINED ENV{DYNAWO_XERCESC_DOWNLOAD_URL})
  set(xercesc_prefix_url $ENV{DYNAWO_XERCESC_DOWNLOAD_URL})
else()
  set(xercesc_prefix_url http://archive.apache.org/dist/xerces/c)
endif()
set(xercesc_url          ${xercesc_prefix_url}/${CMAKE_MATCH_1}/sources/${xercesc_name})
set(xercesc_md5          7AAC41029B0D7A5EADD31CC975B391C2)

# clear cache variables to force find
unset(XercesC_INCLUDE_DIR CACHE)
unset(XercesC_LIBRARY_DEBUG CACHE)
unset(XercesC_LIBRARY_RELEASE CACHE)

# FindXercesC.cmake doesn't know a XERCESC_HOME
list(APPEND CMAKE_PREFIX_PATH ${XERCESC_HOME})

set(XERCESC_HOME ${CMAKE_INSTALL_PREFIX}/xerces-c)
find_package(XercesC ${xercesc_version} QUIET)
unset(XERCESC_HOME)

GetPatchCommand(xercesc)
if(XercesC_FOUND)
  add_custom_target(xercesc)
  set(XERCESC_HOME ${CMAKE_INSTALL_PREFIX}/xerces-c)
else()
  if(MSVC)
    ExternalProject_Add(xercesc
      INSTALL_DIR         ${CMAKE_INSTALL_PREFIX}/xerces-c
      DOWNLOAD_DIR        ${CMAKE_CURRENT_SOURCE_DIR}/xercesc
      TMP_DIR             ${TMP_DIR}
      STAMP_DIR           ${DOWNLOAD_DIR}/xerces-c-stamp
      SOURCE_DIR          ${DOWNLOAD_DIR}/xerces-c
      BINARY_DIR          ${DOWNLOAD_DIR}/xerces-c-build
      URL                 ${xercesc_url}
      URL_MD5             ${xercesc_md5}
      PATCH_COMMAND       ${xercesc_patch_common}
      COMMAND             ${xercesc_patch_compiler}

      CMAKE_CACHE_ARGS    -DCMAKE_C_COMPILER:STRING=${CMAKE_C_COMPILER}
                          -DCMAKE_CXX_COMPILER:STRING=${CMAKE_CXX_COMPILER}
                          -DCMAKE_CXX_FLAGS_INIT:STRING=/D_CRT_SECURE_NO_WARNINGS\ /D_CRT_NONSTDC_NO_DEPRECATE

      CMAKE_ARGS          -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
                          -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
                          -DBUILD_SHARED_LIBS=ON
                          -Dnetwork:BOOL=OFF
    )
  elseif(APPLE)
      ExternalProject_Add(xercesc
              INSTALL_DIR         ${CMAKE_INSTALL_PREFIX}/xerces-c
              DOWNLOAD_DIR        ${CMAKE_CURRENT_SOURCE_DIR}/xercesc
              TMP_DIR             ${TMP_DIR}
              STAMP_DIR           ${DOWNLOAD_DIR}/xerces-c-stamp
              SOURCE_DIR          ${DOWNLOAD_DIR}/xerces-c
              BINARY_DIR          ${DOWNLOAD_DIR}/xerces-c-build
              URL                 ${xercesc_url}
              URL_MD5             ${xercesc_md5}
              PATCH_COMMAND       ${xercesc_patch_common}
              COMMAND             ${xercesc_patch_compiler}

              CMAKE_CACHE_ARGS    -DCMAKE_C_COMPILER:STRING=${CMAKE_C_COMPILER}
              -DCMAKE_CXX_COMPILER:STRING=${CMAKE_CXX_COMPILER}

              CMAKE_ARGS          -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
                                  -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
                                  -DBUILD_SHARED_LIBS:BOOL=ON
                                  -DCMAKE_MACOSX_RPATH=True
                                  -DCMAKE_SKIP_BUILD_RPATH=False
                                  -DCMAKE_BUILD_WITH_INSTALL_RPATH=False
                                  -DCMAKE_INSTALL_RPATH=<INSTALL_DIR>/lib
                                  -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=True
                                  -Dnetwork:BOOL=OFF
                                  -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      )
      ExternalProject_Add_Step(xercesc install-macos
        DEPENDEES install
        COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/xercesc/rpath.sh ${CMAKE_INSTALL_PREFIX}/xerces-c ${xercesc_version}
      )
  else()
    ExternalProject_Add(xercesc
      INSTALL_DIR         ${CMAKE_INSTALL_PREFIX}/xerces-c
      DOWNLOAD_DIR        ${CMAKE_CURRENT_SOURCE_DIR}/xercesc
      TMP_DIR             ${TMP_DIR}
      STAMP_DIR           ${DOWNLOAD_DIR}/xerces-c-stamp
      SOURCE_DIR          ${DOWNLOAD_DIR}/xerces-c
      URL                 ${xercesc_url}
      URL_MD5             ${xercesc_md5}
      BUILD_IN_SOURCE     1

      CONFIGURE_COMMAND   <SOURCE_DIR>/configure
                          "CC=${CMAKE_C_COMPILER}"
                          "CXX=${CMAKE_CXX_COMPILER}"
                          "CXXFLAGS=${CXX_STDFLAG} $<IF:$<CONFIG:Release>,-O3,-O0>"
                          "CFLAGS=$<IF:$<CONFIG:Release>,-O3,-O0>"
                          --prefix=<INSTALL_DIR>
                          --disable-static
                          --enable-shared
                          --disable-network
                          --without-icu
                          $<IF:$<BOOL:CXX11_ENABLED>,,--disable-xmlch-char16_t>
                          --disable-transcoder-macosunicodeconverter
    )
  endif()
  ExternalProject_Get_Property(xercesc install_dir)
  set(XERCESC_HOME ${install_dir} CACHE PATH "Path to XercesC installation" FORCE)
endif()

set(LIBXML_HOME ${CMAKE_INSTALL_PREFIX}/libxml)
find_package(libXML 0.2.4 QUIET)
unset(LIBXML_HOME)

if(libXML_FOUND)
  add_custom_target(libxml DEPENDS xercesc boost googletest)
  set(LIBXML_HOME ${CMAKE_INSTALL_PREFIX}/libxml)
else()
  ExternalProject_Add(libxml
      DEPENDS             xercesc boost googletest
      INSTALL_DIR         ${CMAKE_INSTALL_PREFIX}/libxml
      DOWNLOAD_DIR        ${DOWNLOAD_DIR}
      TMP_DIR             ${TMP_DIR}
      STAMP_DIR           ${DOWNLOAD_DIR}/libxml-stamp
      BINARY_DIR          ${DOWNLOAD_DIR}/libxml-build
      DOWNLOAD_COMMAND    ""
      SOURCE_DIR          ${CMAKE_CURRENT_SOURCE_DIR}/libxml

      CMAKE_CACHE_ARGS    -DCMAKE_CXX_COMPILER:STRING=${CMAKE_CXX_COMPILER}
                          -DCXX11_ENABLED:BOOL=TRUE

      CMAKE_ARGS          -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
                          $<$<BOOL:${FORCE_CXX11_ABI}>:-DCMAKE_CXX_FLAGS=-D_GLIBCXX_USE_CXX11_ABI=1>
                          -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
                          -DLibXML_BUILD_TESTS:BOOL=$<BOOL:${LIBXML_BUILD_TESTS}>
                          -DLibXML_SAX_BUILD_SAMPLES:BOOL=$<BOOL:${LIBXML_BUILD_SAMPLES}>
                          -DXERCESC_HOME:PATH=${XERCESC_HOME}
                          -DBOOST_ROOT:PATH=${BOOST_ROOT}
                          $<$<BOOL:${MSVC}>:-DBOOST_LIBRARYDIR=${BOOST_ROOT}/bin>
                          $<$<BOOL:${LIBXML_BUILD_TESTS}>:-DGTEST_ROOT:PATH=${GTEST_ROOT}>
                          -DCMAKE_POLICY_VERSION_MINIMUM=3.5
  )
  ExternalProject_Get_Property(libxml install_dir)
  set(LIBXML_HOME ${install_dir})
endif()

include("${CMAKE_CURRENT_SOURCE_DIR}/libxml2/libxml2.cmake")
include("${CMAKE_CURRENT_SOURCE_DIR}/libiidm/libiidm.cmake")
