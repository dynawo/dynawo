# Copyright (c) 2025, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source suite
# of simulation tools for power systems.

# Parameters of the PV WECC model

set(MODEL_FILES
  package.mo
  package.order
  ParamsREGC.mo
  ParamsREGCa.mo
  ParamsREGCb.mo
  ParamsREGCc.mo
  )

#
# Modelica models install
#
foreach( MODEL_FILE ${MODEL_FILES} )
    install_model_file(${MODEL_FILE})
endforeach( MODEL_FILE )
