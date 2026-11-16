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
 * @file  DYNStateVariable.cpp
 *
 * @brief State variable description : implementation file
 *
 */
#ifdef _DEBUG_
#include <cmath>
#endif

#include "DYNStateVariable.h"
#include "DYNVariable.h"
#ifdef _DEBUG_
#include "DYNTrace.h"
#endif
using std::string;

namespace DYN {

namespace {

/**
 * @brief assign a value to a state variable storage
 * @details the value is written in place when the storage already holds a value of the same type,
 * which avoids a memory allocation at each update (state variables are updated at each criteria check)
 * @param storage storage of the state variable value
 * @param newValue value to assign
 */
template<typename T>
void
assignValue(boost::optional<boost::any>& storage, const T& newValue) {
  if (storage) {
    T* currentValue = boost::any_cast<T>(&storage.get());
    if (currentValue) {
      *currentValue = newValue;
      return;
    }
  }
  storage = boost::any(newValue);
}

}  // namespace

StateVariable::StateVariable() :
type_(StateVariable::DOUBLE),  // most used type
valueAffected_(false),
neededForCriteriaCheck_(false) {
}

StateVariable::StateVariable(const string& name, const StateVariableType& type, bool neededForCriteriaCheck) :
type_(type),
name_(name),
valueAffected_(false),
neededForCriteriaCheck_(neededForCriteriaCheck) {
}

string
StateVariable::getName() const {
  return name_;
}

StateVariable::StateVariableType
StateVariable::getType() const {
  return type_;
}

void
StateVariable::setModelId(const string& modelId) {
  modelId_ = modelId;
}

string
StateVariable::getModelId() const {
  return modelId_;
}

void
StateVariable::setVariableId(const string& variableId) {
  variableId_ = variableId;
}

string
StateVariable::getVariableId() const {
  return variableId_;
}

void
StateVariable::setVariable(const boost::shared_ptr<Variable>& variable) {
  variable_ = variable;

#ifdef _DEBUG_
  // Sanity check
  switch (variable->getType()) {
    case CONTINUOUS:
    case FLOW: {
      if (getType() != DOUBLE) {
        throw DYNError(Error::MODELER, StateVariableWrongType, name_, typeAsString(type_), "double");
      }
      break;
    }
    case DISCRETE: {
      if (getType() != DOUBLE && getType() != INT) {
        throw DYNError(Error::MODELER, StateVariableWrongType, name_, typeAsString(type_), "double or int");
      }
      break;
    }
    case INTEGER: {
      if (getType() != INT) {
        throw DYNError(Error::MODELER, StateVariableWrongType, name_, typeAsString(type_), "int");
      }
      break;
    }
    case BOOLEAN: {
      if (getType() != BOOL) {
        throw DYNError(Error::MODELER, StateVariableWrongType, name_, typeAsString(type_), "bool");
      }
      break;
    }
    case UNDEFINED_TYPE:
    {
      throw DYNError(Error::MODELER, ModelFuncError, "Unsupported variable type");
    }
  }
#endif
}

boost::shared_ptr<Variable>
StateVariable::getVariable() const {
  return variable_;
}

bool
StateVariable::valueAffected() const {
  return valueAffected_;
}

bool
StateVariable::isNeededForCriteriaCheck() const {
  return neededForCriteriaCheck_;
}

/**
 * @brief Set the value of a state variable
 * @param value double value to use
 * Specific case for dynawo
 * if the StateVariable is a boolean value, in modelica the value will be processed as a double
 * -1 -> false
 * 1 -> true
 * the same goes for integer values
 */
void
StateVariable::setValue(const double& value) {
  switch (type_) {
  case BOOL :
#ifdef _DEBUG_
    if (!doubleEquals(value, 0.) && !doubleEquals(value, 1.) && !doubleEquals(value, -1.))
      throw DYNError(Error::MODELER, StateVariableWrongType, name_, typeAsString(type_), "bool");
#endif
    assignValue(value_, value > 0);
    break;
  case DOUBLE :
    assignValue(value_, value);
    break;
  case INT :
#ifdef _DEBUG_
    if (!doubleEquals(((value > 0) ? std::floor(value) : std::ceil(value)), value)) {  // Test to check if this is an integer
      throw DYNError(Error::MODELER, StateVariableWrongType, name_, typeAsString(type_), "double");
    }
#endif
    assignValue(value_, static_cast<int>(value));
    break;
  }
  valueAffected_ = true;
}

string
StateVariable::typeAsString(const StateVariableType& type) {
  string stringType = "";
  switch (type) {
    case INT:
      stringType = "INT";
      break;
    case BOOL:
      stringType = "BOOL";
      break;
    case DOUBLE:
      stringType = "DOUBLE";
      break;
  }
  return stringType;
}

}  // namespace DYN
