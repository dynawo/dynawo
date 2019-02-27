# Copyright (c) 2013-2019, RTE (http://www.rte-france.com)
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Libzip, a library to handle zip archives.

add_executable(sample1 sample1.cpp)
if (LIBZIP_BUILD_SHARED)
  target_link_libraries(sample1 ${CMAKE_PROJECT_NAME})
elseif(LIBZIP_BUILD_STATIC)
  target_link_libraries(sample1 ${CMAKE_PROJECT_NAME}-static)
endif ()
