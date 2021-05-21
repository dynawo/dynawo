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

ComponentInterface::ComponentInterface() :
type_(UNKNOWN) {
#ifndef LANG_CXX11
  hasDynamicModel_ = false;
#endif
#ifdef _DEBUG_
  checkStateVariableAreUpdatedBeforeCriteriaCheck_ = false;
#endif
}

ComponentInterface::~ComponentInterface() {
}

void
ComponentInterface::hasDynamicModel(bool hasDynamicModel) {
#ifdef LANG_CXX11
  auto thread_id = std::this_thread::get_id();
  if (dynamicDef_.count(thread_id) == 0) {
    std::unique_lock<std::mutex> lock(dynamicDefMutex_);
    dynamicDef_.insert({thread_id, DynamicModelDef(hasDynamicModel, nullptr)});
    return;
  }
  dynamicDef_.at(thread_id).hasDynamicModel_ = hasDynamicModel;
#else
  hasDynamicModel_ = hasDynamicModel;
#endif
}

bool
ComponentInterface::hasDynamicModel() const {
#ifdef LANG_CXX11
  auto thread_id = std::this_thread::get_id();
  if (dynamicDef_.count(thread_id) == 0) {
    return false;
  }
  return dynamicDef_.at(thread_id).hasDynamicModel_;
#else
  return hasDynamicModel_;
#endif
}

void
ComponentInterface::setModelDyn(const shared_ptr<SubModel>& model) {
#ifdef LANG_CXX11
  auto thread_id = std::this_thread::get_id();
  if (dynamicDef_.count(thread_id) == 0) {
    std::unique_lock<std::mutex> lock(dynamicDefMutex_);
    dynamicDef_.insert({thread_id, DynamicModelDef(false, model)});
    return;
  }
  dynamicDef_.at(thread_id).modelDyn_ = model;
#else
  modelDyn_ = model;
#endif
}

boost::shared_ptr<SubModel>
ComponentInterface::getModelDyn() const {
#ifdef LANG_CXX11
  auto thread_id = std::this_thread::get_id();
  if (dynamicDef_.count(thread_id) == 0) {
    return nullptr;
  }
  return dynamicDef_.at(thread_id).modelDyn_;
#else
  return modelDyn_;
#endif
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
      var.setValue(getModelDyn()->getVariableValue(var.getVariable()));
  }
}

void
ComponentInterface::exportStateVariables() {
  try {
    exportStateVariablesUnitComponent();
  } catch (const DYN::Error& e) {
    if (e.key() == KeyError_t::UnaffectedStateVariable) {
      Trace::error() << e.what() << Trace::endline;
    } else if (e.key() == KeyError_t::UnknownStateVariable) {
      throw;   // only two possible errors for instant
    }
  }
}

void
ComponentInterface::getStateVariableReference() {
  for (unsigned int i=0; i< stateVariables_.size(); ++i) {
    try {
      if (hasDynamicModel())
        stateVariables_[i].setVariable(getModelDyn()->getVariable(stateVariables_[i].getVariableId()));
      else  /// specific for network models
        stateVariables_[i].setVariable(getModelDyn()->getVariable(stateVariables_[i].getModelId() + "_" + stateVariables_[i].getVariableId()));
    } catch (const DYN::Error &) {
      throw DYNError(Error::MODELER, StateVariableNoReference, stateVariables_[i].getName(), getID());
    }
  }
}

void
ComponentInterface::setType(const ComponentInterface::ComponentType_t& type) {
  type_ = type;
}

const ComponentInterface::ComponentType_t&
ComponentInterface::getType() const {
  return type_;
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
