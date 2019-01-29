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
 * @file DYDConnector.h
 * @brief Dynawo connector description : interface file
 *
 */

#ifndef API_DYD_DYDCONNECTOR_H_
#define API_DYD_DYDCONNECTOR_H_

#include <string>

#include "DYDExport.h"

namespace dynamicdata {

class Model;

/**
 * @class Connector
 * @brief Dynawo connector interface class
 *
 * Connector objects describe a dynamic connection between two models
 */
class __DYNAWO_DYD_EXPORT Connector {
 public:
  /**
   * @brief First model getter
   *
   * @return First model shared pointer
   */
  virtual std::string getFirstModelId() const = 0;

  /**
   * @brief First model connected variable getter
   *
   * @return First model connected variable name
   */
  virtual std::string getFirstVariableId() const = 0;

  /**
   * @brief Second model getter
   *
   * @return Second model shared pointer
   */
  virtual std::string getSecondModelId() const = 0;

  /**
   * @brief Second model connected variable getter
   *
   * @return Second model connected variable name
   */
  virtual std::string getSecondVariableId() const = 0;

  class Impl;  // Implementation class
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDCONNECTOR_H_
