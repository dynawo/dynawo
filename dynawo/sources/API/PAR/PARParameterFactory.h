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
 * @file PARParameterFactory.h
 * @brief Dynawo parameter factory : header file
 *
 */

#ifndef API_PAR_PARPARAMETERFACTORY_H_
#define API_PAR_PARPARAMETERFACTORY_H_

#include "PARParameter.h"

#include <memory>


namespace parameters {
/**
 * @class ParameterFactory
 * @brief Parameter factory class
 *
 * ParameterFactory encapsulates methods for creating new
 * @p Parameter objects.
 */
class ParameterFactory {
 public:
  /**
   * @brief Create new Parameter instance
   *
   * @param[in] name id of the parameter
   * @param[in] boolValue value of the parameter
   *
   * @returns Unique pointer to a new @p Parameter
   */
  static std::unique_ptr<Parameter> newParameter(const std::string& name, const bool boolValue);

  /**
   * @brief Create new Parameter instance
   *
   * @param[in] name id of the parameter
   * @param[in] intValue value of the parameter
   *
   * @returns Unique pointer to a new @p Parameter
   */
  static std::unique_ptr<Parameter> newParameter(const std::string& name, const int intValue);

  /**
   * @brief Create new Parameter instance
   *
   * @param[in] name id of the parameter
   * @param[in] doubleValue value of the parameter
   *
   * @returns Unique pointer to a new @p Parameter
   */
  static std::unique_ptr<Parameter> newParameter(const std::string& name, const double doubleValue);

  /**
   * @brief Create new Parameter instance
   *
   * @param[in] name id of the parameter
   * @param[in] stringValue value of the parameter
   *
   * @returns Unique pointer to a new @p Parameter
   */
  static std::unique_ptr<Parameter> newParameter(const std::string& name, const std::string& stringValue);
};

}  // namespace parameters

#endif  // API_PAR_PARPARAMETERFACTORY_H_
