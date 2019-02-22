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
#include "MACHINE_PQ_INIT_functions.h"
#ifdef __cplusplus
extern "C" {
#endif

#include "MACHINE_PQ_INIT_literals.h"
#include "MACHINE_PQ_INIT_includes.h"



Dynawo_Types_AC_ApparentPower omc_Dynawo_Types_AC_ApparentPower(threadData_t *threadData, modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_AC_ApparentPower tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

modelica_metatype boxptr_Dynawo_Types_AC_ApparentPower(threadData_t *threadData, modelica_metatype _re, modelica_metatype _im)
{
  return mmc_mk_box3(3, &Dynawo_Types_AC_ApparentPower__desc, _re, _im);
}


Complex omc_Complex(threadData_t *threadData, modelica_real omc_re, modelica_real omc_im)
{
  Complex tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

modelica_metatype boxptr_Complex(threadData_t *threadData, modelica_metatype _re, modelica_metatype _im)
{
  return mmc_mk_box3(3, &Complex__desc, _re, _im);
}


Dynawo_Types_AC_Current omc_Dynawo_Types_AC_Current(threadData_t *threadData, modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_AC_Current tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

modelica_metatype boxptr_Dynawo_Types_AC_Current(threadData_t *threadData, modelica_metatype _re, modelica_metatype _im)
{
  return mmc_mk_box3(3, &Dynawo_Types_AC_Current__desc, _re, _im);
}


Dynawo_Types_AC_Voltage omc_Dynawo_Types_AC_Voltage(threadData_t *threadData, modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_AC_Voltage tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

modelica_metatype boxptr_Dynawo_Types_AC_Voltage(threadData_t *threadData, modelica_metatype _re, modelica_metatype _im)
{
  return mmc_mk_box3(3, &Dynawo_Types_AC_Voltage__desc, _re, _im);
}


#ifdef __cplusplus
}
#endif
