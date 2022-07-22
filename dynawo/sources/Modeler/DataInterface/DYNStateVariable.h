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
 * @file  DYNStateVariable.h
 *
 * @brief State variable description : header file
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNSTATEVARIABLE_H_
#define MODELER_DATAINTERFACE_DYNSTATEVARIABLE_H_

#include <string>
#include <boost/any.hpp>
#include <boost/optional.hpp>
#include <boost/shared_ptr.hpp>

namespace DYN {
class Variable;

/**
 * @class StateVariable
 * @brief State variable description class
 */
class StateVariable {
 public:
 /**
   * @brief Definition of the type of the state variable
   */
  enum StateVariableType {
    BOOL,  ///<  the state variable is a boolean one
    INT,  ///< the state variable is an integer one
    DOUBLE  ///< the state variable is a double one
  };

 public:
  /**
   * @brief default constructor
   */
  StateVariable();

  /**
   * @brief constructor
   *
   * @param name name of the state variable
   * @param type type of the state variable
   * @param neededForCriteriaCheck true if the state variable's value is needed for criteria check
   */
  StateVariable(const std::string& name, const StateVariableType& type, bool neededForCriteriaCheck = false);

  /**
   * @brief set the value of a state variable
   *
   * @param value new value of the state variable
   */
  void setValue(const double& value);

  /**
   * @brief getter of the state variable's name
   * @return name of the state variable
   */
  std::string getName() const;

  /**
   * @brief set the model id used to compute the stateVariable value
   * @param modelId model id
   */
  void setModelId(const std::string& modelId);

  /**
   * @brief get the model id used to compute the stateVariable value
   * @return model id
   */
  std::string getModelId() const;

  /**
   * @brief set the variable id inside the model to compute the stateVariable value
   * @param variableId variable id
   */
  void setVariableId(const std::string& variableId);

  /**
   * @brief get the variable id inside the model to compute the stateVariable value
   * @return variable id
   */
  std::string getVariableId() const;

  /**
   * @brief set the variable that store the value of the stateVariable
   * @param variable variable storing the value of the stateVariable
   */
  void setVariable(const boost::shared_ptr<Variable>& variable);

  /**
   * @brief get the variable that store the value of the stateVariable
   * @return variable storing the value of the stateVariable
   */
  boost::shared_ptr<Variable> getVariable() const;

  /**
   * @brief get the value of a variable
   * @return the value of the state variable
   */
  template<typename T> T getValue() const;

  /**
   * @brief get the type of a state variable
   * @return the type of a state variable
   */
  StateVariableType getType() const;

  /**
   * @brief check is the state variable has a value
   * @return @b true is the state variable's value is already affected
   */
  bool valueAffected() const;

  /**
   * @brief return the type of the state variable as a string
   * @param type type of the state variable
   * @return type of the state variable as a string
   */
  static std::string typeAsString(const StateVariableType& type);

  /**
   * @brief check is the state variable is needed for criteria check
   * @return @b true if the state variable's value is needed for criteria check
   */
  bool isNeededForCriteriaCheck() const;

 private:
  StateVariableType type_;  ///< type of the state variable
  boost::optional<boost::any> value_;  ///< value of the state variable
  std::string name_;  ///< name of the state variable
  std::string modelId_;  ///< id of the model associated to the state variable
  std::string variableId_;  ///< id of the variable associated to the state variable
  boost::shared_ptr<Variable> variable_;  ///< variable of the model associated to the state variable
  bool valueAffected_;  ///< true if value_ was set at least once
  bool neededForCriteriaCheck_;  ///< true if the state variable's value is needed for criteria check
};  ///< class for state variable
}  // namespace DYN

#include "DYNStateVariable.hpp"

#endif  // MODELER_DATAINTERFACE_DYNSTATEVARIABLE_H_
