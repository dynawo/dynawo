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

/* Jacobians */
static const REAL_ATTRIBUTE dummyREAL_ATTRIBUTE = omc_dummyRealAttribute;
/* Jacobian Variables */
#if defined(__cplusplus)
extern "C" {
#endif
  #define MACHINE_PQ_INDEX_JAC_D 3
  int MACHINE_PQ_functionJacD_column(void* data, threadData_t *threadData);
  int MACHINE_PQ_initialAnalyticJacobianD(void* data, threadData_t *threadData);
#if defined(__cplusplus)
}
#endif
/* D */

#if defined(__cplusplus)
extern "C" {
#endif
  #define MACHINE_PQ_INDEX_JAC_C 2
  int MACHINE_PQ_functionJacC_column(void* data, threadData_t *threadData);
  int MACHINE_PQ_initialAnalyticJacobianC(void* data, threadData_t *threadData);
#if defined(__cplusplus)
}
#endif
/* C */

#if defined(__cplusplus)
extern "C" {
#endif
  #define MACHINE_PQ_INDEX_JAC_B 1
  int MACHINE_PQ_functionJacB_column(void* data, threadData_t *threadData);
  int MACHINE_PQ_initialAnalyticJacobianB(void* data, threadData_t *threadData);
#if defined(__cplusplus)
}
#endif
/* B */

#if defined(__cplusplus)
extern "C" {
#endif
  #define MACHINE_PQ_INDEX_JAC_A 0
  int MACHINE_PQ_functionJacA_column(void* data, threadData_t *threadData);
  int MACHINE_PQ_initialAnalyticJacobianA(void* data, threadData_t *threadData);
#if defined(__cplusplus)
}
#endif
/* A */
#define $PMACHINE_omegaRefPu_valueSeedA data->simulationInfo->analyticJacobians[0].seedVars[0]
#define $PMACHINE_omegaRefPu_valueSeedA__varInfo dummyVAR_INFO
#define $PMACHINE_terminal_V_imSeedA data->simulationInfo->analyticJacobians[0].seedVars[1]
#define $PMACHINE_terminal_V_imSeedA__varInfo dummyVAR_INFO
#define $PMACHINE_terminal_V_reSeedA data->simulationInfo->analyticJacobians[0].seedVars[2]
#define $PMACHINE_terminal_V_reSeedA__varInfo dummyVAR_INFO


