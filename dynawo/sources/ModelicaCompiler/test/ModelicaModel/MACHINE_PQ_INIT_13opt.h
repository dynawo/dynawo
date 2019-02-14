//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

#if defined(__cplusplus)
  extern "C" {
#endif
  int MACHINE_PQ_INIT_mayer(DATA* data, modelica_real** res, short*);
  int MACHINE_PQ_INIT_lagrange(DATA* data, modelica_real** res, short *, short *);
  int MACHINE_PQ_INIT_pickUpBoundsForInputsInOptimization(DATA* data, modelica_real* min, modelica_real* max, modelica_real*nominal, modelica_boolean *useNominal, char ** name, modelica_real * start, modelica_real * startTimeOpt);
  int MACHINE_PQ_INIT_setInputData(DATA *data, const modelica_boolean file);
  int MACHINE_PQ_INIT_getTimeGrid(DATA *data, modelica_integer * nsi, modelica_real**t);
#if defined(__cplusplus)
}
#endif
