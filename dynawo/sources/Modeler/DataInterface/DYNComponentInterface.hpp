//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
//

/**
 * @file  DYNComponentInterface.hpp
 *
 * @brief Implementation of template methods
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNCOMPONENTINTERFACE_HPP_
#define MODELER_DATAINTERFACE_DYNCOMPONENTINTERFACE_HPP_

#include "DYNComponentInterface.h"
#include "DYNStateVariable.h"
#include "DYNStaticParameter.h"
#include "DYNMacrosMessage.h"

#include <unordered_map>


namespace DYN {

template <typename T>
T ComponentInterface::getStaticParameterValue(const std::string& name) const {
  std::unordered_map<std::string, StaticParameter>::const_iterator iter = staticParameters_.find(name);
  if (iter != staticParameters_.end()) {
    StaticParameter::StaticParameterType type = iter->second.getType();
    if (!iter->second.valueAffected()) {
      throw DYNError(Error::MODELER, UnaffectedStaticParameter, name, getID());
    } else {
      switch (type) {
        case StaticParameter::INT:
          return static_cast<T>(iter->second.getValue<int>());
          break;
        case StaticParameter::DOUBLE:
          return static_cast<T>(iter->second.getValue<double>());
          break;
        case StaticParameter::BOOL:
          return static_cast<T>(iter->second.getValue<bool>());
          break;
        default:
          throw DYNError(Error::MODELER, StaticParameterWrongType, name);
      }
    }
  } else {
    throw DYNError(Error::MODELER, UnknownStaticParameter, name, getID());
  }

  return T();
}

template <typename T>
T ComponentInterface::getValue(const int index) const {
#ifdef _DEBUG_
  if (checkStateVariableAreUpdatedBeforeCriteriaCheck_) {
    assert(stateVariables_[index].isNeededForCriteriaCheck() && "Found a variable used in checkCriteria but not updated during model update.");
  }
#endif
  if (!stateVariables_[index].valueAffected()) {
    throw DYNError(Error::MODELER, UnaffectedStateVariable, stateVariables_[index].getName(), getID());
  } else {
    switch (stateVariables_[index].getType()) {
      case StateVariable::INT:
        return static_cast<T>(stateVariables_[index].getValue<int>());
        break;
      case StateVariable::DOUBLE:
        return static_cast<T>(stateVariables_[index].getValue<double>());
        break;
      case StateVariable::BOOL:
        return static_cast<T>(stateVariables_[index].getValue<bool>());
        break;
    }
  }
  return T();
}

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNCOMPONENTINTERFACE_HPP_
