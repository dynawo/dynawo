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
 * @file  DYNVariableAlias.h
 *
 * @brief Dynawo alias variable : header file
 *
 */
#ifndef MODELER_COMMON_DYNVARIABLEALIAS_H_
#define MODELER_COMMON_DYNVARIABLEALIAS_H_

#include <string>

#include <boost/optional.hpp>
#include <boost/shared_ptr.hpp>

#include "DYNEnumUtils.h"
#include "DYNVariable.h"

namespace DYN {
class VariableNative;

/**
 * @class VariableAlias
 * @brief variable alias (points towards another variable)
 *
 * Implementation of alias variable class : only store information about destination variable
 */
class VariableAlias : public Variable {
 public:
  /**
   * @brief Constructor
   *
   * @param name name of the variable
   * @param refName name of the variable towards which the alias points
   * @param type Type of the variable
   * @param negated @b if the alias is negated
   */
  VariableAlias(const std::string& name, const std::string& refName, typeVar_t type, bool negated);

  /**
   * @brief Constructor
   *
   * @param name name of the variable
   * @param refVar the variable towards which the alias points
   * @param type Type of the variable
   * @param negated @b if the alias is negated
   */
  VariableAlias(const std::string& name, const boost::shared_ptr<VariableNative>& refVar, typeVar_t type, bool negated);

  /**
   * @brief Destructor
   */
  ~VariableAlias() override;

  /**
   * @brief Setter for alias reference variable
   *
   * @param refVar the variable towards which to point
   */
  void setReferenceVariable(const boost::shared_ptr<VariableNative>& refVar);

  /**
   * @brief Getter for variable's type
   *
   * @return variable's type
   */
  typeVar_t getType() const override;

  /**
   * @brief Getter for variable's local type (type the variable would have if it was not an alias)
   *
   * @return variable's type
   */
  typeVar_t getLocalType() const;

  /**
   * @brief Getter for variable's negated attribute
   *
   * @return @b if the variable is negated
   */
  bool getNegated() const override;

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

  /**
   * @brief Check whether the alias reference variable is already set
   *
   * @return @b if the reference variable is already set
   */
  bool referenceVariableSet() const;

  /**
   * @brief Getter for reference variable's name
   *
   * @return reference variable name
   */
  inline std::string getReferenceVariableName() const {
    return referenceName_;
  }

 private:
  /**
   * @brief Getter for (native) reference variable
   *
   * @return (native) reference variable
   */
  boost::shared_ptr<VariableNative> getReferenceVariable() const;

  VariableAlias();  ///< Private default constructor

  /**
   * @brief Sanity check: make sure local variable type is compatible with reference variable type
   * Otherwise throws an exception
   */
  void checkTypeCompatibility() const;

  const std::string referenceName_;  ///< the name of the (native) variable towards which the variable points
  const bool negated_;  ///< @b whether the variable is negated
  typeVar_t type_;  ///< Type of the variable (might be different of the reference variable, e.g. CONTINUOUS AND FLOW are both real values)

  boost::optional<boost::shared_ptr<VariableNative> > referenceVariable_;  ///< the native variable towards which the alias is pointing
};
}  // namespace DYN

#endif  // MODELER_COMMON_DYNVARIABLEALIAS_H_
