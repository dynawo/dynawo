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
 * @file DYDMacroConnectionFactory.h
 * @brief MacroConnection factory : header file
 *
 */

#ifndef API_DYD_DYDMACROCONNECTIONFACTORY_H_
#define API_DYD_DYDMACROCONNECTIONFACTORY_H_

#include "DYDMacroConnection.h"

#include <memory>

namespace dynamicdata {

/**
 * @class MacroConnectionFactory
 * @brief MacroConnection factory class
 *
 * MacroConnectionFactory encapsulate methods for creating new
 * @p MacroConnection objects.
 */
class MacroConnectionFactory {
 public:
  /**
   * @brief Create new MacroConnection instance
   *
   * @param[in] var1 : first model connected port name
   * @param[in] var2 : second model connected port name
   * @returns Unique pointer to a new @p MacroConnection
   */
  static std::unique_ptr<MacroConnection> newMacroConnection(const std::string& var1, const std::string& var2);
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDMACROCONNECTIONFACTORY_H_
