# Copyright (c) 2013-2019, RTE (http://www.rte-france.com)
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Libzip, a library to handle zip archives.

macro(GetLibZipVersion)

    set(LibZIP_VERSION_MAJOR 0)
    set(LibZIP_VERSION_MINOR 0)
    set(LibZIP_VERSION_PATCH 0)

    file(READ "${zip_SOURCE_DIR}/include/libzip/ZipVersion.h" _zip_version_h_contents)
    string(REGEX REPLACE ".*#define LIBZIP_VERSION ([0-9]+).*" "\\1" LibZIP_VERSION "${_zip_version_h_contents}")

    if (NOT "${LibZIP_VERSION}" STREQUAL "0")
        math(EXPR LibZIP_VERSION_MAJOR "${LibZIP_VERSION} / 100000")
        math(EXPR LibZIP_VERSION_MINOR "${LibZIP_VERSION} / 100 % 1000")
        math(EXPR LibZIP_VERSION_PATCH "${LibZIP_VERSION} % 100")
    endif ()

    set(LibZIP_VERSION ${LibZIP_VERSION_MAJOR}.${LibZIP_VERSION_MINOR}.${LibZIP_VERSION_PATCH})
    set(LibZIP_SOVERSION ${LibZIP_VERSION_MAJOR})

endmacro()
