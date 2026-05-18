//
// Copyright (c) 2026, RTE (http://www.rte-france.com)
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
 * @file MANDATORYPARAMParameter.h
 * @brief Mandatory parameter description : interface file
 */

#ifndef API_MANDATORYPARAM_MANDATORYPARAMPARAMETER_H_
#define API_MANDATORYPARAM_MANDATORYPARAMPARAMETER_H_

#include <string>

namespace mandatoryParameters {

/**
 * @class Parameter
 * @brief Represents a single mandatory parameter (no default value in the Modelica model)
 */
class Parameter {
 public:
  /**
   * @brief Constructor
   * @param name parameter name
   * @param type parameter type as a string (e.g. "DOUBLE", "INT", "BOOL", "STRING")
   */
  Parameter(const std::string& name, const std::string& type);

  /**
   * @brief Parameter name getter
   * @return name of the parameter
   */
  const std::string& getName() const;

  /**
   * @brief Parameter type getter
   * @return type of the parameter
   */
  const std::string& getType() const;

 private:
  std::string name_;  ///< name of the parameter
  std::string type_;  ///< type of the parameter
};

}  // namespace mandatoryParameters

#endif  // API_MANDATORYPARAM_MANDATORYPARAMPARAMETER_H_
