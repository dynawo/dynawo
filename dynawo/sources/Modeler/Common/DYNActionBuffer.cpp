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
ActionBuffer::applyActions() {
  std::lock_guard<std::mutex> actionLock(actionsMutex_);
  for (auto& actionPair : actions_)
    actionPair.second.apply();
  actions_.clear();
}

void
ActionBuffer::addAction(const boost::shared_ptr<SubModel>& subModel, Action::ActionParameters& parameterValueSet) {
  Action newAction = Action(subModel, parameterValueSet);
  std::lock_guard<std::mutex> actionLock(actionsMutex_);
  std::unordered_map<std::string, Action>::iterator actionIt = actions_.find(subModel->name());
  if (actionIt != actions_.end()) {
    if (subModel->name() == "NETWORK") {
      actionIt->second.updateParameterValueSet(parameterValueSet);
      Trace::debug() << DYNLog(ActionListExtendedNetwork) << Trace::endline;
    } else {
      actionIt->second = newAction;
      Trace::warn() << DYNLog(ActionListOverriden, subModel->name()) << Trace::endline;
    }
  } else {
    Trace::debug() << DYNLog(ActionRegistered, subModel->name()) << Trace::endline;
    actions_.emplace(subModel->name(), newAction);
  }
}
}  // end of namespace DYN
