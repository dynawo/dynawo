# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

# DECLARATION : sets MODEL_FILES VARIABLE to package.mo
set(MODEL_FILES
        package.mo
        # newRLC.mo
        # RLCwithSwitch.mo
        # triphase.mo
        )

#
# Installing models (MODEL_FILE iterator through the MODEL_FILES array)
#
foreach (MODEL_FILE ${MODEL_FILES} )
        INSTALL_MODEL_file(${MODEL_FILE})
endforeach(MODEL_FILE)

#sets modelRoot variable to the name of the current path (modelRoot = OpenEMTP)
get_filename_component(modelRoot ${CMAKE_CURRENT_SOURCE_DIR} NAME)

#Adding subdirectories to the build
add_subdirectory(Connectors C)
add_subdirectory(Electrical E)
add_subdirectory(Examples X)
add_subdirectory(Interfaces F)
add_subdirectory(NonElectrical N)
add_subdirectory(UserGuide U)
