//
// Copyright (c) 2025, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

/**
 * @file  DYNActionBuffer.cpp
 *
 * @brief Action buffer implementation
 *
 */

#include "DYNTrace.h"

#include "DYNActionBuffer.h"
#include "DYNModelMulti.h"

namespace DYN {

void
ActionBuffer::setModel(std::shared_ptr<Model>& model) {
  model_ = model;
}

void
ActionBuffer::applyActions() {
  std::lock_guard<std::mutex> actionLock(actionsMutex_);
  for (auto& actionPair : actions_)
    actionPair.second.apply();
  actions_.clear();
}

bool
ActionBuffer::registerAction(ActionMessage& actionMessage) {
  std::istringstream stream(actionMessage.payload);
  std::string token;
  std::string subModelName;

  // Read the id (first part before the first comma)
  std::getline(stream, subModelName, ',');

  std::shared_ptr<ModelMulti> model = std::dynamic_pointer_cast<ModelMulti>(model_);
  boost::shared_ptr<SubModel> subModel = model->findSubModelByName(subModelName);
  if (!subModel) {
    Trace::error() << "ActionBuffer: Impossible to register action. Unknown SubModel: " << subModelName << Trace::endline;
    return false;
  }

  std::vector<std::tuple<std::string, boost::any, DYN::typeVarC_t>> parameterValueSet;
  // Read the rest of the parameter-value pairs
  while (std::getline(stream, token, ',')) {
    // parse the triple
    std::string name = token;
    std::string value;

    if (std::getline(stream, token, ',')) {
        value = token;
    } else {
      Trace::error() << "ActionBuffer: Could not parse action, incomplete data" << Trace::endline;
      return false;
    }

    if (subModel->hasParameterDynamic(name)) {
      const ParameterModeler& parameter = subModel->findParameterDynamic(name);
      boost::any castedValue;
      switch (parameter.getValueType()) {
        case VAR_TYPE_DOUBLE: {
          castedValue = std::stod(value);
          break;
        }
        case VAR_TYPE_INT: {
          castedValue = std::stoi(value);
          break;
        }
        case VAR_TYPE_BOOL: {
          bool bval = std::stoi(value);
          castedValue = bval;
          break;
        }
        case VAR_TYPE_STRING: {
          castedValue = value;
          break;
        }
        default:
        {
          throw DYNError(Error::MODELER, ParameterBadType, parameter.getName());
        }
      }

      parameterValueSet.push_back(std::make_tuple(name, castedValue, parameter.getValueType()));
    } else {
      Trace::warn() << "ActionBuffer: Parameter: " << name << " does not exist" << Trace::endline;
      return false;
    }
  }

  Action newAction = Action(subModel, parameterValueSet);
  {
    std::lock_guard<std::mutex> actionLock(actionsMutex_);
    std::unordered_map<std::string, Action>::iterator actionIt = actions_.find(subModelName);
    if (actionIt != actions_.end()) {
      if (subModelName == "NETWORK") {
        actionIt->second.updateParameterValueSet(parameterValueSet);
        Trace::info() << "ActionBuffer: Action list extended for NETWORK SubModel" << Trace::endline;
      } else {
        actionIt->second = newAction;
        Trace::warn() << "ActionBuffer: Actions overriden for SubModel: " << subModelName << Trace::endline;
      }
    } else {
      Trace::info() << "ActionBuffer: New action registered on model: " << subModelName << Trace::endline;
      actions_.emplace(subModelName, newAction);
    }
  }
  return true;
}
}  // end of namespace DYN
