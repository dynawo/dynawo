# Copyright (c) 2021, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.

add_subdirectory(BaseClasses B)

set(MODEL_FILES
  package.mo
  package.order
  PVCurrentSource.mo
  PVCurrentSource.extvar
  PVCurrentSourceNoPlantControl.mo
  PVCurrentSourceNoPlantControl.extvar
  PVCurrentSource2.mo
  PVCurrentSource_INIT.mo
  PVVoltageSource1.mo
  PVVoltageSource1.extvar
  PVVoltageSource1NoPlantControl.mo
  PVVoltageSource1NoPlantControl.extvar
  PVVoltageSource2.mo
  PVVoltageSource2.extvar
  PVVoltageSource2NoPlantControl.mo
  PVVoltageSource2NoPlantControl.extvar
  PVVoltageSource3.mo
  PVVoltageSource3.extvar
  PVVoltageSource3NoPlantControl.mo
  PVVoltageSource3NoPlantControl.extvar
  PVVoltageSource4.mo
  PVVoltageSource4.extvar
  PVVoltageSource4NoPlantControl.mo
  PVVoltageSource4NoPlantControl.extvar
  PVVoltageSource_INIT.mo
  )

#
# Modelica models install
#
foreach( MODEL_FILE ${MODEL_FILES} )
    install_model_file(${MODEL_FILE})
endforeach( MODEL_FILE )
