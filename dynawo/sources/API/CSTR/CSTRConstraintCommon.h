//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file  CSTRConstraintCommon.h
 *
 * @brief Common header to define constant for constraint API
 *
 */
#ifndef API_CSTR_CSTRCONSTRAINTCOMMON_H_
#define API_CSTR_CSTRCONSTRAINTCOMMON_H_

namespace constraints {

/**
 * defined type of constraint
 */
typedef enum {
  CONSTRAINT_UNDEFINED = -1,  // Constraint type is undefined
  CONSTRAINT_BEGIN = 0,  // Begin of a Constraint
  CONSTRAINT_END = 1  // End of a Constraint
} Type_t;  ///< type on constraint

}  // namespace constraints

#endif  // API_CSTR_CSTRCONSTRAINTCOMMON_H_
