# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

add_subdirectory(Unsaturated U)

# Connectors models

set(MODEL_FILES
    package.mo
    IdealUnit.mo
    Nonideal_Unit.mo
    YgD01.mo
    YD01.mo
    YgD11.mo
    YD11.mo
    YgYg.mo
    YY.mo
    DD.mo
    DY11.mo
    DY01.mo
    DYg01.mo
    DYg11.mo
    YgYgD.mo
    YgDD.mo
    )

#
# Modelica models install
#
foreach( MODEL_FILE ${MODEL_FILES} )
    INSTALL_MODEL_file(${MODEL_FILE})
endforeach( MODEL_FILE )
