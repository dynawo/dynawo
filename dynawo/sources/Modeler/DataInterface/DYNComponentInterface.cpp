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
 * @file  DYNComponentInterface.cpp
 *
 * @brief
 *
 */

#include "DYNComponentInterface.hpp"
#include "DYNSubModel.h"
#include "DYNVariable.h"
#include "DYNTrace.h"

using boost::shared_ptr;
using std::string;
using std::map;

namespace DYN {

ComponentInterface::ComponentInterface(bool hasInitialConditions) :
type_(UNKNOWN),
hasDynamicModel_(false),
hasInitialConditions_(hasInitialConditions) {
#ifdef _DEBUG_
  checkStateVariableAreUpdatedBeforeCriteriaCheck_ = false;
#endif
}

void
ComponentInterface::hasDynamicModel(bool hasDynamicModel) {
  hasDynamicModel_ = hasDynamicModel;
}

bool
ComponentInterface::hasDynamicModel() const {
  return hasDynamicModel_;
}

void
ComponentInterface::hasInitialConditions(bool hasInitialConditions) {
  hasInitialConditions_ = hasInitialConditions;
}

bool
ComponentInterface::hasInitialConditions() const {
  return hasInitialConditions_;
}

void
ComponentInterface::setModelDyn(const shared_ptr<SubModel>& model) {
  modelDyn_ = model;
}

void
ComponentInterface::setReference(const string& componentVar, const string& modelId, const string& modelVar) {
  int index = getComponentVarIndex(componentVar);
  if (index == -1)
    throw DYNError(Error::MODELER, UnknownStateVariable, componentVar, getID());
  stateVariables_[index].setModelId(modelId);
  stateVariables_[index].setVariableId(modelVar);
}

void
ComponentInterface::updateFromModel(bool filterForCriteriaCheck) {
  for (unsigned int i =0; i< stateVariables_.size(); ++i) {
    StateVariable& var = stateVariables_[i];
    if (!filterForCriteriaCheck || var.isNeededForCriteriaCheck())
      var.setValue(modelDyn_->getVariableValue(var.getVariable()));
  }
}

void
ComponentInterface::exportStateVariables() {
  try {
    exportStateVariablesUnitComponent();
  } catch (const DYN::Error& e) {
    if (e.key() == KeyError_t::UnaffectedStateVariable) {
      Trace::warn() << e.what() << Trace::endline;
    } else if (e.key() == KeyError_t::UnknownStateVariable) {
      throw;   // only two possible errors for instant
    }
  }
}

void
ComponentInterface::getStateVariableReference() {
  assert(modelDyn_);
  for (unsigned int i=0; i< stateVariables_.size(); ++i) {
    try {
      if (hasDynamicModel_)
        stateVariables_[i].setVariable(modelDyn_->getVariable(stateVariables_[i].getVariableId()));
      else  /// specific for network models
        stateVariables_[i].setVariable(modelDyn_->getVariable(stateVariables_[i].getModelId() + "_" + stateVariables_[i].getVariableId()));
    } catch (const DYN::Error &) {
      throw DYNError(Error::MODELER, StateVariableNoReference, stateVariables_[i].getName(), getID());
    }
  }
}

bool
ComponentInterface::isConnected() const {
  return false;  // default connection state
}

bool
ComponentInterface::isPartiallyConnected() const {
  // only components with multiple ends should override this
  // for components with only one end being partially connected is equivalent to being connected
  return isConnected();
}

void
ComponentInterface::setType(const ComponentInterface::ComponentType_t& type) {
  type_ = type;
}

const ComponentInterface::ComponentType_t&
ComponentInterface::getType() const {
  return type_;
}

const std::string&
ComponentInterface::getTypeAsString() const {
  static const std::string stringTypes[] = {
      "UNKNOWN",
      "BUS",
      "CALCULATED_BUS",
      "SWITCH",
      "LOAD",
      "LINE",
      "GENERATOR",
      "SHUNT",
      "DANGLING_LINE",
      "TWO_WINDINGS_TRANSFORMER",
      "THREE_WINDINGS_TRANSFORMER",
      "STATIC_VAR_COMPENSATOR",
      "VSC_CONVERTER",
      "LCC_CONVERTER",
      "HVDC_LINE"
    };
  ComponentType_t type = type_;
  if (type < UNKNOWN || type >= COMPONENT_TYPE_COUNT)
    type = UNKNOWN;
  return stringTypes[type];
}

#ifdef _DEBUG_
void
ComponentInterface::enableCheckStateVariable() {
  checkStateVariableAreUpdatedBeforeCriteriaCheck_ = true;
}

void ComponentInterface::disableCheckStateVariable() {
  checkStateVariableAreUpdatedBeforeCriteriaCheck_ = false;
}

void ComponentInterface::setValue(const int index, const double value) {
  if (!stateVariables_[index].valueAffected()) {
    throw DYNError(Error::MODELER, UnaffectedStateVariable, stateVariables_[index].getName(), getID());
  } else {
    stateVariables_[index].setValue(value);
  }
}
#endif

}  // namespace DYN
