# Copyright (c) 2025, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
#

# Find the ZMQPP library and include directories
# Look for the header files
find_path(ZMQPP_INCLUDE_DIR
    NAMES zmqpp/zmqpp.hpp
)

# Look for the library file
find_library(ZMQPP_LIBRARY
    NAMES zmqpp
)

# Ensure both were found
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(ZMQPP
    REQUIRED_VARS ZMQPP_LIBRARY ZMQPP_INCLUDE_DIR
)

# Expose the found paths to the parent scope
if (ZMQPP_FOUND)
    message(STATUS "ZMQPP: ${PACKAGE_VERSION}")
    mark_as_advanced(ZMQPP_INCLUDE_DIR ZMQPP_LIBRARY)
    if (NOT TARGET ZMQPP::ZMQPP)
        add_library(ZMQPP::ZMQPP UNKNOWN IMPORTED)
        set_target_properties(ZMQPP::ZMQPP PROPERTIES
            IMPORTED_LOCATION "${ZMQPP_LIBRARY}"
            INTERFACE_INCLUDE_DIRECTORIES "${ZMQPP_INCLUDE_DIR}"
        )
    endif()
endif()
