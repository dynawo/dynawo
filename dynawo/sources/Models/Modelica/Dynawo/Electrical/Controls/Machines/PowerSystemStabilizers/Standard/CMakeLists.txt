# Copyright (c) 2021, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.

# IEEE power system stabilizers models

add_subdirectory(BaseClasses B)

set(MODEL_FILES
    package.mo
    package.order
    Pss1aOmega.mo
    Pss1aOmega.extvar
    Pss1aPGen.mo
    Pss1aPGen.extvar
    PSS2A1.mo
    PSS2A1.extvar
    Pss2a.mo
    Pss2a.extvar
    Pss2b.mo
    Pss2b.extvar
    Pss2c.mo
    Pss2c.extvar
    Pss3b.mo
    Pss3b.extvar
    Pss6c.mo
    Pss6c.extvar
    PssIEEE2B.mo
    PssIEEE2B.extvar
    PssKundur.mo
    PssKundur.extvar
    )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
