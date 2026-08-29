//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
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
 * @file  FSVFinalStateValue.h
 *
 * @brief Dynawo final state value : interface file
 *
 */
#ifndef API_FSV_FSVFINALSTATEVALUE_H_
#define API_FSV_FSVFINALSTATEVALUE_H_

#include <limits>
#include <string>

namespace finalStateValues {
/**
 * @class FinalStateValue
 * @brief FinalStateValue interface class
 *
 * Interface class for final state value object.
 */
class FinalStateValue {
 public:
  /**
   * @brief Constructor
   */
  FinalStateValue();

  /**
   * @brief Setter for final state value's model name
   * @param modelName final state value's model name
   */
  void setModelName(const std::string& modelName);

  /**
   * @brief Setter for final state value's variable
   * @param variable final state value's variable
   */
  void setVariable(const std::string& variable);

  /**
   * @brief Setter for final state value's value
   * @param value final state value's value
   */
  void setValue(double value);

  /**
   * @brief Getter for final state value's model name
   * @return model name associated to this final state value
   */
  const std::string& getModelName() const;

  /**
   * @brief Getter for final state value's variable
   * @return variable name associated to this final state value
   */
  const std::string& getVariable() const;

  /**
   * @brief Getter for final state value's value
   * @return value associated to this final state value
   */
  double getValue() const;

 private:
  // attributes read in input file
  std::string modelName_;  ///< Model's name for which we want to have a final state value
  std::string variable_;   ///< Variable name
  double value_;           ///< Value
};

}  // namespace finalStateValues

#endif  // API_FSV_FSVFINALSTATEVALUE_H_
