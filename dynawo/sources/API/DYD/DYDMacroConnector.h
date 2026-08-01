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
 * @file DYDMacroConnector.h
 * @brief MacroConnector : interface file
 *
 */

#ifndef API_DYD_DYDMACROCONNECTOR_H_
#define API_DYD_DYDMACROCONNECTOR_H_

#include "DYDMacroConnection.h"

#include <map>
#include <string>
#include <memory>

namespace dynamicdata {

/**
 * @class MacroConnector
 * @brief Macro connector interface class
 */
class MacroConnector {
 public:
  /**
   * @brief MacroConnector constructor
   *
   * @param id MacroConnector ID
   */
  explicit MacroConnector(const std::string& id);

  /**
   * @brief Macro connector id getter
   *
   * @returns the id of the macro connector
   */
  const std::string& getId() const;

  /**
   * @brief Dynamic connectors getter
   *
   * @returns Map of connectors
   */
  const std::map<std::string, std::unique_ptr<MacroConnection> >& getConnectors() const;

  /**
   * @brief Initialization connectors getter
   *
   * @returns Map of initialization connectors
   */
  const std::map<std::string, std::unique_ptr<MacroConnection> >& getInitConnectors() const;

  /**
   * @brief Macro connection adder
   *
   * @param[in] var1 First var to connect
   * @param[in] var2 Second var to connect
   * @returns Reference to the current MacroConnector instance
   */
  MacroConnector& addConnect(const std::string& var1, const std::string& var2);

  /**
   * @brief Initialization Macro connection adder
   *
   * @param[in] var1 First var to connect
   * @param[in] var2 Second var to connect
   * @return Reference to current MacroConnector instance
   */
  MacroConnector& addInitConnect(const std::string& var1, const std::string& var2);

 private:
  std::string id_;                                                              ///< id of the macro connector
  std::map<std::string, std::unique_ptr<MacroConnection> > initConnectorsMap_;  ///< MacroConnector initialization connectors
  std::map<std::string, std::unique_ptr<MacroConnection> > connectorsMap_;      ///<  MacroConnector connectors
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDMACROCONNECTOR_H_
