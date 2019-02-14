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

#ifndef MACHINE_PQ_INIT__H
#define MACHINE_PQ_INIT__H
#include "meta/meta_modelica.h"
#include "util/modelica.h"
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

#include "simulation/simulation_runtime.h"
#ifdef __cplusplus
extern "C" {
#endif

typedef struct Dynawo_Types_AC_ApparentPower_s {
  modelica_real _im;
  modelica_real _re;
} Dynawo_Types_AC_ApparentPower;
typedef base_array_t Dynawo_Types_AC_ApparentPower_array;
extern struct record_description Dynawo_Types_AC_ApparentPower__desc;

typedef Dynawo_Types_AC_ApparentPower Complex;
typedef base_array_t Complex_array;
extern struct record_description Complex__desc;

typedef Dynawo_Types_AC_ApparentPower Dynawo_Types_AC_Current;
typedef base_array_t Dynawo_Types_AC_Current_array;
extern struct record_description Dynawo_Types_AC_Current__desc;

typedef Dynawo_Types_AC_ApparentPower Dynawo_Types_AC_Voltage;
typedef base_array_t Dynawo_Types_AC_Voltage_array;
extern struct record_description Dynawo_Types_AC_Voltage__desc;

DLLExport
Dynawo_Types_AC_ApparentPower omc_Dynawo_Types_AC_ApparentPower(threadData_t *threadData, modelica_real omc_re, modelica_real omc_im); /* record head */

DLLExport
modelica_metatype boxptr_Dynawo_Types_AC_ApparentPower(threadData_t *threadData, modelica_metatype _re, modelica_metatype _im);
static const MMC_DEFSTRUCTLIT(boxvar_lit_Dynawo_Types_AC_ApparentPower,2,0) {(void*) boxptr_Dynawo_Types_AC_ApparentPower,0}};
#define boxvar_Dynawo_Types_AC_ApparentPower MMC_REFSTRUCTLIT(boxvar_lit_Dynawo_Types_AC_ApparentPower)


DLLExport
Complex omc_Complex(threadData_t *threadData, modelica_real omc_re, modelica_real omc_im); /* record head */

DLLExport
modelica_metatype boxptr_Complex(threadData_t *threadData, modelica_metatype _re, modelica_metatype _im);
static const MMC_DEFSTRUCTLIT(boxvar_lit_Complex,2,0) {(void*) boxptr_Complex,0}};
#define boxvar_Complex MMC_REFSTRUCTLIT(boxvar_lit_Complex)


DLLExport
Dynawo_Types_AC_Current omc_Dynawo_Types_AC_Current(threadData_t *threadData, modelica_real omc_re, modelica_real omc_im); /* record head */

DLLExport
modelica_metatype boxptr_Dynawo_Types_AC_Current(threadData_t *threadData, modelica_metatype _re, modelica_metatype _im);
static const MMC_DEFSTRUCTLIT(boxvar_lit_Dynawo_Types_AC_Current,2,0) {(void*) boxptr_Dynawo_Types_AC_Current,0}};
#define boxvar_Dynawo_Types_AC_Current MMC_REFSTRUCTLIT(boxvar_lit_Dynawo_Types_AC_Current)


DLLExport
Dynawo_Types_AC_Voltage omc_Dynawo_Types_AC_Voltage(threadData_t *threadData, modelica_real omc_re, modelica_real omc_im); /* record head */

DLLExport
modelica_metatype boxptr_Dynawo_Types_AC_Voltage(threadData_t *threadData, modelica_metatype _re, modelica_metatype _im);
static const MMC_DEFSTRUCTLIT(boxvar_lit_Dynawo_Types_AC_Voltage,2,0) {(void*) boxptr_Dynawo_Types_AC_Voltage,0}};
#define boxvar_Dynawo_Types_AC_Voltage MMC_REFSTRUCTLIT(boxvar_lit_Dynawo_Types_AC_Voltage)
#include "MACHINE_PQ_INIT_model.h"


#ifdef __cplusplus
}
#endif
#endif

