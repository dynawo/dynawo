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
 * @file  FSVariable.h
 *
 * @brief final state variable : interface file
 *
 */
#ifndef API_FS_FSVARIABLE_H_
#define API_FS_FSVARIABLE_H_

#include <string>

namespace finalState {

/**
 * @class Variable
 * @brief final state variable interface class
 *
 * Variable is a container for a final state requested variable
 */
class Variable {
 public:
  /**
   * @brief Constructor
   *
   * @param id variable's id
   */
  explicit Variable(const std::string& id);

  /**
   * @brief Setter for variable's id
   * @param id variable's id
   */
  void setId(const std::string& id);

  /**
   * @brief Setter for variable's value
   * @param value variable's value
   */
  void setValue(const double& value);

  /**
   * @brief Getter for variable's id
   * @return id of the variable
   */
  const std::string& getId() const {
    return id_;
  }

  /**
   * @brief Getter for variable's value
   * @return value of the variable
   */
  double getValue() const {
    return value_;
  }

  /**
   * @brief Getter for variable's available attribute
   * @return @b true if the value is available, @b false else
   */
  bool getAvailable() const {
    return available_;
  }

 private:
  std::string id_;  ///< variable's id
  double value_;    ///< variable's value
  bool available_;  ///< @b true is the value is available, @b false else
};
}  // namespace finalState

#endif  // API_FS_FSVARIABLE_H_
