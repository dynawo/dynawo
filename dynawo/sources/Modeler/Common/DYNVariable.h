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
 * @file  DYNVariable.h
 *
 * @brief Dynawo variable : header file
 *
 */
#ifndef MODELER_COMMON_DYNVARIABLE_H_
#define MODELER_COMMON_DYNVARIABLE_H_

#include <string>
#include "DYNEnumUtils.h"

namespace DYN {

/**
 * @class Variable
 * @brief Variable implemented class
 *
 * Implementation of variable class : store each information needed by dynawo to deal with a variable
 */
class Variable {
 public:
  /**
   * @brief Destructor
   */
  virtual ~Variable() = default;

  /**
   * @brief Getter for variable's name
   *
   * @return variable's name
   */
  inline const std::string& getName() const {
    return name_;
  }

  /**
   * @brief Getter for variable's type
   *
   * @return variable's type
   */
  virtual typeVar_t getType() const = 0;

  /**
   * @brief Getter for variable's negated attribute
   *
   * @return @b true is the variable is negated, @b false else
   */
  virtual bool getNegated() const = 0;

  /**
   * @brief Getter for variable's index
   *
   * @return variable index
   */
  virtual int getIndex() const = 0;

  /**
   * @brief Getter for whether the variable is a state variable
   * a variable is a state variable if and only if it is required for local model simulation
   * a variable which is not a state variable is called a "calculated" variable
   * @return @b whether it is a state variable
   */
  virtual bool isState() const = 0;

  /**
   * @brief Getter for the variable alias (or native) attribute
   *
   * @return isAlias attribute of the variable
   */
  inline bool isAlias() const {
    return isAlias_;
  }

 protected:
  /**
   * @brief Constructor
   *
   * @param name name of the variable
   * @param isAlias @b whether the variable is an alias (or a native variable)
   */
  Variable(const std::string& name, bool isAlias);

 private:
  Variable();  ///< Private default constructor

  const std::string name_;  ///< name of the variable
  const bool isAlias_;  ///< @b whether the variable is an alias pointing towards another variable, or a "native" variable
};
}  // namespace DYN

#endif  // MODELER_COMMON_DYNVARIABLE_H_
