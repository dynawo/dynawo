# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.

set(MODEL_FILES
  # Electrical Buses models
  package.mo
  package.order
  Bus.mo
  Bus.extvar
  BusWithInit.extvar
  BusWithInit.mo
  Bus_INIT.mo
  InfiniteBus.mo
  InfiniteBus.extvar
  InfiniteBusFromTable.mo
  InfiniteBusFromTable_INIT.mo
  InfiniteBusFromTable.extvar
  InfiniteBusWithImpedance.mo
  InfiniteBusWithImpedance.extvar
  InfiniteBusWithImpedance_INIT.mo
  InfiniteBusWithVariations.mo
  InfiniteBusWithVariations.extvar
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
