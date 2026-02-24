# Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.

# Machines models

add_subdirectory(BaseClasses B)
add_subdirectory(BaseClasses_INIT BI)

set(MODEL_FILES
  package.mo
  package.order
  GeneratorPQProp.mo
  GeneratorPQProp.extvar
  GeneratorPQProp.mandatoryParam
  GeneratorPQProp_INIT.mo
  GeneratorPQProp_INIT.mandatoryParam
  GeneratorPQPropSFR.mo
  GeneratorPQPropSFR.extvar
  GeneratorPQPropSFR.mandatoryParam
  GeneratorPQPropSFR_INIT.mo
  GeneratorPQPropSFR_INIT.mandatoryParam
  GeneratorPQPropDiagramPQ.mo
  GeneratorPQPropDiagramPQ.extvar
  GeneratorPQPropDiagramPQ.mandatoryParam
  GeneratorPQPropDiagramPQ_INIT.mo
  GeneratorPQPropDiagramPQ_INIT.mandatoryParam
  GeneratorPQPropDiagramPQSFR.mo
  GeneratorPQPropDiagramPQSFR.extvar
  GeneratorPQPropDiagramPQSFR.mandatoryParam
  GeneratorPQPropDiagramPQSFR_INIT.mo
  GeneratorPQPropDiagramPQSFR_INIT.mandatoryParam
  GeneratorPV.mo
  GeneratorPV.extvar
  GeneratorPV.mandatoryParam
  GeneratorPV_INIT.mo
  GeneratorPV_INIT.mandatoryParam
  GeneratorPVSFR.mo
  GeneratorPVSFR.extvar
  GeneratorPVSFR.mandatoryParam
  GeneratorPVSFR_INIT.mo
  GeneratorPVSFR_INIT.mandatoryParam
  GeneratorPVQNomAltPar_INIT.mo
  GeneratorPVQNomAltPar_INIT.mandatoryParam
  GeneratorPVDiagramPQ.mo
  GeneratorPVDiagramPQ.extvar
  GeneratorPVDiagramPQ.mandatoryParam
  GeneratorPVDiagramPQ_INIT.mo
  GeneratorPVDiagramPQ_INIT.mandatoryParam
  GeneratorPVDiagramPQSFR.mo
  GeneratorPVDiagramPQSFR.extvar
  GeneratorPVDiagramPQSFR.mandatoryParam
  GeneratorPVDiagramPQSFR_INIT.mo
  GeneratorPVDiagramPQSFR_INIT.mandatoryParam
  GeneratorPVQNomAltParDiagram_INIT.mo
  GeneratorPVQNomAltParDiagram_INIT.mandatoryParam
  GeneratorPVProp.mo
  GeneratorPVProp.extvar
  GeneratorPVProp.mandatoryParam
  GeneratorPVProp_INIT.mo
  GeneratorPVProp_INIT.mandatoryParam
  GeneratorPVPropSFR.mo
  GeneratorPVPropSFR.extvar
  GeneratorPVPropSFR.mandatoryParam
  GeneratorPVPropSFR_INIT.mo
  GeneratorPVPropSFR_INIT.mandatoryParam
  GeneratorPVRemote.mo
  GeneratorPVRemote.extvar
  GeneratorPVRemote.mandatoryParam
  GeneratorPVRemote_INIT.mo
  GeneratorPVRemote_INIT.mandatoryParam
  GeneratorPVRemoteSFR.mo
  GeneratorPVRemoteSFR.extvar
  GeneratorPVRemoteSFR.mandatoryParam
  GeneratorPVRemoteSFR_INIT.mo
  GeneratorPVRemoteSFR_INIT.mandatoryParam
  GeneratorPVRemoteDiagramPQ.mo
  GeneratorPVRemoteDiagramPQ.extvar
  GeneratorPVRemoteDiagramPQ.mandatoryParam
  GeneratorPVRemoteDiagramPQ_INIT.mo
  GeneratorPVRemoteDiagramPQ_INIT.mandatoryParam
  GeneratorPVRemoteDiagramPQSFR.mo
  GeneratorPVRemoteDiagramPQSFR.extvar
  GeneratorPVRemoteDiagramPQSFR.mandatoryParam
  GeneratorPVRemoteDiagramPQSFR_INIT.mo
  GeneratorPVRemoteDiagramPQSFR_INIT.mandatoryParam
  GeneratorPVTfo.mo
  GeneratorPVTfo.extvar
  GeneratorPVTfo.mandatoryParam
  GeneratorPVTfo_INIT.mo
  GeneratorPVTfo_INIT.mandatoryParam
  GeneratorPVTfoDiagramPQ.mo
  GeneratorPVTfoDiagramPQ.extvar
  GeneratorPVTfoDiagramPQ.mandatoryParam
  GeneratorPVTfoDiagramPQ_INIT.mo
  GeneratorPVTfoDiagramPQ_INIT.mandatoryParam
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
