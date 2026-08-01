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
 * @file  DYNVariableNative.h
 *
 * @brief Dynawo native (non alias) variable : header file
 *
 */
#ifndef MODELER_COMMON_DYNVARIABLENATIVE_H_
#define MODELER_COMMON_DYNVARIABLENATIVE_H_

#include <string>

#include <boost/optional.hpp>

#include "DYNEnumUtils.h"
#include "DYNVariable.h"

namespace DYN {

/**
 * @class VariableNative
 * @brief native variable class with values
 *
 * Implementation of native variable class : store each information needed by dynawo to deal with a variable
 */
class VariableNative : public Variable {
 public:
  /**
   * @brief Constructor
   *
   * @param name name of the variable
   * @param type Type of the variable
   * @param isState @b whether the variable is a state variable
   * @param negated @b if the variable is negated
   */
  VariableNative(const std::string& name, typeVar_t type, bool isState, bool negated);

  /**
   * @brief Destructor
   */
  ~VariableNative() override = default;

  /**
   * @brief Setter for variable's index
   *
   * @param index index of the variable
   */
  void setIndex(int index);

  /**
   * @brief Getter for variable's type
   *
   * @return variable's type
   */
  inline typeVar_t getType() const override {
    return type_;
  }

  /**
   * @brief Getter for variable's negated attribute
   *
   * @return @b true is the variable is negated, @b false else
   */
  inline bool getNegated() const override {
    return negated_;
  }

  /**
   * @brief check whether the variable index is already set
   *
   * @return @b whether the variable index is already set
   */
  bool indexSet() const;

  /**
   * @brief Getter for variable's index
   *
   * @return variable index
   */
  int getIndex() const override;

  /**
   * @brief Getter for whether the variable is a state variable
   *
   * @return @b whether it is a state variable
   */
  bool isState() const override;

 private:
  VariableNative();  ///< Private default constructor

  const typeVar_t type_;  ///< Type of the variable
  const bool isState_;  ///< @b whether the variable is a state variable
  const bool negated_;  ///< @b whether the variable is negated
  boost::optional<int> index_;  ///< Index of the variable in the vector of variable of same type
};
}  // namespace DYN

#endif  // MODELER_COMMON_DYNVARIABLENATIVE_H_
