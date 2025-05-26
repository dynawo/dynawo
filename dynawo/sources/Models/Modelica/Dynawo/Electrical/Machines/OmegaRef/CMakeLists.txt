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
  GeneratorPQ.mo
  GeneratorPQ.extvar
  GeneratorPQ_INIT.mo
  GeneratorPV.mo
  GeneratorPV.extvar
  GeneratorPVDiagramPQ.mo
  GeneratorPVDiagramPQ.extvar
  GeneratorPV_INIT.mo
  GeneratorSynchronous.mo
  GeneratorSynchronous.extvar
  GeneratorSynchronousInt_INIT.mo
  GeneratorSynchronousExt3W_INIT.mo
  GeneratorSynchronousExt4W_INIT.mo
  GeneratorSynchronousIntTfo_INIT.mo
  GeneratorSynchronousExtTfo3W_INIT.mo
  GeneratorSynchronousExtTfo4W_INIT.mo
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
