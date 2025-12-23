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

namespace dynamicdata {

/**
 * @class Connector
 * @brief Dynawo connector interface class
 *
 * Connector objects describe a dynamic connection between two models
 */
class Connector {
 public:
  /**
   * @brief Connector::Impl constructor
   *
   * Connector::Impl constructor.
   *
   * @param model1  Shared pointer to the first model
   * @param var1   First model connected port name
   * @param model2 Shared pointer to the second model
   * @param var2  Second model connected port name
   * @param componentId ID of model in network, if applicable
   */
  Connector(const std::string& model1, const std::string& var1, const std::string& model2, const std::string& var2, const std::string& componentId);

  /**
   * @brief First model getter
   *
   * @return First model shared pointer
   */
  const std::string& getFirstModelId() const;

  /**
   * @brief First model connected variable getter
   *
   * @return First model connected variable name
   */
  const std::string& getFirstVariableId() const;

  /**
   * @brief Second model getter
   *
   * @return Second model shared pointer
   */
  const std::string& getSecondModelId() const;

  /**
   * @brief Second model connected variable getter
   *
   * @return Second model connected variable name
   */
  const std::string& getSecondVariableId() const;

    /**
   * @brief Component ID getter
   *
   * @return the component ID
   */
  const std::string& getComponentId() const;

 private:
  std::string firstModelId_;     /**< Model name for the first Model */
  std::string firstVariableId_;  /**< Variable name for the first Model */
  std::string secondModelId_;    /**< Model name for the second Model */
  std::string secondVariableId_; /**< Variable name for the second Model */
  std::string componentId_;      /**< ID of the network component */
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDCONNECTOR_H_
