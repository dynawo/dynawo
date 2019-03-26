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
 * @file DYDMacroConnect.h
 * @brief Dynawo macro connect description : interface file
 *
 */

#ifndef API_DYD_DYDMACROCONNECT_H_
#define API_DYD_DYDMACROCONNECT_H_

#include <string>

#include "DYDExport.h"

namespace dynamicdata {

/**
 * @class MacroConnect
 * @brief Dynawo MacroConnect interface class
 *
 */
class __DYNAWO_DYD_EXPORT MacroConnect {
 public:
  /**
   * @brief Destructor
   */
  virtual ~MacroConnect() {}
  /**
   * @brief First model getter
   *
   * @return First model id
   */
  virtual std::string getFirstModelId() const = 0;

  /**
   * @brief Second model getter
   *
   * @return Second model id
   */
  virtual std::string getSecondModelId() const = 0;

  /**
   * @brief Connector id getter
   *
   * @return id of the connector
   */
  virtual std::string getConnector() const = 0;

  /**
   * @brief set the index of the first model
   * @param index1 index of the first model to replace \@INDEX\@
   */
  virtual void setIndex1(const std::string& index1) = 0;

  /**
   * @brief set the index of the second model
   * @param index2 index of the second model to replace \@INDEX\@
   */
  virtual void setIndex2(const std::string& index2) = 0;

  /**
   * @brief set the name of the first model
   * @param name1 name of the first model to replace \@NAME\@
   */
  virtual void setName1(const std::string& name1) = 0;

  /**
   * @brief set the name of the second model
   * @param name2 name of the second model to replace \@NAME\@
   */
  virtual void setName2(const std::string& name2) = 0;

  /**
   * @brief get the index of the first model
   * @return index of the first model to replace \@INDEX\@
   */
  virtual std::string getIndex1() const = 0;

  /**
   * @brief get the index of the second model
   * @return index of the second model to replace \@INDEX\@
   */
  virtual std::string getIndex2() const = 0;

  /**
   * @brief get the name of the first model
   * @return name of the first model to replace \@NAME\@
   */
  virtual std::string getName1() const = 0;

  /**
   * @brief get the name of the second model
   * @return name of the second model to replace \@NAME\@
   */
  virtual std::string getName2() const = 0;

  class Impl;  // Implementation class
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDMACROCONNECT_H_
