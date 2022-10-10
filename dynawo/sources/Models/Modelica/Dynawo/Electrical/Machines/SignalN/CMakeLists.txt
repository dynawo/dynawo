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
  GeneratorPQProp.mo
  GeneratorPQProp.extvar
  GeneratorPQPropDiagramPQ.mo
  GeneratorPQPropDiagramPQ.extvar
  GeneratorPV.mo
  GeneratorPV.extvar
  GeneratorPV_INIT.mo
  GeneratorPVQNomAltPar_INIT.mo
  GeneratorPVDiagramPQ.mo
  GeneratorPVDiagramPQ.extvar
  GeneratorPVDiagram_INIT.mo
  GeneratorPVQNomAltParDiagram_INIT.mo
  GeneratorPVProp.mo
  GeneratorPVProp.extvar
  GeneratorPVRemote.mo
  GeneratorPVRemote.extvar
  GeneratorPVRemoteDiagramPQ.mo
  GeneratorPVRemoteDiagramPQ.extvar
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
