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
   * @brief Destructor
   */
  virtual ~Variable() { }

  /**
   * @brief Setter for variable's id
   * @param id variable's id
   */
  virtual void setId(const std::string& id) = 0;

  /**
   * @brief Setter for variable's value
   * @param value variable's value
   */
  virtual void setValue(const double& value) = 0;

  /**
   * @brief Getter for variable's id
   * @return id of the variable
   */
  virtual std::string getId() const = 0;

  /**
   * @brief Getter for variable's value
   * @return value of the variable
   */
  virtual double getValue() const = 0;

  /**
   * @brief Getter for variable's available attribute
   * @return @b true if the value is available, @b false else
   */
  virtual bool getAvailable() const = 0;

  class Impl;
};
}  // namespace finalState

#endif  // API_FS_FSVARIABLE_H_
