# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

# Connectors models

set(MODEL_FILES
    package.mo
    IEEE_39Bus.mo
    PowerPlant_01.mo
    PowerPlant_02.mo
    PowerPlant_03.mo
    PowerPlant_04.mo
    PowerPlant_05.mo
    PowerPlant_06.mo
    PowerPlant_07.mo
    PowerPlant_08.mo
    PowerPlant_09.mo
    PowerPlant_10.mo
    Load03.mo
    Load04.mo
    Load07.mo
    Load08.mo
    Load15.mo
    Load16.mo
    Load18.mo
    Load20.mo
    Load21.mo
    Load23.mo
    Load24.mo
    Load25.mo
    Load26.mo
    Load27.mo
    Load28.mo
    Load29.mo
    Load39.mo
    Earth.mo
    )

#
# Modelica models install
#
foreach( MODEL_FILE ${MODEL_FILES} )
    INSTALL_MODEL_file(${MODEL_FILE})
endforeach( MODEL_FILE )
