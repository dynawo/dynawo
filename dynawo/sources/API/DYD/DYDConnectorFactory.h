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
 * @file DYDConnectorFactory.h
 * @brief Connector factory : header file
 *
 */

#ifndef API_DYD_DYDCONNECTORFACTORY_H_
#define API_DYD_DYDCONNECTORFACTORY_H_

#include "DYDConnector.h"

#include <memory>


namespace dynamicdata {

/**
 * @class ConnectorFactory
 * @brief Connector factory class
 *
 * ConnectorFactory encapsulate methods for creating new
 * @p Connector objects.
 */
class ConnectorFactory {
 public:
  /**
   * @brief Create new Connector instance
   *
   * @param[in] model1 : shared pointer to the first model
   * @param[in] var1 : first model connected port name
   * @param[in] model2 : shared pointer to the second model
   * @param[in] var2 : second model connected port name
   * @returns Unique pointer to a new @p Connector
   */
  static std::unique_ptr<Connector> newConnector(const std::string& model1, const std::string& var1, const std::string& model2, const std::string& var2);
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDCONNECTORFACTORY_H_
