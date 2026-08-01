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
 * @file DYDMacroConnection.h
 * @brief Dynawo MacroConnection description : interface file
 *
 */

#ifndef API_DYD_DYDMACROCONNECTION_H_
#define API_DYD_DYDMACROCONNECTION_H_

#include <string>

namespace dynamicdata {

/**
 * @class MacroConnection
 * @brief Dynawo MacroConnection interface class
 *
 * MacroConnection objects describe a partial description of a connection between two models
 */
class MacroConnection {
 public:
  /**
   * @brief MacroConnection constructor
   *
   * MacroConnection constructor.
   *
   * @param var1   First model connected port name
   * @param var2  Second model connected port name
   */
  MacroConnection(const std::string& var1, const std::string& var2);

  /**
   * @brief First model connected variable getter
   *
   * @return First model connected variable name
   */
  const std::string& getFirstVariableId() const;

  /**
   * @brief Second model connected variable getter
   *
   * @return Second model connected variable name
   */
  const std::string& getSecondVariableId() const;

 private:
  std::string firstVariableId_;   ///< Variable name for the first variable
  std::string secondVariableId_;  ///< Variable name for the second variable
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDMACROCONNECTION_H_
