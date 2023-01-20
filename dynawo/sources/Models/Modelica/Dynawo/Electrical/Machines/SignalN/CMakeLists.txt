# Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

# Machines models

set(MODEL_FILES
  package.mo
  package.order
  BaseClasses.mo
  BaseClasses_INIT.mo
  GeneratorPQProp.mo
  GeneratorPQProp.extvar
  GeneratorPQProp_INIT.mo
  GeneratorPQPropSFR.mo
  GeneratorPQPropSFR.extvar
  GeneratorPQPropSFR_INIT.mo
  GeneratorPQPropDiagramPQ.mo
  GeneratorPQPropDiagramPQ.extvar
  GeneratorPQPropDiagramPQ_INIT.mo
  GeneratorPQPropDiagramPQSFR.mo
  GeneratorPQPropDiagramPQSFR.extvar
  GeneratorPQPropDiagramPQSFR_INIT.mo
  GeneratorPV.mo
  GeneratorPV.extvar
  GeneratorPV_INIT.mo
  GeneratorPVSFR.mo
  GeneratorPVSFR.extvar
  GeneratorPVSFR_INIT.mo
  GeneratorPVQNomAltPar_INIT.mo
  GeneratorPVDiagramPQ.mo
  GeneratorPVDiagramPQ.extvar
  GeneratorPVDiagramPQ_INIT.mo
  GeneratorPVDiagramPQSFR.mo
  GeneratorPVDiagramPQSFR.extvar
  GeneratorPVDiagramPQSFR_INIT.mo
  GeneratorPVQNomAltParDiagram_INIT.mo
  GeneratorPVProp.mo
  GeneratorPVProp.extvar
  GeneratorPVProp_INIT.mo
  GeneratorPVPropSFR.mo
  GeneratorPVPropSFR.extvar
  GeneratorPVPropSFR_INIT.mo
  GeneratorPVRemote.mo
  GeneratorPVRemote.extvar
  GeneratorPVRemote_INIT.mo
  GeneratorPVRemoteSFR.mo
  GeneratorPVRemoteSFR.extvar
  GeneratorPVRemoteSFR_INIT.mo
  GeneratorPVRemoteDiagramPQ.mo
  GeneratorPVRemoteDiagramPQ.extvar
  GeneratorPVRemoteDiagramPQ_INIT.mo
  GeneratorPVRemoteDiagramPQSFR.mo
  GeneratorPVRemoteDiagramPQSFR.extvar
  GeneratorPVRemoteDiagramPQSFR_INIT.mo
  GeneratorPVTfo.mo
  GeneratorPVTfo.extvar
  GeneratorPVTfo_INIT.mo
  GeneratorPVTfoDiagramPQ.mo
  GeneratorPVTfoDiagramPQ.extvar
  GeneratorPVTfoDiagramPQ_INIT.mo
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
