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
 * @file DYDMacroConnectFactory.h
 * @brief MacroConnect factory : header file
 *
 */

#ifndef API_DYD_DYDMACROCONNECTFACTORY_H_
#define API_DYD_DYDMACROCONNECTFACTORY_H_

#include "DYDMacroConnect.h"

#include <boost/shared_ptr.hpp>

namespace dynamicdata {

/**
 * @class MacroConnectFactory
 * @brief MacroConnectFactory factory class
 *
 * MacroConnectFactory encapsulate methods for creating new
 * @p MacroConnect objects.
 */
class MacroConnectFactory {
 public:
  /**
   * @brief Create new MacroConnect instance
   *
   * @param[in] id : id for new MacroConnect instance
   * @param[in] model1 : id of the model 1 to connect
   * @param[in] model2 : id of the model 2 to connect
   * @returns Shared pointer to a new @p MacroConnect with given ID
   */
  static boost::shared_ptr<MacroConnect> newMacroConnect(const std::string& id, const std::string& model1, const std::string& model2);
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDMACROCONNECTFACTORY_H_
