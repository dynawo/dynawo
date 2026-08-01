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
 * @file  CSTRConstraintFactory.h
 *
 * @brief Dynawo constraint factory: header file
 *
 */
#ifndef API_CSTR_CSTRCONSTRAINTFACTORY_H_
#define API_CSTR_CSTRCONSTRAINTFACTORY_H_

#include "CSTRConstraint.h"

#include <memory>


namespace constraints {
/**
 * @class ConstraintFactory
 * @brief Constraint factory class
 *
 * ConstraintsFactory encapsulate methods for creating new
 * @p Constraint objects.
 */
class ConstraintFactory {
 public:
  /**
   * @brief Create new Constraint instance
   *
   * @return unique pointer to a new empty @p Constraint
   */
  static std::unique_ptr<Constraint> newConstraint();
};
}  // namespace constraints

#endif  // API_CSTR_CSTRCONSTRAINTFACTORY_H_
