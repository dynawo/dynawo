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
 * @file DYDMacroConnectorFactory.h
 * @brief MacroConnector factory : header file
 *
 */

#ifndef API_DYD_DYDMACROCONNECTORFACTORY_H_
#define API_DYD_DYDMACROCONNECTORFACTORY_H_

#include "DYDMacroConnector.h"

#include <boost/shared_ptr.hpp>

namespace dynamicdata {

/**
 * @class MacroConnectorFactory
 * @brief MacroConnectorFactory factory class
 *
 * MacroConnectorFactory encapsulate methods for creating new
 * @p MacroConnector objects.
 */
class MacroConnectorFactory {
 public:
  /**
   * @brief Create new MacroConnector instance
   *
   * @param[in] id : id for new MacroConnector instance
   * @returns Shared pointer to a new @p MacroConnector with given ID
   */
  static boost::shared_ptr<MacroConnector> newMacroConnector(const std::string& id);
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDMACROCONNECTORFACTORY_H_
