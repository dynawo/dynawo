# Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.

set(MODEL_FILES
  package.mo
  package.order
  HvdcPV.mo
  HvdcPV_INIT.mo
  HvdcPV.extvar
  HvdcPVDiagramPQ.mo
  HvdcPVDiagramPQ_INIT.mo
  HvdcPVDiagramPQ.extvar
  HvdcPVDangling.mo
  HvdcPVDangling_INIT.mo
  HvdcPVDangling.extvar
  HvdcPVDanglingDiagramPQ.mo
  HvdcPVDanglingDiagramPQ_INIT.mo
  HvdcPVDanglingDiagramPQ.extvar
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
