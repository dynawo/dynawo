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
 * @file EXTVARVariableFactory.h
 * @brief External variable factory : header file
 *
 */

#ifndef API_EXTVAR_EXTVARVARIABLEFACTORY_H_
#define API_EXTVAR_EXTVARVARIABLEFACTORY_H_

#include "EXTVARVariable.h"

#include <memory>


namespace externalVariables {

/**
 * @class VariableFactory
 * @brief VariableFactory factory class
 *
 * VariableFactory encapsulates methods for creating new
 * @p Variable objects.
 */
class VariableFactory {
 public:
  /**
   * @brief Create new Variable instance
   *
   * @param[in] id ID for new Variable instance
   * @param[in] type the variable type
   * @returns Unique pointer to a new @p Variable with given ID and type
   */
  static std::unique_ptr<Variable> newVariable(const std::string& id, Variable::Type type);
};

}  // namespace externalVariables

#endif  // API_EXTVAR_EXTVARVARIABLEFACTORY_H_
