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

/**
 * @file  FSVariableFactory.h
 *
 * @brief Dynawo final state variable factory : header file
 *
 */
#ifndef API_FS_FSVARIABLEFACTORY_H_
#define API_FS_FSVARIABLEFACTORY_H_

#include <boost/shared_ptr.hpp>

#include "FSExport.h"

namespace finalState {
class Variable;

/**
 * @class VariableFactory
 * @brief Variable factory class
 *
 * VariableFactory encapsulates methods for creating new
 * @p Variable objects
 */
class __DYNAWO_FS_EXPORT VariableFactory {
 public:
  /**
   * @brief create a new Variable instance
   *
   * @param[in] id: variable's id
   * @return shared pointer to a new @p Variable
   */
  static boost::shared_ptr<Variable> newVariable(const std::string& id);
};

}  // namespace finalState

#endif  // API_FS_FSVARIABLEFACTORY_H_
