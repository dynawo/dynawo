# Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Libiidm, a library to model IIDM networks and allows importing and exporting them to files.

if( BUILD_XML )
  add_executable(StateOfCharge1 StateOfCharge1.cpp )
  target_link_libraries(StateOfCharge1
    iidm-ext-stateofcharge-xml-testing
  )

  add_executable(StateOfCharge_cat StateOfCharge_cat.cpp )
  target_link_libraries(StateOfCharge_cat
    iidm-ext-stateofcharge-xml-testing
  )
endif()
