# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

SET(MODEL_FILES
    package.mo
    Types.mo
    )

#
# Modelica models install
#
FOREACH( MODEL_FILE ${MODEL_FILES} )
    INSTALL_MODEL_FILE(${MODEL_FILE})
ENDFOREACH( MODEL_FILE )

GET_FILENAME_COMPONENT(modelRoot ${CMAKE_CURRENT_SOURCE_DIR} NAME)
INSTALL(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/Resources DESTINATION ${ddbdir}/${modelRoot}/)


ADD_SUBDIRECTORY(Connectors)
ADD_SUBDIRECTORY(Electrical)
ADD_SUBDIRECTORY(NonElectrical)
