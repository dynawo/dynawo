//
// Copyright (c) 2023, RTE (http://www.rte-france.com)
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

/**
 * @file  DYNModelicaOverridenFunctions.h
 *
 * @brief  functions from MSL external C library that needs to be overriden for Dynawo needs
 *
 */
#ifndef MODELER_MODELMANAGER_DYNMODELICAOVERRIDENFUNCTIONS_H_
#define MODELER_MODELMANAGER_DYNMODELICAOVERRIDENFUNCTIONS_H_


#ifdef _ADEPT_
#include "adept.h"
#endif


#ifdef _ADEPT_
  /* Interpolate in table

     -> tableID: Pointer to table defined with ModelicaStandardTables_CombiTable1D_init
     -> icol: Index (1-based) of column to interpolate
     -> u: Abscissa value
     <- RETURN : Ordinate vDalue
  */

adept::adouble ModelicaStandardTables_CombiTable1D_getDerValue_adept(void* tableID, int icol, adept::adouble der_u);
  /* Interpolate in table

     -> tableID: Pointer to table defined with ModelicaStandardTables_CombiTable2D_init
     -> u1: Value of first independent variable
     -> u2: Value of second independent variable
     <- RETURN : Interpolated value
  */

adept::adouble ModelicaStandardTables_CombiTable2D_getDerValue_adept(void* tableID, adept::adouble der_u1, adept::adouble der_u2);

/* Interpolate in table

   -> tableID: Pointer to table defined with ModelicaStandardTables_CombiTimeTable_init
   -> icol: Index (1-based) of column to interpolate
   -> t: Abscissa value (time)
   -> nextTimeEvent: Next time event (found by ModelicaStandardTables_CombiTimeTable_nextTimeEvent)
   -> preNextTimeEvent: Pre value of next time event
   <- RETURN : Ordinate value
*/

adept::adouble ModelicaStandardTables_CombiTimeTable_getDerValue_adept(void* tableID,
                                                       int icol,
                                                       adept::adouble der_t,
                                                       double nextTimeEvent,
                                                       double preNextTimeEvent);
#endif



#endif  // MODELER_MODELMANAGER_DYNMODELICAOVERRIDENFUNCTIONS_H_
