# Copyright (c) 2026, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

# - Find the external C library of the Modelica Standard Library
# It is built as a static library by the Dynawo 3rd parties (see 3rdParty/modelicaexternalc)
#
#  MODELICAEXTERNALC_INCLUDE_DIR - where to find ModelicaStandardTables.h, ModelicaUtilities.h, etc.
#  MODELICAEXTERNALC_LIBRARY     - the static library
#  ModelicaExternalC_FOUND       - True if the library is found and patched for Dynawo.

if(NOT MODELICAEXTERNALC_HOME AND NOT $ENV{MODELICAEXTERNALC_HOME} STREQUAL "")
  set(MODELICAEXTERNALC_HOME $ENV{MODELICAEXTERNALC_HOME})
endif()

if(NOT MODELICAEXTERNALC_HOME AND NOT $ENV{DYNAWO_MODELICAEXTERNALC_INSTALL_DIR} STREQUAL "")
  set(MODELICAEXTERNALC_HOME $ENV{DYNAWO_MODELICAEXTERNALC_INSTALL_DIR})
endif()

find_path(MODELICAEXTERNALC_INCLUDE_DIR NAMES ModelicaStandardTables.h HINTS ${MODELICAEXTERNALC_HOME}/include NO_DEFAULT_PATH)
mark_as_advanced(MODELICAEXTERNALC_INCLUDE_DIR)

find_library(MODELICAEXTERNALC_LIBRARY NAMES ModelicaExternalC libModelicaExternalC HINTS ${MODELICAEXTERNALC_HOME}/lib NO_DEFAULT_PATH)
mark_as_advanced(MODELICAEXTERNALC_LIBRARY)

# Check that the Dynawo patch (const qualifiers in ModelicaStandardTables) is applied
if(MODELICAEXTERNALC_INCLUDE_DIR)
  file(STRINGS ${MODELICAEXTERNALC_INCLUDE_DIR}/ModelicaStandardTables.h MODELICAEXTERNALC_PATCHED REGEX "_In_ const double\\* table")
  if(NOT MODELICAEXTERNALC_PATCHED)
    message(WARNING "${MODELICAEXTERNALC_INCLUDE_DIR}/ModelicaStandardTables.h does not contain the Dynawo patch (see 3rdParty/modelicaexternalc)")
    unset(MODELICAEXTERNALC_INCLUDE_DIR CACHE)
  endif()
  unset(MODELICAEXTERNALC_PATCHED)
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(ModelicaExternalC "Found Modelica external C library" MODELICAEXTERNALC_LIBRARY MODELICAEXTERNALC_INCLUDE_DIR)
