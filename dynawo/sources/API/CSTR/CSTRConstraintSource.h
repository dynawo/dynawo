// Copyright (c) 2026, RTE (http://www.rte-france.com)
//
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain
// simulation tool for power systems.

/** @file  CSTRConstraintSource.h */

#ifndef API_CSTR_CSTRCONSTRAINTSOURCE_H_
#define API_CSTR_CSTRCONSTRAINTSOURCE_H_

#include "CSTRConstraint.h"

namespace constraints {

/**
 * @class ConstraintSource
 * @brief interface to retrieve final and extremal values of a constraint from its producer
 */
class ConstraintSource {
 public:
   /**
   * @brief Construct a new Constraint Data object
   * @param kind the kind of constraint to be queried for final value
   * @param varIndex the index of the variable to be queried (only in certain cases)
   * @param valueFinal output value, will be set by the function to the value of the variable causing the constraint at the end of the simulation
   * @param valueMin output value, will be set by the function to the minimum value of the variable causing the constraint during the simulation
   * @param valueMax output value, will be set by the function to the maximum value of the variable causing the constraint during the simulation
   */
  virtual void getFinalValues(ConstraintData::kind_t kind,
                              int varIndex,
                              double & valueFinal,
                              boost::optional<double> & valueMin,
                              boost::optional<double> & valueMax) const = 0;
};

}  // end of namespace constraints

#endif  // API_CSTR_CSTRCONSTRAINTSOURCE_H_
