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
 * @file DYDMacroConnector.h
 * @brief MacroConnector : interface file
 *
 */

#ifndef API_DYD_DYDMACROCONNECTOR_H_
#define API_DYD_DYDMACROCONNECTOR_H_

#include <string>
#include <map>
#include <boost/shared_ptr.hpp>

namespace dynamicdata {

class MacroConnection;

/**
 * @class MacroConnector
 * @brief Macro connector interface class
 */
class MacroConnector {
 public:
  /**
   * @brief Destructor
   */
  virtual ~MacroConnector() {}
  /**
   * @brief Macro connector id getter
   *
   * @returns the id of the macro connector
   */
  virtual std::string getId() const = 0;

  /**
   * @brief Dynamic connectors getter
   *
   * @returns Map of connectors
   */
  virtual const std::map<std::string, boost::shared_ptr<MacroConnection> >& getConnectors() const = 0;

  /**
   * @brief Initialization connectors getter
   *
   * @returns Map of initialization connectors
   */
  virtual const std::map<std::string, boost::shared_ptr<MacroConnection> >& getInitConnectors() const = 0;

  /**
   * @brief Macro connection adder
   *
   * @param[in] var1 First var to connect
   * @param[in] var2 Second var to connect
   * @returns Reference to the current MacroConnector instance
   */
  virtual MacroConnector& addConnect(const std::string& var1, const std::string& var2) = 0;

  /**
   * @brief Initialization Macro connection adder
   *
   * @param[in] var1 First var to connect
   * @param[in] var2 Second var to connect
   * @return Reference to current MacroConnector instance
   */
  virtual MacroConnector& addInitConnect(const std::string& var1, const std::string& var2) = 0;

  class Impl;  ///< Implementation class
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDMACROCONNECTOR_H_
