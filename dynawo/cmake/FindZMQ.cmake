# Copyright (c) 2025, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source suite
# of simulation tools for power systems.
#

# Find cppzmq (C++ ZeroMQ bindings) and libzmq
# Looks for zmq.hpp and links to libzmq

# Look for headers - location varies across distros
find_path(ZMQ_INCLUDE_DIR
    NAMES zmq.hpp
    PATH_SUFFIXES zmq
)

# Look for libzmq shared/static library
find_library(ZMQ_LIBRARY
    NAMES zmq libzmq
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(ZMQ
    REQUIRED_VARS ZMQ_INCLUDE_DIR ZMQ_LIBRARY
)

if(ZMQ_FOUND)
    message(STATUS "Found ZeroMQ include in: ${ZMQ_INCLUDE_DIR} - lib: ${ZMQ_LIBRARY}")

    mark_as_advanced(ZMQ_INCLUDE_DIR ZMQ_LIBRARY)

    if(NOT TARGET ZMQ::ZMQ)
        add_library(ZMQ::ZMQ INTERFACE IMPORTED)
        set_target_properties(ZMQ::ZMQ PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${ZMQ_INCLUDE_DIR}"
            INTERFACE_LINK_LIBRARIES "${ZMQ_LIBRARY}"
        )
    endif()
endif()
