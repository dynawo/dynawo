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
  PVInverterCurrentSource.mo
  PVInverterCurrentSource.extvar
  PVInverterVoltageSource1.mo
  PVInverterVoltageSource1.extvar
  PVInverterVoltageSource2.mo
  PVInverterVoltageSource2.extvar
  PVInverterVoltageSource3.mo
  PVInverterVoltageSource3.extvar
  PVInverterVoltageSource4.mo
  PVInverterVoltageSource4.extvar
  PVInverterVoltageSource_INIT.mo
  PVPlantCurrentSource.mo
  PVPlantCurrentSource.extvar
  PVPlantVoltageSource1.mo
  PVPlantVoltageSource1.extvar
  PVPlantVoltageSource2.mo
  PVPlantVoltageSource2.extvar
  PVPlantVoltageSource3.mo
  PVPlantVoltageSource3.extvar
  PVPlantVoltageSource4.mo
  PVPlantVoltageSource4.extvar
  PVPlantVoltageSource_INIT.mo
  )

#
# Modelica models install
#
foreach( MODEL_FILE ${MODEL_FILES} )
    install_model_file(${MODEL_FILE})
endforeach( MODEL_FILE )
